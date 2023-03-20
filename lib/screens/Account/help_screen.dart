import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../size_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HelpScreen extends StatefulWidget {
  final ValueChanged<bool>? callback;
  HelpScreen({this.callback});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String? version;

  Future<void> _launch(String url) async {
    if(url.startsWith('mailto')){
      await launch(
        '$url',
      );
    }
    else{
      if (await canLaunch('$url')) {
        await launch(
          '$url',
        );
      } else {
        throw 'Could not launch url';
      }
    }
  }


  @override
  void initState() {
    super.initState();
    getVersion();
  }

   Future<void> getVersion() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
    log(version!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: (){
                    widget.callback!(true);
                  },
                  child: Row(
                    children: [
                      Icon(
                          Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      Text(
                        'Help',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(
                height: 30,
              ),
              ListTile(
                onTap: (){
                  _launch('tel:+917290036330');
                },
                contentPadding: EdgeInsets.all(20),
                title: Text(
                  'Call',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 2*SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: RichText(
                    text: TextSpan(
                        text: '+917290036330\n',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Monday to Saturday, 9AM - 7PM',
                            style: TextStyle(
                                color: Color(0xff4D4D4D)
                            )
                          ),
                        ]
                    ),
                ),
                trailing: SvgPicture.asset(
                  'assets/icons/call.svg',
                  height: 30,
                  width: 30,
                ),
              ),
              Divider(
                color: Color(0xffCFCFCF),
                thickness: 2,
              ),
              ListTile(
                onTap: (){
                  _launch('mailto:customercare@taggd.com');
                },
                contentPadding: EdgeInsets.all(20),
                title: Text(
                  'Email',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 2*SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'customercare@taggd.com',
                  style: TextStyle(
                    fontFamily: 'Inter',
                      color: Colors.black
                    //fontSize: 2*SizeConfig.textMultiplier,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: SvgPicture.asset(
                  'assets/icons/mailto.svg',
                  height: 30,
                  width: 30,
                ),
              ),
              Divider(
                color: Color(0xffCFCFCF),
                thickness: 2,
              ),
              ListTile(
                onTap: (){
                  _launch('https://www.taggd.com');
                },
                contentPadding: EdgeInsets.all(20),
                title: Text(
                  'Website',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 2*SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'https://www.taggd.com',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.black
                    //fontSize: 2*SizeConfig.textMultiplier,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: SvgPicture.asset(
                  'assets/icons/web.svg',
                  height: 30,
                  width: 30,
                ),
              ),
              Divider(
                color: Color(0xffCFCFCF),
                thickness: 2,
              ),
              Center(child: Text("Version: ${version}"))
            ],
          ),
        ),
      ),
    );
  }
}
