import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ouat/data/models/homeModel.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/remote/api_client.dart';
import 'package:ouat/screens/Account/account_screen.dart';
import 'package:ouat/screens/Cart/cart_screen.dart';
import 'package:ouat/screens/Category/category_screen.dart';
import 'package:ouat/screens/Search/search_screen.dart';
import 'package:ouat/screens/SpecialPage/special_shimmer.dart';
import 'package:ouat/screens/Splash/splash_screen.dart';
import 'package:ouat/size_config.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/utility/thirdParty/netcoreEvents.dart';
import 'package:ouat/widgets/badge.dart';
import 'package:ouat/widgets/custom_bottomBar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Account/help_screen.dart';
import './specialPage_bloc.dart';
import './specialPage_state.dart';
import './specialPage_event.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/screens/ProductDescription/product_description_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';



class SpecialPage extends StatefulWidget {
  static const String ROUTE_NAME = "SpecialPage";
  String id;
  var callback;
  SpecialPage({required this.id, this.callback});

  @override
  _SpecialPageState createState() => _SpecialPageState();
}

class _SpecialPageState extends State<SpecialPage> with SingleTickerProviderStateMixin{
  late ApiClient http;
  late SpecialPageBloc specialPageBloc = SpecialPageBloc(SearchInitState());
  HomeModel? homeModel = HomeModel();
  final _inactiveColor = Colors.grey;
  int _selectedIndex = 0;
  int? count = 0;
  int image_index = 0;
  final CarouselController carousel_controller = CarouselController();

