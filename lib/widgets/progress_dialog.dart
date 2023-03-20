import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:send_app/utils/constants.dart';

class ProgressDialog {
  static final ProgressDialog _instance = ProgressDialog._internal();
  static ProgressDialog getInstance() => _instance;
  ProgressDialog._internal();
  bool isShowing = false;
  BuildContext? context;

  void hide({BuildContext? context}) {
    if (isShowing) {
      isShowing = false;
      if (Navigator.of(this.context ?? context!).mounted &&
          Navigator.of(this.context ?? context!).canPop()) {
        Navigator.of(this.context ?? context!).pop();
        print('ProgressDialog dismissed');
      }
    }
  }

  void show(BuildContext context, String message) {
    this.context = context;
    print('ProgressDialog shown');

    if (isShowing) {
      hide(context: context);
    }

    isShowing = true;

    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // _context = context;
        return Dialog(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: _MyDialog(message),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class _MyDialog extends StatefulWidget {
  String message;
  _MyDialog(this.message);

  @override
  State<StatefulWidget> createState() {
    return _MyDialogState(this.message);
  }
}

class _MyDialogState extends State<_MyDialog> {
  String message;
  late ThemeData _themeData;
  _MyDialogState(this.message);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    return SizedBox(
      child: Row(
        children: <Widget>[
          SizedBox(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.pink),
            ),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.justify,
              style:
                  _themeData.textTheme.subtitle1!.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
