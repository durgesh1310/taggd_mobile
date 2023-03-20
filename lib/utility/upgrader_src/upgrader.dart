/*
 * Copyright (c) 2018 Larry Aasen. All rights reserved.
 */

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ouat/utility/upgrader_src/upgrader_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
//import 'package:send_app/ui/custom_widget/update_screen.dart';
import 'package:ouat/utility/upgrader_src/play_store_search_api.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

import 'appcast.dart';
import 'itunes_search_api.dart';
import 'upgrade_messages.dart';

/// Signature of callbacks that have no arguments and return bool.
typedef BoolCallback = bool Function();

/// There are two different dialog styles: Cupertino and Material
enum UpgradeDialogStyle { cupertino, material }

/// A class to define the configuration for the appcast. The configuration
/// contains two parts: a URL to the appcast, and a list of supported OS
/// names, such as "android", "ios".
class AppcastConfiguration {
  final List<String>? supportedOS;
  final String? url;

  AppcastConfiguration({
    this.supportedOS,
    this.url,
  });
}

/// A singleton class to configure the upgrade dialog.
class Upgrader {
  static Upgrader _singleton = Upgrader._internal();

  /// The appcast configuration ([AppcastConfiguration]) used by [Appcast].
  /// When an appcast is configured for iOS, the iTunes lookup is not used.
  AppcastConfiguration? appcastConfig;

  /// Provide an Appcast that can be replaced for mock testing.
  Appcast? appcast;

  /// Provide an HTTP Client that can be replaced for mock testing.
  http.Client? client = http.Client();

  /// Duration until alerting user again
  Duration durationUntilAlertAgain = Duration(days: 3);

  /// For debugging, always force the upgrade to be available.
  bool debugDisplayAlways = false;

  /// For debugging, display the upgrade at least once once.
  bool debugDisplayOnce = false;

  /// Enable log statements for debugging.
  bool debugLogging = false;

  /// The localized messages used for display in upgrader.
  UpgraderMessages? messages;

  final notInitializedExceptionMessage =
      'initialize() not called. Must be called first.';

  /// Called when the ignore button is tapped or otherwise activated.
  /// Return false when the default behavior should not execute.
  BoolCallback? onIgnore;

  /// Called when the later button is tapped or otherwise activated.
  /// Return false when the default behavior should not execute.
  BoolCallback? onLater;

  /// Called when the update button is tapped or otherwise activated.
  /// Return false when the default behavior should not execute.
  BoolCallback? onUpdate;

  /// Called when the user taps outside of the dialog and [canDismissDialog]
  /// is false. Also called when the back button is pressed. Return true for
  /// the screen to be popped. Not used by [UpgradeCard].
  BoolCallback? shouldPopScope;

  /// Hide or show Ignore button on dialog (default: true)
  bool showIgnore = true;

  /// Hide or show Later button on dialog (default: true)
  bool showLater = true;

  /// Hide or show release notes (default: true)
  bool showReleaseNotes = true;

  /// Can alert dialog be dismissed on tap outside of the alert dialog. Not used by [UpgradeCard]. (default: false)
  bool canDismissDialog = false;

  /// The country code that will override the system locale. Optional. Used only for iOS.
  String? countryCode;

  /// The minimum app version supported by this app. Earlier versions of this app
  /// will be forced to update to the current version. Optional.
  String? minAppVersion;

  /// The upgrade dialog style. Optional. Used only on UpgradeAlert. (default: material)
  UpgradeDialogStyle? dialogStyle = UpgradeDialogStyle.material;

  /// The target platform.
  TargetPlatform platform = defaultTargetPlatform;

  /// The target operating system.
  String operatingSystem = Platform.operatingSystem;

  bool _displayed = false;
  bool _initCalled = false;
  PackageInfo? _packageInfo;

  String? _installedVersion;
  String? _appStoreVersion;
  String? _appStoreListingURL;
  String? _releaseNotes;
  String? _updateAvailable;
  DateTime? _lastTimeAlerted;
  String? _lastVersionAlerted;
  String? _userIgnoredVersion;
  bool _hasAlerted = false;
  bool _isCriticalUpdate = false;

  factory Upgrader() {
    return _singleton;
  }