  void _onItemTapped(int index) {
    if(index == 0){
      Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
    }
    else{
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void updateCartItem(bool value) async {
    if(value){
      OrderStatusModel? orderStatusModel = await DataRepo.getInstance().userRepo.getItemsNumber();
      print(orderStatusModel.data);
      setState(() {
        count = orderStatusModel.data;
      });
    }
    else{
      _onItemTapped(4);
    }
  }

  @override
  void initState() {
    // categoryBloc = BlocProvider.of<CategoryBloc>(context);
    updateCartItem(true);
    getInitState();
    super.initState();
  }

  getInitState() async {
    specialPageBloc.add(LoadEvent(widget.id));
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
      bottomNavigationBar: CustomAnimatedBottomBar(
        onItemSelected: _onItemTapped,
        containerHeight: 70,
        backgroundColor: Colors.white,
        selectedIndex: _selectedIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              height: 24,
              width: 24,
            )/*CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl: "https://taggd.gumlet.io/logo/apps/Home.png",
                placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation(Color(0xffcd3a62)),
                )),
                errorWidget: (context, url, error) => Icon(Icons.error),

              )*/,
            title: Text(
              'Taggd',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.88,
                  color: Color(0xff0A0A0A),
                  fontWeight: FontWeight.w500
              ),
            ),
            activeColor: Color(0xffFAD1D8),
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 1 ? 'assets/icons/productsFill.svg' :
              'assets/icons/products.svg',
              height: 26,
              width: 26,
            ) /*CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl:
                    "https://taggd.gumlet.io/logo/apps/Category.png",
                placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation(Color(0xffcd3a62)),
                )),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )*/
            ,
            title: Text(
              'Products',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.88,
                  color: Color(0xff0A0A0A)
              ),
            ),
            activeColor: Color(0xffFAD1D8),
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Badge(
                SvgPicture.asset(
                  _selectedIndex == 2 ?
                  'assets/icons/bagFill.svg' :
                  'assets/icons/bag.svg',
                  height: 26,
                  width: 26,
                ),
                (count! > 0 && count != null) ? count.toString() : "",
                Color(0xffcd3a62),
                10,
                1
            ),
            title: Text(
              'Bag',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.88,
                  color: Color(0xff0A0A0A)
              ),
            ),
            activeColor: Color(0xffFAD1D8),
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 3 ?
              'assets/icons/profileFill.svg' :
              'assets/icons/profile.svg',
              height: 24,
              width: 24,
            ),
            title: Text(
              'Profile',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.88,
                  color: Color(0xff0A0A0A)
              ),
            ),
            activeColor: Color(0xffFAD1D8),
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
        body: Container(
            padding:
            EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: getBottomNavBody()
        ));
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

  Widget getBottomNavBody() {
    switch (_selectedIndex) {
      case 0:
        return BlocProvider(
          create: (context) => specialPageBloc,
          child: BaseBlocListener(
              bloc: specialPageBloc,
              listener: (context, state) {

                if (state is CompletedState) {
                  homeModel = state.homeModel;
                  // setState(() {

                  // });
                }
                if(state is ErrorState){
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
                  bloc: specialPageBloc,
                  condition: (oldState, currentState) {
                    return !(BaseBlocBuilder.isBaseState(currentState));
                  },
                  builder: (BuildContext context, BaseState state) {

                    if (homeModel!.data != null) {
                      return _getBody();
                    } else {
                      return Material(child: SpecialShimmer());
                    }
                  })),
        );

      case 1:
        return CategoryActivity(
          callback: updateCartItem,
        );

      case 2:
        return CartActivity(
          callback: updateCartItem,
        );

      case 3:
        return AccountActivity(
          callback: updateCartItem,
        );

      case 4:
        return HelpScreen(
            callback: (value){
              _onItemTapped(3);
            }
        );

      default:
        return Container();
    }
  }

  Widget _getBody() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (homeModel!.data!.main_carousel != null)
              ? getMainCrousel()
              : Container(),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: homeModel!.data!.page_sections!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: getDynamicPageWidget(
                      homeModel!.data!.page_sections![index]),
                );
              })
        ],
      ),
    );
  }

  Widget getTitle(PageSections pageSections) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: Text(
        "${pageSections.section_name}",
        textAlign: pageSections.section_name == "LEFT"
            ? TextAlign.start
            : TextAlign.center,
        style: TextStyle(
            fontFamily: 'RecklessNeue',
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget getMainCrousel() {
    return homeModel!.data!.main_carousel!.card_details!.length == 0
        ? Container()
        : Container(
      child: Column(
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      autoPlay: true,
                      height: SizeConfig.screenWidth,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason){
                        setState(() {
                          image_index = index;
                        });
                      }
                  ),
                  itemCount:
                  homeModel!.data!.main_carousel!.card_details!.length,
                  itemBuilder:
                      (BuildContext context, int itemIndex, int pageViewIndex) {
                    return clickableImage(
                        homeModel!.data!.main_carousel!.card_details![itemIndex].id!,
                        homeModel!.data!.main_carousel!.card_details![itemIndex].type!,
                        homeModel!.data!.main_carousel!.card_details![itemIndex].action!,
                        homeModel!.data!.main_carousel!.card_details![itemIndex].icon_url_mobile!);
                  },
                ),
              ),
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: homeModel!.data!.main_carousel!.card_details!
                  .asMap()
                  .entries
                  .map((entry) {
                return GestureDetector(
                  onTap: () =>
                      carousel_controller.animateToPage(entry.key),
                  child: Container(
                    width: image_index == entry.key ? 10.0 : 6,
                    height: image_index == entry.key ? 10.0 : 6,
                    margin: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context)
                            .brightness ==
                            Brightness.dark
                            ? const Color(0xffC4C4C4)
                            : Color(0xff5F5F5F))
                            .withOpacity(
                            image_index == entry.key
                                ? 0.9
                                : 0.4)),
                  ),
                );
              }).toList()),
        ],
      ),
    );
  }

  Widget getDynamicPageWidget(PageSections pageSections) {
    switch (pageSections.type) {
      case "PAGE_CAROUSEL":
        return pageSections.detail!.card_details!.length == 0
            ? Container(
          height: 0,
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTitle(pageSections),
            getPageCarousel(pageSections.detail!.card_details),
          ],
        );

      case "BANNER":
        return pageSections.bannerDetail!.card_details!.length == 0
            ? Container(
          height: 0,
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTitle(pageSections),
            getPageBanner(
                pageSections.bannerDetail!.card_details,
                pageSections.bannerDetail!.columns
            ),
          ],
        );

      default:
        return Container();
    }
  }

  Widget getPageCarousel(List<CardDetails>? card_details) {
    return Container(
      child: CarouselSlider.builder(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 1.2,
          enlargeCenterPage: false,
          viewportFraction: 0.6,
        ),
        itemCount: card_details!.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          return clickableImage(
              card_details[itemIndex].id!,
              card_details[itemIndex].type!,
              card_details[itemIndex].action!,
              card_details[itemIndex].icon_url_mobile!);
        },
      ),
    );
  }

  Widget getPageBanner(List<CardDetails>? card_details, int? columns) {
    if (card_details!.length == 1) {
      return clickableImage(
          card_details[0].id!,
          card_details[0].type!,
          card_details[0].action!,
          card_details[0].icon_url_mobile!);
    } else {
      return columns == 1 ?
      ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            for (var i in card_details)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: clickableImage(i.id!, i.type!, i.action!, i.icon_url_mobile!),
              )
          ]
      )
          :
      MasonryGridView.count(
        itemCount: card_details.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: columns!,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        itemBuilder: (context, i) {
          return clickableImage(
              card_details[i].id!,
              card_details[i].type!,
              card_details[i].action!,
              card_details[i].icon_url_mobile!);
        },
      );
    }
  }

  Widget clickableImage(int id, String type, String action, String imageUrl){
    return InkWell(
      onTap: () {
        if (type == "PLP") {
          Navigator.pushNamed(context, SearchScreen.ROUTE_NAME,
              arguments: {
                "query": "",
                "id": "${action}",
                "collection": false,
                "callback": widget.callback
              }).then((value) {
            widget.callback!(true);
          });
        } else if (type == "COLLECTION") {
          Navigator.pushNamed(context, SearchScreen.ROUTE_NAME,
              arguments: {
                "query": "",
                "id": "${action}",
                "collection": true,
                "callback": widget.callback
              }).then((value) {
            widget.callback!(true);
          });
        } else if(type == "PDP"){
          Navigator.pushNamed(
            context,
            ProductDescriptionScreen.ROUTE_NAME,
            arguments: {
              "pid": '${action}',
              "callback": (value) {
                if (value) {
                  widget.callback!(true);
                }
              },
            },
          );
        }
        else if (type == "URL") {
          if(action == "#"){
            null;
          }
          else{
            _launchInWebView(action);
          }
        } else if (type == "SP") {
          Navigator.pushNamed(context, SpecialPage.ROUTE_NAME,
              arguments: {
                "id": "${action}",
                "callback": widget.callback
              }).then((value) {
             widget.callback!(true);
             updateCartItem(true);
          });
        }
        AppsFlyer.bannerClick(id, "SPECIAL", action, type, widget.id);
        NetcoreEvents.bannerClick(id, "SPECIAL", action, type, widget.id);
      },
      child: Container(
        width: double.maxFinite,
        // margin: EdgeInsets.symmetric(horizontal: 20),
        child: CachedNetworkImage(
          imageUrl: '${imageUrl}?w=520',
          maxWidthDiskCache: 520,
          errorWidget: (context, url, error) => Container(),
        ),
      ),
    );
  }
}


