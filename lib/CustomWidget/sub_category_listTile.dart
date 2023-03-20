import 'package:cached_network_image/cached_network_image.dart';
import 'package:ouat/screens/SpecialPage/specialPage_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:ouat/data/models/categoryModel.dart';
import 'package:ouat/screens/Search/search_screen.dart';
import 'package:ouat/screens/ProductDescription/product_description_screen.dart';
import '../size_config.dart';

class SubCategoryListTile extends StatefulWidget {
  int? index;
  ParentChildResponse? parentChildResponse;
  var callback;

  SubCategoryListTile({this.index, this.parentChildResponse, this.callback});

  @override
  _SubCategoryListTileState createState() => _SubCategoryListTileState();
}

class _SubCategoryListTileState extends State<SubCategoryListTile> {
  var _expanded = false;

  Future<void> _launchInWebView(String url) async {
    if (await canLaunch('$url')) {
      await launch(
        '$url',
      );
    } else {
      throw 'Could not launch url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            child: ListTile(
              onTap: () {
                if (widget.parentChildResponse!.leaf == false) {
                  setState(() {
                    _expanded = !_expanded;
                  });
                } else {
                  if (widget.parentChildResponse!.type == "PLP") {
                    Navigator.pushNamed(context, SearchScreen.ROUTE_NAME,
                        arguments: {
                          "query": "${widget.parentChildResponse!.nodeTitle}",
                          "id": "${widget.parentChildResponse!.action}",
                          "collection": false,
                          "callback": widget.callback
                        });
                  } else if (widget.parentChildResponse!.type == "COLLECTION") {
                    Navigator.pushNamed(context, SearchScreen.ROUTE_NAME,
                        arguments: {
                          "query": "${widget.parentChildResponse!.nodeTitle}",
                          "id": "${widget.parentChildResponse!.action}",
                          "collection": true,
                          "callback": widget.callback
                        });
                  } else if(widget.parentChildResponse!.type ==
                      "PDP"){
                    Navigator.pushNamed(
                      context,
                      ProductDescriptionScreen.ROUTE_NAME,
                      arguments: {
                        "pid": '${widget.parentChildResponse!.action}',
                        "callback": (value) {
                          if (value) {
                            widget.callback;
                          }
                        },
                      },
                    ).then((value) {
                      widget.callback!(true);
                    });
                  } else if (widget.parentChildResponse!.type == "URL") {
                    if(widget.parentChildResponse!.action! == "#"){
                      null;
                    }
                    else{
                      _launchInWebView(widget.parentChildResponse!.action!);
                    }
                  } else if (widget.parentChildResponse!.type == "SP") {
                    Navigator.pushNamed(context, SpecialPage.ROUTE_NAME,
                        arguments: {
                          "id": "${widget.parentChildResponse!.action}",
                          "callback": widget.callback
                        });
                  }
                }
              },
              tileColor: Colors.white,
              title: Text(
                "${widget.parentChildResponse!.nodeTitle}",
                style: TextStyle(
                  fontFamily: 'RecklessNeue',
                    fontWeight: FontWeight.w500
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30 * SizeConfig.widthMultiplier,
                    child: CachedNetworkImage(
                      width: 30 * SizeConfig.widthMultiplier,
                      fit: BoxFit.scaleDown,
                      imageUrl:
                      widget.parentChildResponse!.icon ??
                          "",
                      placeholder: (context,
                          url) =>
                          Container(),
                      errorWidget:
                          (context, url, error) =>
                          Container(),
                    ),
                  ),
                  Icon(
                      _expanded
                          ? Icons.expand_less
                          : Icons.expand_more
                  ),
                ],
              ),
            ),
          ),
          if (widget.parentChildResponse!.childLevelDetail != null)
            AnimatedContainer(
                height: _expanded
                    ? widget.parentChildResponse!.childLevelDetail!.length * 50
                    : 0,
                curve: Curves.fastOutSlowIn,
                duration: const Duration(seconds: 1),
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10),
                    itemCount:
                        widget.parentChildResponse!.childLevelDetail!.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (widget.parentChildResponse!
                                  .childLevelDetail![index].type ==
                              "PLP") {
                            Navigator.pushNamed(
                                context, SearchScreen.ROUTE_NAME,
                                arguments: {
                                  "query": "${widget.parentChildResponse!.childLevelDetail![index].nodeTitle}",
                                  "id":
                                      "${widget.parentChildResponse!.childLevelDetail![index].action}",
                                  "collection": false,
                                  "callback": widget.callback
                                });
                          } else if (widget.parentChildResponse!
                              .childLevelDetail![index].type ==
                              "COLLECTION") {
                            Navigator.pushNamed(
                                context, SearchScreen.ROUTE_NAME,
                                arguments: {
                                  "query": "${widget.parentChildResponse!.childLevelDetail![index].nodeTitle}",
                                  "id":
                                      "${widget.parentChildResponse!.childLevelDetail![index].action}",
                                  "collection": true,
                                  "callback": widget.callback
                                });
                          } else if(widget.parentChildResponse!
                              .childLevelDetail![index].type ==
                              "PDP"){
                            Navigator.pushNamed(
                              context,
                              ProductDescriptionScreen.ROUTE_NAME,
                              arguments: {
                                "pid": '${widget.parentChildResponse!
                                    .childLevelDetail![index].action!}',
                                "callback": (value) {
                                  if (value) {
                                    widget.callback;
                                  }
                                },
                              },
                            ).then((value) {
                              widget.callback!(true);
                            });
                          } else if (widget.parentChildResponse!
                                  .childLevelDetail![index].type ==
                              "URL") {
                            if(widget.parentChildResponse!
                                .childLevelDetail![index].action! == "#"){
                              null;
                            }
                            else{
                              _launchInWebView(widget.parentChildResponse!
                                  .childLevelDetail![index].action!);
                            }
                          } else if (widget.parentChildResponse!
                                  .childLevelDetail![index].type ==
                              "SP") {
                            Navigator.pushNamed(context, SpecialPage.ROUTE_NAME,
                                arguments: {
                                  "id":
                                      "${widget.parentChildResponse!.childLevelDetail![index].action}",
                                  "callback": widget.callback
                                });
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, bottom: 8, top: 8),
                              child: Text(
                                "${widget.parentChildResponse!.childLevelDetail![index].nodeTitle}",
                                style: TextStyle(
                                  fontFamily: 'RecklessNeue',
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            )
                          ],
                        ),
                      );
                    }))
        ],
      ),
    );
  }
}
