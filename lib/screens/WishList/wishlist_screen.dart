import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/showWishListModel.dart';
import 'package:ouat/screens/Login/login_screen.dart';
import 'package:ouat/screens/Splash/splash_screen.dart';
import 'package:ouat/widgets/WishListItem/wishListItem_screen.dart';
import '../../size_config.dart';
import './wishlist_state.dart';
import './wishlist_event.dart';
import './wishlist_bloc.dart';
import 'package:ouat/widgets/general_dialog.dart';

class WishListScreen extends StatefulWidget {
  static const ROUTE_NAME = 'WishListScreen';
  var callback;
  WishListScreen({this.callback});
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  late WishListBloc wishListBloc = WishListBloc(SearchInitState());
  ShowWishListModel? showWishListModel = ShowWishListModel();

  @override
  void initState() {
    // categoryBloc = BlocProvider.of<CategoryBloc>(context);
    getInitState();
    super.initState();
  }

  getInitState() async {
    wishListBloc.add(LoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: BlocProvider(
              create: (context) => wishListBloc,
              child: BaseBlocListener(
                  bloc: wishListBloc,
                  listener: (context, state) {
                    if (state is NotAuthorisedState) {
                      Navigator.pushNamed(context, LoginScreen.ROUTE_NAME,
                          arguments: {
                            "callback": (value) {
                              if (value != null) {

                              }
                            }
                          }).then((value) => getInitState());
                    }

                    if (state is CompletedState) {
                      showWishListModel = state.showWishListModel;
                      // setState(() {

                      // });
                    }
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
                      bloc: wishListBloc,
                      condition: (oldState, currentState) {
                        return !(BaseBlocBuilder.isBaseState(currentState));
                      },
                      builder: (BuildContext context, BaseState state) {
                        if (showWishListModel!.data != null) {
                          return CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                leading: IconButton(
                                  icon: Icon(Icons.arrow_back,
                                      color: Colors.black),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                backgroundColor: Colors.white,
                                shadowColor: const Color(0xffffd2d2),
                                pinned: true,
                                title: Text(
                                  "WISHLIST",
                                  style: TextStyle(
                                      fontFamily: 'RecklessNeue',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      color: Colors.black),
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return WishListItemScreen(
                                      showWishListModel!.data![index], (value) {
                                    if (value == true) {
                                      getInitState();
                                      widget.callback(true);
                                    }
                                  });
                                }, childCount: showWishListModel!.data!.length),
                              ),
                            ],
                          );
                        } else {
                          if (state is ShowProgressLoader) {
                            return Container();
                          } else {
                            return Scaffold(
                              appBar: AppBar(
                                backgroundColor: Colors.white,
                                elevation: 0,
                                leading: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                centerTitle: true,
                                title: Text(
                                  "WISHLIST",
                                  style: TextStyle(
                                      fontFamily: 'RecklessNeue',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      color: Colors.black),
                                ),
                              ),
                              body: Column(
                                children: [
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: CachedNetworkImage(
                                              width: 200,
                                              height: 200,
                                              // fit: BoxFit.fitWidth,
                                              imageUrl:
                                                  "https://taggd.gumlet.io/logo/empty-wishlist-icon.png",
                                              placeholder: (context, url) =>
                                                  Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                strokeWidth: 1,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Color(0xffcd3a62)),
                                              )),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: SizeConfig.screenWidth,
                                            color: Color(0xffcd3a62),
                                            child: Center(
                                              child: Text(
                                                "CONTINUE SHOPPING",
                                                style:
                                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            );
                          }
                        }
                      })),
            )));
  }
}
