import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/sortBarModel.dart';
import 'package:ouat/screens/Category/category_bloc.dart';
import 'package:ouat/screens/Category/category_event.dart';
import 'package:ouat/screens/Category/category_state.dart';
import 'package:ouat/screens/Category/category_sub_screen.dart';
import 'package:ouat/screens/Search/search_screen.dart';
import 'package:ouat/screens/SpecialPage/specialPage_screen.dart';
import 'package:ouat/size_config.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/utility/thirdParty/netcoreEvents.dart';
import 'package:ouat/widgets/SortBar/sortBar_screen.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ouat/screens/ProductDescription/product_description_screen.dart';



class CategoryActivity extends StatefulWidget {
  SortBarModel? sortBarModel;
  final ValueChanged<bool>? callback;
  CategoryActivity({this.sortBarModel,this.callback});
  @override
  _CategoryActivityState createState() => _CategoryActivityState();
}

class _CategoryActivityState extends State<CategoryActivity> {
  late CategoryBloc categoryBloc = CategoryBloc(SearchInitState());
  double? _height;
  double? _width;


  @override
  void initState() {
    getInitState();
    super.initState();
  }

  getInitState() async {
    categoryBloc.add(LoadEvent());
  }

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
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return BlocBuilder(
        bloc: categoryBloc,
        builder: (BuildContext context, dynamic state) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                  height: _height,
                  width: _width,
                  padding:
                  EdgeInsets.only(
                      top: 25.0,
                      left: 10.0, right: 10),
                  child: BaseBlocListener(
                      bloc: categoryBloc,
                      listener: (context, state) {
                        if (state is ErrorState) {
                          GeneralDialog.show(
                            context,
                            title: 'Error',
                            message: state.message,
                            closeOnAction: true,
                            positiveButtonLabel: 'OK',
                            onPositiveTap: () {
                              // Navigator.of(context).pop();
                              //      Navigator.of(context)
                              //          .pushNamed(AddressScreen.ROUTE_NAME, arguments: {
                              //        'selectMode': true,
                              //        'homeMode': true,
                              //      }).then((value) {
                              //        setState(() {
                              //          Address address = value;
                              //          _bloc.add(DefaultAddress(addressId: address.id));
                              //        });
                              //      });
                            },
                          );
                        }
                      },
                      child: BaseBlocBuilder(
                          bloc: categoryBloc,
                          condition: (oldState, currentState) {
                            return !(BaseBlocBuilder.isBaseState(currentState));
                          },
                          builder: (BuildContext context, BaseState state) {
                            if (state is CompletedState) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    GridView.builder(
                                        itemCount: state.categoryModel!.data!
                                            .rootParentChildResponse!.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: SizeConfig.screenWidth/2,
                                          childAspectRatio: 0.975,
                                          crossAxisSpacing: 5,
                                        ),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: (){
                                              if (state
                                                  .categoryModel!
                                                  .data!
                                                  .rootParentChildResponse![index]
                                                  .leaf ==
                                                  false) {
                                                AppsFlyer.categoryViewed(state
                                                    .categoryModel!
                                                    .data!
                                                    .rootParentChildResponse![
                                                index]
                                                    .nodeTitle!);
                                                NetcoreEvents.categoryViewed(
                                                    state
                                                        .categoryModel!
                                                        .data!
                                                        .rootParentChildResponse![
                                                    index]
                                                        .nodeTitle!
                                                );
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (_) => SubCategory(
                                                    parentChildResponse: state
                                                        .categoryModel!
                                                        .data!
                                                        .rootParentChildResponse![
                                                    index]
                                                        .parentChildResponse!,
                                                    title: state
                                                        .categoryModel!
                                                        .data!
                                                        .rootParentChildResponse![
                                                    index]
                                                        .nodeTitle,
                                                    imageUrl: state
                                                        .categoryModel!
                                                        .data!
                                                        .rootParentChildResponse![
                                                    index]
                                                        .icon,
                                                    callback: widget.callback,
                                                  ),
                                                )).then((value) => widget.callback!(true));
                                              } else {
                                                if (state
                                                    .categoryModel!
                                                    .data!
                                                    .rootParentChildResponse![
                                                index]
                                                    .type ==
                                                    "PLP") {
                                                  Navigator.pushNamed(context,
                                                      SearchScreen.ROUTE_NAME,
                                                      arguments: {
                                                        "query":
                                                        "${state.categoryModel!.data!.rootParentChildResponse![index].nodeTitle}",
                                                        "id":
                                                        "${state.categoryModel!.data!.rootParentChildResponse![index].action}",
                                                        "collection": false,
                                                        "callback": widget.callback
                                                      }).then((value) => widget.callback!(true));
                                                } else if (state
                                                    .categoryModel!
                                                    .data!
                                                    .rootParentChildResponse![
                                                index]
                                                    .type ==
                                                    "COLLECTION") {
                                                  Navigator.pushNamed(context,
                                                      SearchScreen.ROUTE_NAME,
                                                      arguments: {
                                                        "query":
                                                        "${state.categoryModel!.data!.rootParentChildResponse![index].nodeTitle}",
                                                        "id":
                                                        "${state.categoryModel!.data!.rootParentChildResponse![index].action}",
                                                        "collection": true,
                                                        "callback": widget.callback
                                                      }).then((value) => widget.callback!(true));
                                                } else if(state
                                                    .categoryModel!
                                                    .data!
                                                    .rootParentChildResponse![
                                                index]
                                                    .type ==
                                                    "PDP"){
                                                  Navigator.pushNamed(
                                                    context,
                                                    ProductDescriptionScreen.ROUTE_NAME,
                                                    arguments: {
                                                      "pid": '${state.categoryModel!.data!.rootParentChildResponse![index].action}',
                                                      "callback": (value) {
                                                        if (value) {
                                                          widget.callback;
                                                        }
                                                      },
                                                    },
                                                  ).then((value) {
                                                    widget.callback!(true);
                                                  });
                                                }else if (state
                                                    .categoryModel!
                                                    .data!
                                                    .rootParentChildResponse![
                                                index]
                                                    .type ==
                                                    "URL") {
                                                  if(state
                                                      .categoryModel!
                                                      .data!
                                                      .rootParentChildResponse![index]
                                                      .action! == "#"){
                                                    null;
                                                  }
                                                  else{
                                                    _launchInWebView(state
                                                        .categoryModel!
                                                        .data!
                                                        .rootParentChildResponse![index]
                                                        .action!);
                                                  }
                                                } else if (state
                                                    .categoryModel!
                                                    .data!
                                                    .rootParentChildResponse![
                                                index]
                                                    .type ==
                                                    "SP") {
                                                  Navigator.pushNamed(
                                                      context, SpecialPage.ROUTE_NAME,
                                                      arguments: {
                                                        "id":
                                                        "${state.categoryModel!.data!.rootParentChildResponse![index].action}"
                                                      }).then((value) => widget.callback!(true));
                                                }
                                              }
                                            },
                                            child: CachedNetworkImage(
                                              width: SizeConfig.screenWidth ,
                                              fit: BoxFit.contain,
                                              imageUrl:
                                              state.categoryModel!.data!.rootParentChildResponse![index].icon ??
                                                  "",
                                              placeholder: (context,
                                                  url) =>
                                                  Container(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                  Container(),
                                            ),
                                          );
                                        }
                                    ),
                                    widget.sortBarModel != null ? Container(
                                        padding: EdgeInsets.only(top: 10),
                                        height: SizeConfig.heightMultiplier * 22,
                                        width: SizeConfig.screenWidth,
                                        child: SortBar(
                                          sortBarModel: widget.sortBarModel,
                                          callback: widget.callback,
                                        )) : Container(),
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }))));
        });
  }
}