  Upgrader._internal();

  void installPackageInfo({PackageInfo? packageInfo}) {
    _packageInfo = packageInfo;
    _initCalled = false;
  }

  void installAppStoreVersion(String version) {
    _appStoreVersion = version;
  }

  void installAppStoreListingURL(String url) {
    _appStoreListingURL = url;
  }

  Future<bool> initialize() async {
    if (_initCalled) {
      return true;
    }

    _initCalled = true;

    messages ??= UpgraderMessages();
    if (messages!.languageCode.isEmpty) {
      log('upgrader: error -> languageCode is empty');
    } else if (debugLogging) {
      log('upgrader: languageCode: ${messages!.languageCode}');
    }

    await _getSavedPrefs();

    if (debugLogging) {
      log('upgrader: default operatingSystem: '
          '${Platform.operatingSystem} ${Platform.operatingSystemVersion}');
      log('upgrader: operatingSystem: $operatingSystem');
      log('upgrader: platform: $platform');
    }

    if (_packageInfo == null) {
      _packageInfo = await PackageInfo.fromPlatform();
      if (debugLogging) {
        log('upgrader: package info packageName: ${_packageInfo!.packageName}');
        log('upgrader: package info appName: ${_packageInfo!.appName}');
        log('upgrader: package info version: ${_packageInfo!.version}');
      }
    }

    await _updateVersionInfo();

    _installedVersion = _packageInfo!.version;

    return true;
  }

  Future<bool> _updateVersionInfo() async {
    // If there is an appcast for this platform
    if (_isAppcastThisPlatform()) {
      if (debugLogging) {
        log('upgrader: appcast is available for this platform');
      }

      final appcast = this.appcast ?? Appcast(client: client);
      await appcast.parseAppcastItemsFromUri(appcastConfig!.url!);
      if (debugLogging) {
        var count = appcast.items == null ? 0 : appcast.items!.length;
        log('upgrader: appcast item count: $count');
      }
      final bestItem = appcast.bestItem();
      if (bestItem != null &&
          bestItem.versionString != null &&
          bestItem.versionString!.isNotEmpty) {
        if (debugLogging) {
          log('upgrader: appcast best item version: ${bestItem.versionString}');
        }
        _appStoreVersion ??= bestItem.versionString;
        _appStoreListingURL ??= bestItem.fileURL;
        if (bestItem.isCriticalUpdate) {
          _isCriticalUpdate = true;
        }
        _releaseNotes = bestItem.itemDescription;
      }
    } else {
      if (_packageInfo == null || _packageInfo!.packageName.isEmpty) {
        return false;
      }

      // The  country code of the locale, defaulting to `US`.
      final code = countryCode ?? findCountryCode();
      if (debugLogging) {
        log('upgrader: countryCode: $code');
      }

      // Get Android version from Google Play Store, or
      // get iOS version from iTunes Store.
      if (platform == TargetPlatform.android) {
        await _getAndroidStoreVersion();
      } else if (platform == TargetPlatform.iOS) {
        final iTunes = ITunesSearchAPI();
        iTunes.client = client;
        final country = code;
        final response = await (iTunes
            .lookupByBundleId(_packageInfo!.packageName, country: country));

        if (response != null) {
          _appStoreVersion ??= ITunesResults.version(response);
          _appStoreListingURL ??= ITunesResults.trackViewUrl(response);
          _releaseNotes ??= ITunesResults.releaseNotes(response);
        }
      }
    }

    return true;
  }

  /// Android info is fetched by parsing the html of the app store page.
  Future<bool?> _getAndroidStoreVersion() async {
    final id = _packageInfo!.packageName;
    final playStore = PlayStoreSearchAPI();
    final response = await (playStore.lookupById(id));
    if (response != null) {
      _appStoreVersion ??= PlayStoreResults.version(response);
      _appStoreListingURL ??= playStore.lookupURLById(id);
      _releaseNotes ??= PlayStoreResults.releaseNotes(response);
    }

    return true;
  }

