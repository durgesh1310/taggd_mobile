import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ouat/data/models/sortBarModel.dart';
import 'package:ouat/screens/Search/search_screen.dart';
import 'package:ouat/screens/SpecialPage/specialPage_screen.dart';
import 'package:ouat/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class SortBar extends StatelessWidget {
  SortBarModel? sortBarModel;
  var callback;
   SortBar({this.sortBarModel, this.callback});

  Future<void> _launchInWebView(String url) async {
    if(await canLaunch(
        '$url'
    )) {
      await launch(
        '$url',
        //forceWebView: true,
        //forceSafariVC: true,
        //enableJavaScript: true,
        //headers: <String, String>{'header_key': 'header_value'},
        );
    }
    else
    {
      throw 'Could not launch url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
        itemCount: sortBarModel!.data!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context ,index) => Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.heightMultiplier*0.7,
              right: SizeConfig.heightMultiplier*0.5,
              bottom: SizeConfig.heightMultiplier*0.5,
              top: SizeConfig.heightMultiplier*3
          ),
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  if(sortBarModel!.data![index].type == "PLP"
                  ){
                    Navigator.pushNamed(context, SearchScreen.ROUTE_NAME, arguments: {
                      "query": "${sortBarModel!.data![index].name}",
                      "id": "${sortBarModel!.data![index].action}",
                      "collection": false,
                      "callback": callback
                    }).then((value) => callback!(true));
                  }
                  else if(sortBarModel!.data![index].type == "COLLECTION"){
                    Navigator.pushNamed(context, SearchScreen.ROUTE_NAME, arguments: {
                      "query": "${sortBarModel!.data![index].name}",
                      "id": "${sortBarModel!.data![index].action}",
                      "collection": true,
                      "callback": callback
                    }).then((value) => callback!(true));
                  }
                  else if(
                  sortBarModel!.data![index].type == "URL"
                  ){
                    _launchInWebView(sortBarModel!.data![index].action!);
                  }else if(
                  sortBarModel!.data![index].type == "SP"
                  ){
                    Navigator.pushNamed(context, SpecialPage.ROUTE_NAME, arguments: {
                      "id": "${sortBarModel!.data![index].action}",
                      "callback": callback
                    }).then((value) => callback!(true));
                  }
                },
                child: Container(
                  height: 12*SizeConfig.heightMultiplier,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: CachedNetworkImage(
                    imageUrl:
                    '${sortBarModel!.data![index].icon}',
                    fit: BoxFit.scaleDown,
                    placeholder: (context,
                        url) =>
                        Image.network('${
                            sortBarModel!.data![index].icon
                        }?w=${SizeConfig.screenWidth/8}' ,
                          fit: BoxFit.fitWidth,
                        ),
                    errorWidget:
                        (context, url, error) =>
                        Container(
                        ),
                  ),
                )
              ),
              SizedBox(height: SizeConfig.widthMultiplier,),
              Text(
                  "${sortBarModel!.data![index].name}",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500
                ),
              )
            ],
          ),
        ));
  }
}

