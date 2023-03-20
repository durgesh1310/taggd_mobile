import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/models/searchModel.dart';
import 'package:ouat/screens/AppBar/appBar.dart';
import 'package:ouat/screens/ProductDescription/product_description_screen.dart';
import 'package:ouat/screens/SearchComponent/suggestion_widget.dart';
import 'package:ouat/screens/SpecialPage/specialPage_screen.dart';
import 'package:ouat/screens/Splash/splash_screen.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/utility/thirdParty/netcoreEvents.dart';
import 'package:ouat/widgets/Filters/filters_screen.dart';
import 'package:ouat/widgets/ProductItem/productItem_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../../size_config.dart';
import 'package:ouat/screens/Search/search_bloc.dart';
import 'package:ouat/screens/Search/search_event.dart';
import 'package:ouat/screens/Search/search_state.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';



class SearchScreen extends StatefulWidget {
  String? query;
  String? id;
  bool? collection;
  final ValueChanged<bool>? callback;
  static const ROUTE_NAME = 'SearchScreen';
  SearchScreen({this.query, this.id, this.collection, this.callback});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchBloc searchBloc = SearchBloc(SearchInitState());
  //late SuggestionBloc suggestionBloc = SuggestionBloc(SearchSuggestionInitState());
  SearchModel? searchModel = SearchModel();
  List<SortByData>? sortList;
  List<Filters>? filters;
  List<PlpCard>? plpCard = [];
  String sortBy = "Recommended";
  ScrollController _scrollController = ScrollController();
  bool isLastPosition = false;
  int pageNo = 0, count = 30;
  var filterData;
  bool searching = false;
  bool? searchTracker;
  var callBackFunction;
  var searchPayload;
  int? cartItems;
  bool showBanner = false;


  @override
  void initState() {
    searchTracker = true;
    super.initState();
    getSearchData();
    _scrollController.addListener(_scrollListener);
  }

  getSearchData() async {
    if (widget.id != "") {
      getPlpInitState(widget.id);
    } else {
      getSearchInitState(widget.query);
    }
  }