  bool _isAppcastThisPlatform() {
    if (appcastConfig == null ||
        appcastConfig!.url == null ||
        appcastConfig!.url!.isEmpty) {
      return false;
    }

    // Since this appcast config contains a URL, this appcast is valid.
    // However, if the supported OS is not listed, it is not supported.
    // When there are no supported OSes listed, they are all supported.
    var supported = true;
    if (appcastConfig!.supportedOS != null) {
      supported = appcastConfig!.supportedOS!.contains(operatingSystem);
    }
    return supported;
  }

  bool _verifyInit() {
    if (!_initCalled) {
      throw (notInitializedExceptionMessage);
    }
    return true;
  }

  String appName() {
    _verifyInit();
    return _packageInfo?.appName ?? '';
  }

  String? currentAppStoreListingURL() => _appStoreListingURL;

  String? currentAppStoreVersion() => _appStoreVersion;

  String? currentInstalledVersion() => _installedVersion;

  String? get releaseNotes => _releaseNotes;

  String message() {
    var msg = messages!.message(UpgraderMessage.body)!;
    msg = msg.replaceAll('{{appName}}', appName());
    msg = msg.replaceAll(
        '{{currentAppStoreVersion}}', currentAppStoreVersion() ?? '');
    msg = msg.replaceAll(
        '{{currentInstalledVersion}}', currentInstalledVersion() ?? '');
    return msg;
  }

  /// Only called by [UpgradeAlert].
  void checkVersion({required BuildContext context}) {
    if (!_displayed) {
      final shouldDisplay = shouldDisplayUpgrade();
      log(shouldDisplay.toString());
      if (debugLogging) {
        log('upgrader: shouldDisplayUpgrade: $shouldDisplay');
        log('upgrader: shouldDisplayReleaseNotes: ${shouldDisplayReleaseNotes()}');
      }
      if (shouldDisplay) {
        // log(UpgraderMessage.prompt);
        // log(UpgraderMessages);
        _displayed = true;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AppUpdatedScreen(
                      versionName: _appStoreVersion ?? "",
                      whatsNew: _releaseNotes,
                      onCallback: () {
                        // Navigator.pop(context);
                        onUserUpdated(context, !blocked());
                        // To do
                      },
                    )));

        //
        // Future.delayed(Duration(milliseconds: 0), () {
        //   _showDialog(
        //       context: context,
        //       title: messages!.message(UpgraderMessage.title),
        //       message: message(),
        //       releaseNotes: shouldDisplayReleaseNotes() ? _releaseNotes : null,
        //       canDismissDialog: canDismissDialog);
        // });
      }
    }
  }

  bool blocked() {
    return belowMinAppVersion() || _isCriticalUpdate;
  }

  bool shouldDisplayUpgrade() {
    final isBlocked = blocked();

    if (debugLogging) {
      log('upgrader: blocked: $isBlocked');
      log('upgrader: debugDisplayAlways: $debugDisplayAlways');
      log('upgrader: debugDisplayOnce: $debugDisplayOnce');
      log('upgrader: hasAlerted: $_hasAlerted');
    }

    // If installed version is below minimum app version, or is a critical update,
    // disable ignore and later buttons.
    if (isBlocked) {
      showIgnore = false;
      showLater = false;
    }
    if (debugDisplayAlways || (debugDisplayOnce && !_hasAlerted)) {
      return true;
    }
    if (!isUpdateAvailable()) {
      return false;
    }
    if (isBlocked) {
      return true;
    }
    if (isTooSoon() || alreadyIgnoredThisVersion()) {
      return false;
    }
    return true;
  }

  /// Is installed version below minimum app version?
  bool belowMinAppVersion() {
    var rv = false;
    if (minAppVersion != null) {
      try {
        final minVersion = Version.parse(minAppVersion!);
        final installedVersion = Version.parse(_installedVersion!);
        rv = installedVersion < minVersion;
      } catch (e) {
        // log(e);
      }
    }
    return rv;
  }

  bool isTooSoon() {
    if (_lastTimeAlerted == null) {
      return false;
    }

    final lastAlertedDuration = DateTime.now().difference(_lastTimeAlerted!);
    final rv = lastAlertedDuration < durationUntilAlertAgain;
    if (rv && debugLogging) {
      log('upgrader: isTooSoon: true');
    }
    return rv;
  }

  bool alreadyIgnoredThisVersion() {
    final rv =
        _userIgnoredVersion != null && _userIgnoredVersion == _appStoreVersion;
    if (rv && debugLogging) {
      log('upgrader: alreadyIgnoredThisVersion: true');
    }
    return rv;
  }

  bool isUpdateAvailable() {
    // log(_appStoreVersion);
    if (debugLogging) {
      log('upgrader: appStoreVersion: $_appStoreVersion');
      log('upgrader: installedVersion: $_installedVersion');
      log('upgrader: minAppVersion: $minAppVersion');
    }
    if (_appStoreVersion == null || _installedVersion == null) {
      if (debugLogging) {
        log('upgrader: isUpdateAvailable: false');
      }
      return false;
    }

    if (_updateAvailable == null) {
      final appStoreVersion = Version.parse(_appStoreVersion!);
      final installedVersion = Version.parse(_installedVersion!);

      final available = appStoreVersion > installedVersion;
      _updateAvailable = available ? _appStoreVersion : null;
    }
    if (debugLogging) {
      log('upgrader: isUpdateAvailable: ${_updateAvailable != null}');
    }
    return _updateAvailable != null;
  }

  bool shouldDisplayReleaseNotes() {
    return showReleaseNotes && (_releaseNotes?.isNotEmpty ?? false);
  }

  /// Determine the current country code, either from the context, or
  /// from the system-reported default locale of the device. The default
  /// is `US`.
  String? findCountryCode({BuildContext? context}) {
    Locale? locale;
    if (context != null) {
      locale = Localizations.maybeLocaleOf(context);
    } else {
      // Get the system locale
      locale = WidgetsBinding.instance!.window.locale;
    }
    final code = locale == null || locale.countryCode == null
        ? 'US'
        : locale.countryCode;
    return code;
  }

  void _showDialog(
      {required BuildContext context,
      required String? title,
      required String message,
      required String? releaseNotes,
      required bool canDismissDialog}) {
    if (debugLogging) {
      log('upgrader: showDialog title: $title');
      log('upgrader: showDialog message: $message');
      log('upgrader: showDialog releaseNotes: $releaseNotes');
    }

    // Save the date/time as the last time alerted.
    saveLastAlerted();

    showDialog(
      barrierDismissible: canDismissDialog,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => _shouldPopScope(),
          child: dialogStyle == UpgradeDialogStyle.material
              ? _alertDialog(title!, message, releaseNotes, context)
              : _cupertinoAlertDialog(title!, message, releaseNotes, context),
        );
      },
    );
  }

  /// Called when the user taps outside of the dialog and [canDismissDialog]
  /// is false. Also called when the back button is pressed. Return true for
  /// the screen to be popped. Defaults to false.
  bool _shouldPopScope() {
    if (debugLogging) {
      log('upgrader: onWillPop called');
    }
    if (shouldPopScope != null) {
      final should = shouldPopScope!();
      if (debugLogging) {
        log('upgrader: shouldPopScope=$should');
      }
      return should;
    }

    return false;
  }

  AlertDialog _alertDialog(String title, String message, String? releaseNotes,
      BuildContext context) {
    Widget? notes;
    if (releaseNotes != null) {
      notes = Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Release Notes:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                releaseNotes,
                maxLines: 15,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ));
    }
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(message),
          Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(messages!.message(UpgraderMessage.prompt)!)),
          if (notes != null) notes,
        ],
      )),
      actions: <Widget>[
        if (showIgnore)
          TextButton(
              child:
                  Text(messages!.message(UpgraderMessage.buttonTitleIgnore)!),
              onPressed: () => onUserIgnored(context, true)),
        if (showLater)
          TextButton(
              child: Text(messages!.message(UpgraderMessage.buttonTitleLater)!),
              onPressed: () => onUserLater(context, true)),
        TextButton(
            child: Text(messages!.message(UpgraderMessage.buttonTitleUpdate)!),
            onPressed: () => onUserUpdated(context, !blocked())),
      ],
    );
  }

  CupertinoAlertDialog _cupertinoAlertDialog(String title, String message,
      String? releaseNotes, BuildContext context) {
    Widget? notes;
    if (releaseNotes != null) {
      notes = Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Column(
            children: <Widget>[
              Text('Release Notes:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                releaseNotes,
                maxLines: 14,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ));
    }
    return CupertinoAlertDialog(
      title: Text(title),
      content: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(message),
          Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(messages!.message(UpgraderMessage.prompt)!)),
          if (notes != null) notes,
        ],
      ),
      actions: <Widget>[
        if (showIgnore)
          CupertinoDialogAction(
              child:
                  Text(messages!.message(UpgraderMessage.buttonTitleIgnore)!),
              onPressed: () => onUserIgnored(context, true)),
        if (showLater)
          CupertinoDialogAction(
              child: Text(messages!.message(UpgraderMessage.buttonTitleLater)!),
              onPressed: () => onUserLater(context, true)),
        CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(messages!.message(UpgraderMessage.buttonTitleUpdate)!),
            onPressed: () => onUserUpdated(context, !blocked())),
      ],
    );
  }

  void onUserIgnored(BuildContext context, bool shouldPop) {
    if (debugLogging) {
      log('upgrader: button tapped: ignore');
    }

    // If this callback has been provided, call it.
    var doProcess = true;
    if (onIgnore != null) {
      doProcess = onIgnore!();
    }

    if (doProcess) {
      _saveIgnored();
    }

    if (shouldPop) {
      _pop(context);
    }
  }

  void onUserLater(BuildContext context, bool shouldPop) {
    if (debugLogging) {
      log('upgrader: button tapped: later');
    }

    // If this callback has been provided, call it.
    var doProcess = true;
    if (onLater != null) {
      doProcess = onLater!();
    }

    if (doProcess) {}

    if (shouldPop) {
      _pop(context);
    }
  }

  void onUserUpdated(BuildContext context, bool shouldPop) {
    if (debugLogging) {
      log('upgrader: button tapped: update now');
    }

    // If this callback has been provided, call it.
    var doProcess = true;
    if (onUpdate != null) {
      doProcess = onUpdate!();
    }

    if (doProcess) {
      _sendUserToAppStore();
    }

    if (shouldPop) {
      _pop(context);
    }
  }

  Future<bool> clearSavedSettings() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('userIgnoredVersion');
    await prefs.remove('lastTimeAlerted');
    await prefs.remove('lastVersionAlerted');

    _userIgnoredVersion = null;
    _lastTimeAlerted = null;
    _lastVersionAlerted = null;

    return true;
  }

  static void resetSingleton() {
    _singleton = Upgrader._internal();
  }

  void _pop(BuildContext context) {
    Navigator.of(context).pop();
    _displayed = false;
  }

  Future<bool> _saveIgnored() async {
    var prefs = await SharedPreferences.getInstance();

    _userIgnoredVersion = _appStoreVersion;
    await prefs.setString('userIgnoredVersion', _userIgnoredVersion!);
    return true;
  }

  Future<bool> saveLastAlerted() async {
    var prefs = await SharedPreferences.getInstance();
    _lastTimeAlerted = DateTime.now();
    await prefs.setString('lastTimeAlerted', _lastTimeAlerted.toString());

    _lastVersionAlerted = _appStoreVersion;
    await prefs.setString('lastVersionAlerted', _lastVersionAlerted!);

    _hasAlerted = true;
    return true;
  }

  Future<bool> _getSavedPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    final lastTimeAlerted = prefs.getString('lastTimeAlerted');
    if (lastTimeAlerted != null) {
      _lastTimeAlerted = DateTime.parse(lastTimeAlerted);
    }

    _lastVersionAlerted = prefs.getString('lastVersionAlerted');

    _userIgnoredVersion = prefs.getString('userIgnoredVersion');

    return true;
  }

  void _sendUserToAppStore() async {
    if (_appStoreListingURL == null || _appStoreListingURL!.isEmpty) {
      if (debugLogging) {
        log('upgrader: empty _appStoreListingURL');
      }
      return;
    }

    if (debugLogging) {
      log('upgrader: launching: $_appStoreListingURL');
    }

    if (await canLaunch(_appStoreListingURL!)) {
      try {
        await launch(_appStoreListingURL!);
      } catch (e) {
        if (debugLogging) {
          log('upgrader: launch to app store failed: $e');
        }
      }
    } else {}
  }
}