  void _scrollListener() async{
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      setState(() {
        isLastPosition = true;
      });
      pageNo += 1;
      getNextPageData();
    }
  }

  getNextPageData() {
    if (widget.id == "") {
      if (filterData != null) {
        searchBloc.add(NextSearchLoadEvent(
            widget.query!, filterData, sortBy, pageNo, plpCard));
      } else {
        searchBloc.add(
            NextSearchLoadEvent(widget.query!, [], sortBy, pageNo, plpCard));
      }
    } else {
      if (filterData != null) {
        searchBloc.add(NextPlpLoadEvent(widget.id!, filterData, sortBy, pageNo,
            widget.collection!, plpCard));
      } else {
        searchBloc.add(NextPlpLoadEvent(
            widget.id!, [], sortBy, pageNo, widget.collection!, plpCard));
      }
    }
  }

  getSearchInitState(String? query) async {
    if (filterData != null) {
      searchBloc.add(SearchLoadEvent(query!, filterData, sortBy, pageNo));
    } else {
      searchBloc.add(SearchLoadEvent(query!, [], sortBy, pageNo));
    }
  }

  getPlpInitState(String? id) async {
    if (filterData != null) {
      searchBloc.add(
          LoadingEvent(id!, filterData, sortBy, pageNo, widget.collection!));
    } else {
      searchBloc.add(LoadingEvent(id!, [], sortBy, pageNo, widget.collection!));
    }
  }

  void updateCartItem(bool value) async {
    if(value){
      OrderStatusModel? orderStatusModel = await DataRepo.getInstance().userRepo.getItemsNumber();
      print(orderStatusModel.data);
      setState(() {
        cartItems = orderStatusModel.data!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: searchBloc,
      builder: (BuildContext context, dynamic state) {
        return Scaffold(
          bottomNavigationBar: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                    sortByFilter(context, sortList);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0,
                        left: 8,
                        right: 4
                    ),
                    child: Container(
                      height: 45,
                      width: SizeConfig.screenWidth/2,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Color(0xffFAD1D8))
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/sortBy.svg',
                              height: 24,
                              width: 24,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "SORT BY",
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (filters!.isNotEmpty) {
                      Navigator.pushNamed(context, FiltersScreen.ROUTE_NAME,
                          arguments: {"filters": filters}).then((value) {
                        if (value != null) {
                          filterData = value;
                          pageNo = 0;
                          getSearchData();
                        }
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8.0,
                      right: 8,
                      left: 4,
                    ),
                    child: Container(
                      height: 45,
                      width: SizeConfig.screenWidth/2,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Color(0xffFAD1D8))
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/filters.svg',
                              height: 24,
                              width: 24,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "FILTERS",
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.09),
                child: Container(
                  padding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: BaseBlocListener(
                    bloc: searchBloc,
                    listener: (context, state) {
                      if (state is RedirectingState) {
                        Navigator.popAndPushNamed(
                            context, SplashActivity.ROUTE_NAME);
                      }

                      if (state is CompletedState) {
                        searchModel = state.searchModel;
                        plpCard = state.searchModel!.data!.plpCard;
                        filters = state.searchModel!.data!.filters;
                        sortList = state.searchModel!.data!.sortBy!.data;
                        //preloadImages();
                        /*if(searchModel!.data!.mobileBannerV2!.isRepeat!){
                          repeat = int.parse(searchModel!.data!.mobileBannerV2!.repeatAfterOccurrences!);
                        }*/
                        log("$plpCard");
                        if(searchTracker!){
                          NetcoreEvents.searchTrack(widget.id != "" ? widget.id! : widget.query!,
                              plpCard![0].productId!,
                              plpCard![1].productId!,
                              plpCard![2].productId!,
                              searchModel!.data!.totalHits!);
                          if(widget.collection!){
                            AppsFlyer.collectionTrack(widget.id != "" ? widget.id! : widget.query!,
                                plpCard![0].productId!,
                                plpCard![1].productId!,
                                plpCard![2].productId!,
                                searchModel!.data!.totalHits!);
                            NetcoreEvents.collectionTrack(widget.id != "" ? widget.id! : widget.query!,
                                plpCard![0].productId!,
                                plpCard![1].productId!,
                                plpCard![2].productId!,
                                searchModel!.data!.totalHits!);
                          }
                          else{
                            AppsFlyer.plpTrack(widget.id != "" ? widget.id! : widget.query!,
                                plpCard![0].productId!,
                                plpCard![1].productId!,
                                plpCard![2].productId!,
                                searchModel!.data!.totalHits!);
                            NetcoreEvents.plpTrack(widget.id != "" ? widget.id! : widget.query!,
                                plpCard![0].productId!,
                                plpCard![1].productId!,
                                plpCard![2].productId!,
                                searchModel!.data!.totalHits!);
                          }
                          searchTracker = false;
                        }
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
                    child: getBody(),
                  ),
                ),
              ),
              BaseBlocBuilder(
                bloc: searchBloc,
                condition: (oldState, currentState) {
                  return !(BaseBlocBuilder.isBaseState(currentState));
                },
                builder: (BuildContext context, BaseState state) {
                  if (state is CompletedState) {
                    return (!searching)
                        ? Positioned(
                      child: AppBarCustom(
                        onTapSearch: (bool val) {
                          setState(() {
                            searching = val;
                          });
                        },
                        //callback: updateCartItem,
                        screen: "Search",
                        query: searchModel!.data!.query == " "
                            ? '${widget.query}'
                            : '${searchModel!.data!.query}',
                        totalHits: '${searchModel!.data!.totalHits}',
                        search: true,
                        count: cartItems == null ? 0 : cartItems!,
                      ),
                      top: 0,
                    )
                        : SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: SearchListItem(
                        onTapSearch: (bool value) {
                          setState(() {
                            searching = value;
                          });
                        },
                        screen: "Search",
                        // callback: updateCartItem
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget paginationsearchSimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: GridView.count(
        primary: false,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(2),
        crossAxisSpacing: 5,
        mainAxisSpacing: 10,
        childAspectRatio: 0.55,
        crossAxisCount: 2,
        children: <Widget>[
          Container(
            color: Color(0xFFDBFFE9),
          ),
          Container(
            color: Color(0xFFDBFFE9),
          ),
          // Container(
          //   color: Color(0xFFDBFFE9),
          // ),
          // Container(
          //   color: Color(0xFFDBFFE9),
          // ),
          // Container(
          //   color: Color(0xFFDBFFE9),
          // ),
          // Container(
          //   color: Color(0xFFDBFFE9),
          // ),
        ],
      ),
    );
  }
  Widget loadingsearchSimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: GridView.count(
        primary: false,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(2),
        crossAxisSpacing: 5,
        mainAxisSpacing: 10,
        childAspectRatio: 0.55,
        crossAxisCount: 2,
        children: <Widget>[
          Container(
            color: Color(0xFFDBFFE9),
          ),
          Container(
            color: Color(0xFFDBFFE9),
          ),
          Container(
            color: Color(0xFFDBFFE9),
          ),
          Container(
            color: Color(0xFFDBFFE9),
          ),
          Container(
            color: Color(0xFFDBFFE9),
          ),
          Container(
            color: Color(0xFFDBFFE9),
          ),
        ],
      ),
    );
  }

  Widget getBody() {
    return BaseBlocBuilder(
      bloc: searchBloc,
      condition: (oldState, currentState) {
        return !(BaseBlocBuilder.isBaseState(currentState));
      },
      builder: (BuildContext context, BaseState state) {
        if (state is RedirectingState) {
          Navigator.popAndPushNamed(context, SplashActivity.ROUTE_NAME);
        }

        if (state is CompletedState) {
          return Container(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    if(searchModel!.data!.plpBanner != "")
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: getPageBanner(searchModel!.data!.plpBanner!),
                      ),
                    if(searchModel!.data!.mobileBannerV2 != null && !searchModel!.data!.mobileBannerV2!.isRepeat!)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: getSearchPageBanner(
                            searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails,
                            searchModel!.data!.mobileBannerV2!.componentJson!.columns
                        ),
                      ),
                    GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: plpCard!.length,
                        //cacheExtent: 100,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: SizeConfig.screenWidth / 2,
                            childAspectRatio: 0.54,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                        itemBuilder: (context, index) {
                          if(searchModel!.data!.mobileBannerV2 != null && searchModel!.data!.mobileBannerV2!.isRepeat!){
                            if((index+1)%(int.parse(searchModel!.data!.mobileBannerV2!.repeatAfterOccurrences!)) == 0){
                              return InkWell(
                                onTap: (){
                                  if (searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].type == "PLP") {
                                    Navigator.pushNamed(context, SearchScreen.ROUTE_NAME, arguments: {
                                      "query": "",
                                      "id": "${searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].action}",
                                      "collection": false,
                                      "callback": widget.callback
                                    }).then((value) {
                                      // widget.callback!(true);
                                    });
                                  } else if (searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].type == "COLLECTION") {
                                    Navigator.pushNamed(context, SearchScreen.ROUTE_NAME, arguments: {
                                      "query": "",
                                      "id": "${searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].action}",
                                      "collection": true,
                                      "callback": widget.callback
                                    }).then((value) {
                                      // widget.callback!(true);
                                    });
                                  } else if(searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].type ==
                                      "PDP"){
                                    Navigator.pushNamed(
                                      context,
                                      ProductDescriptionScreen.ROUTE_NAME,
                                      arguments: {
                                        "pid": '${searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].action}',
                                        "callback": (value) {
                                          if (value) {
                                            widget.callback!(true);
                                          }
                                        },
                                      },
                                    );
                                  }else if (searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].type == "URL") {
                                    if(searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].action! == "#"){
                                      null;
                                    }
                                    else{
                                      _launchInWebView(searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].action!);
                                    }
                                  } else if (searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].type == "SP") {
                                    Navigator.pushNamed(context, SpecialPage.ROUTE_NAME,
                                        arguments: {"id": "${searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].action}",
                                          "callback": widget.callback}).then((value) {
                                      // widget.callback!(true);
                                    });
                                  }
                                  AppsFlyer.bannerClick(
                                      searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].id!,
                                      "PLP",
                                      searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].action!,
                                      searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].type!,
                                      widget.id != "" ? widget.id! : widget.query!);
                                  NetcoreEvents.bannerClick(
                                      searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].id!,
                                      "PLP",
                                      searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].action!,
                                      searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].type!,
                                      widget.id != "" ? widget.id! : widget.query!);
                                },
                                child: Container(
                                  width: SizeConfig.screenWidth,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.scaleDown,
                                    maxWidthDiskCache: 345,
                                    imageUrl: '${searchModel!.data!.mobileBannerV2!.componentJson!.cardDetails![0].iconUrlMobile}?w=345',
                                    errorWidget: (context, url, error) => Container(),
                                  ),
                                ),
                              );
                            }
                            else {
                              return ProductItem(
                                plpCard: plpCard![index],
                                callback:(val){
                                  updateCartItem(true);
                                  widget.callback!(val);
                                },
                              );
                            }
                          }
                          else{
                            return ProductItem(
                              plpCard: plpCard![index],
                              callback:(val){
                                updateCartItem(true);
                                widget.callback!(val);
                              },
                            );
                          }
                        }),
                    if ((pageNo + 1) * count <=
                        state.searchModel!.data!.totalHits!)
                      paginationsearchSimmer()
                  ],
                ),
              ));
        }
        if (state is SearchLoadingState) {
          return loadingsearchSimmer();
        } else {
          return Container();
        }
      },
    );
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

  Widget getSearchPageBanner(List<CardDetails>? card_details, int? columns) {
    if (card_details!.length == 1) {
      return GestureDetector(
        onTap: () {
          if (card_details[0].type == "PLP") {
            Navigator.pushNamed(context, SearchScreen.ROUTE_NAME, arguments: {
              "query": "",
              "id": "${card_details[0].action}",
              "collection": false,
              "callback": widget.callback
            }).then((value) {
              // widget.callback!(true);
            });
          } else if (card_details[0].type == "COLLECTION") {
            Navigator.pushNamed(context, SearchScreen.ROUTE_NAME, arguments: {
              "query": "",
              "id": "${card_details[0].action}",
              "collection": true,
              "callback": widget.callback
            }).then((value) {
              // widget.callback!(true);
            });
          } else if(card_details[0].type ==
              "PDP"){
            Navigator.pushNamed(
              context,
              ProductDescriptionScreen.ROUTE_NAME,
              arguments: {
                "pid": '${card_details[0].action}',
                "callback": (value) {
                  if (value) {
                    widget.callback!(true);
                  }
                },
              },
            );
          }else if (card_details[0].type == "URL") {
            if(card_details[0].action! == "#"){
              null;
            }
            else{
              _launchInWebView(card_details[0].action!);
            }
          } else if (card_details[0].type == "SP") {
            Navigator.pushNamed(context, SpecialPage.ROUTE_NAME,
                arguments: {"id": "${card_details[0].action}",
                  "callback": widget.callback}).then((value) {
              // widget.callback!(true);
            });
          }
          AppsFlyer.bannerClick(
              card_details[0].id!,
              "PLP",
              card_details[0].action!,
              card_details[0].type!,
              widget.id != "" ? widget.id! : widget.query!);
          NetcoreEvents.bannerClick(
              card_details[0].id!,
              "PLP",
              card_details[0].action!,
              card_details[0].type!,
              widget.id != "" ? widget.id! : widget.query!);
        },
        child: Container(
          width: SizeConfig.screenWidth,
          child: CachedNetworkImage(
            fit: BoxFit.scaleDown,
            imageUrl: '${card_details[0].iconUrlMobile}',
            placeholder: (context, url) => Image.network(
              '${card_details[0].iconUrlMobile}?w=${SizeConfig.screenWidth / 8}',
              fit: BoxFit.fitWidth,
            ),
            errorWidget: (context, url, error) => Container(),
          ),
        ),
      );
    } else {
      return columns == 1 ?
      ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            for (var i in card_details)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: InkWell(
                  onTap: () {
                    if (i.type == "PLP") {
                      Navigator.pushNamed(context, SearchScreen.ROUTE_NAME,
                          arguments: {
                            "query": "",
                            "id": "${i.action}",
                            "collection": false,
                            "callback": widget.callback
                          }).then((value) {
                        // widget.callback!(true);
                      });
                    } else if (i.type == "COLLECTION") {
                      Navigator.pushNamed(context, SearchScreen.ROUTE_NAME,
                          arguments: {
                            "query": "",
                            "id": "${i.action}",
                            "collection": true,
                            "callback": widget.callback
                          }).then((value) {
                        // widget.callback!(true);
                      });
                    } else if(i.type ==
                        "PDP"){
                      Navigator.pushNamed(
                        context,
                        ProductDescriptionScreen.ROUTE_NAME,
                        arguments: {
                          "pid": '${i.action}',
                          "callback": (value) {
                            if (value) {
                              widget.callback!(true);
                            }
                          },
                        },
                      );
                    }else if (i.type == "URL") {
                      if(i.action! == "#"){
                        null;
                      }
                      else{
                        _launchInWebView(i.action!);
                      }
                    } else if (i.type == "SP") {
                      Navigator.pushNamed(context, SpecialPage.ROUTE_NAME,
                          arguments: {"id": "${i.action}",
                            "callback":widget.callback
                          }).then((value) {
                        // widget.callback!(true);
                      });
                    }
                    AppsFlyer.bannerClick(
                        i.id!,
                        "PLP",
                        i.action!,
                        i.type!,
                        widget.id != "" ? widget.id! : widget.query!);
                    NetcoreEvents.bannerClick(
                        i.id!,
                        "PLP",
                        i.action!,
                        i.type!,
                        widget.id != "" ? widget.id! : widget.query!);
                  },
                  child: Container(
                    child: CachedNetworkImage(
                      imageUrl: '${i.iconUrlMobile}',
                      placeholder: (context, url) => Image.network(
                        '${i.iconUrlMobile}?w=${SizeConfig.screenWidth / 8}',
                        fit: BoxFit.fill,
                      ),
                      errorWidget: (context, url, error) => Container(),
                    ),
                  ),
                ),
              )
          ]
      )
          :
      MasonryGridView.count(
        itemCount: card_details.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              if (card_details[i].type == "PLP") {
                Navigator.pushNamed(context, SearchScreen.ROUTE_NAME,
                    arguments: {
                      "query": "",
                      "id": "${card_details[i].action}",
                      "collection": false,
                      "callback": widget.callback
                    }).then((value) {
                  // widget.callback!(true);
                });
              } else if (card_details[i].type == "COLLECTION") {
                Navigator.pushNamed(context, SearchScreen.ROUTE_NAME,
                    arguments: {
                      "query": "",
                      "id": "${card_details[i].action}",
                      "collection": true,
                      "callback": widget.callback
                    }).then((value) {
                  // widget.callback!(true);
                });
              } else if(card_details[i].type ==
                  "PDP"){
                Navigator.pushNamed(
                  context,
                  ProductDescriptionScreen.ROUTE_NAME,
                  arguments: {
                    "pid": '${card_details[i].action}',
                    "callback": (value) {
                      if (value) {
                        widget.callback!(true);
                      }
                    },
                  },
                );
              }else if (card_details[i].type == "URL") {
                if(card_details[i].action! == "#"){
                  null;
                }
                else{
                  _launchInWebView(card_details[i].action!);
                }
              } else if (card_details[i].type == "SP") {
                Navigator.pushNamed(context, SpecialPage.ROUTE_NAME,
                    arguments: {"id": "${card_details[i].action}",
                      "callback":widget.callback
                    }).then((value) {
                  // widget.callback!(true);
                });
              }
              AppsFlyer.bannerClick(
                  card_details[i].id!,
                  "PLP",
                  card_details[i].action!,
                  card_details[i].type!,
                  widget.id != "" ? widget.id! : widget.query!);
              NetcoreEvents.bannerClick(
                  card_details[i].id!,
                  "PLP",
                  card_details[i].action!,
                  card_details[i].type!,
                  widget.id != "" ? widget.id! : widget.query!);
            },
            child: CachedNetworkImage(
              imageUrl: '${card_details[i].iconUrlMobile}',
              placeholder: (context, url) => Image.network(
                '${card_details[i].iconUrlMobile}?w=${SizeConfig.screenWidth / 8}',
                fit: BoxFit.fill,
              ),
              errorWidget: (context, url, error) => Container(),
            ),
          );
        },
      );
    }
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget getPageBanner(String plpBanner) {
    return Container(
      width: SizeConfig.screenWidth,
      child: CachedNetworkImage(
        imageUrl:
        '${plpBanner}',
        fit: BoxFit.scaleDown,
        maxWidthDiskCache: 520,
        placeholder: (context,
            url) =>
            Image.network('${
                plpBanner
            }?w=${SizeConfig.screenWidth/8}' ,
              fit: BoxFit.fitWidth,
              cacheWidth: 10,
            ),
        errorWidget:
            (context, url, error) =>
            Container(
            ),
      ),
    );
  }

  Future sortByFilter(BuildContext context, List<SortByData>? sortList) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: sortList!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("${sortList[index].key}"),
                  selected: sortList[index].isSelected!,
                  onTap: () {
                    log("${sortList[index].key}");
                    Navigator.pop(context, sortList[index].key);
                  },
                );
              },
            );
          },
        );
      },
    ).then((value) {
      log("${value}");
      if (value != null) {
        pageNo = 0;
        sortBy = value;
        getSearchData();
      }
    });
  }
}
