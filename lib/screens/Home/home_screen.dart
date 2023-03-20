import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ouat/data/models/homeModel.dart';
import 'package:ouat/data/models/sortBarModel.dart';
import 'package:ouat/data/remote/api_client.dart';
import 'package:ouat/screens/ScratchCard/scratch_card_screen.dart';
import 'package:ouat/screens/Search/search_screen.dart';
import 'package:ouat/screens/SpecialPage/specialPage_screen.dart';
import 'package:ouat/size_config.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/utility/thirdParty/netcoreEvents.dart';
import 'package:ouat/widgets/SortBar/sortBar_screen.dart';
import 'package:ouat/screens/ProductDescription/product_description_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

bool lastPosition = false;

class HomeActivity extends StatefulWidget {
  HomeModel? homeModel;
  SortBarModel? sortBarModel;
  final ValueChanged<bool>? callback;

  HomeActivity({this.homeModel, this.sortBarModel, this.callback});
  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> with SingleTickerProviderStateMixin {
  double? _height;
  double? _width;
  int image_index = 0;
  TextEditingController searchController = TextEditingController();
  late ApiClient http;
  late List mainCarouselImages = [];
  final CarouselController carousel_controller = CarouselController();
  ScrollController _scroller = ScrollController();



  @override
  void initState() {
    super.initState();
    _scroller.addListener(_scrollListener);
  }



  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: _height,
          width: _width,
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: _getBody(),
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

  void _scrollListener() {
    if (_scroller.position.pixels ==
        _scroller.position.maxScrollExtent) {
      setState(() {
        lastPosition = true;
      });
    }
  }

  Widget _getBody() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        controller: _scroller,
        children: [
          (widget.homeModel!.data!.main_carousel != null)
              ? Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: getMainCrousel(),
              )
              : Container(),
          //Sort Bar
          // Container(
          //     height: SizeConfig.heightMultiplier * 20,
          //     width: SizeConfig.screenWidth,
          //     child: SortBar(
          //       sortBarModel: widget.sortBarModel,
          //       callback: widget.callback,
          //     )),
          if (!lastPosition)
            paginationsearchSimmer(),
          if (lastPosition)
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.homeModel!.data!.page_sections!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: getDynamicPageWidget(
                        widget.homeModel!.data!.page_sections![index]),
                  );
                })
        ],
      ),
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
        childAspectRatio: 1.5,
        crossAxisCount: 1,
        children: <Widget>[
          Container(
            color: Color(0xFFDBFFE9),
          ),
        ],
      ),
    );
  }

  Widget getTitle(PageSections pageSections) {
    return pageSections.section_name != " " ?
    Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "${pageSections.section_name}",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'RecklessNeue',
              fontSize: 26.66,
              //fontWeight: FontWeight.w200,
              color: Colors.black),
        ),
      ),
    ) :
    Container();
  }

  Widget getMainCrousel() {
    return widget.homeModel!.data!.main_carousel!.card_details!.length == 0
        ? Container()
        : Container(
      child: Column(
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: CarouselSlider.builder(
                  carouselController: carousel_controller,
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      scrollPhysics: widget.homeModel!.data!.main_carousel!.card_details!.length == 1 ?
                      NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                      autoPlay: widget.homeModel!.data!.main_carousel!.card_details!.length == 1 ? false :true,
                      height: SizeConfig.screenWidth,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason){
                        setState(() {
                          image_index = index;
                        });
                      }
                  ),
                  itemCount:
                  widget.homeModel!.data!.main_carousel!.card_details!.length,
                  itemBuilder:
                      (BuildContext context, int itemIndex, int pageViewIndex) {
                    return clickableImage(
                        widget.homeModel!.data!.main_carousel!.card_details![itemIndex].id!,
                        widget.homeModel!.data!.main_carousel!.card_details![itemIndex].type!,
                        widget.homeModel!.data!.main_carousel!.card_details![itemIndex].action!,
                        widget.homeModel!.data!.main_carousel!.card_details![itemIndex].icon_url_mobile!, true);
                  },
                ),
              ),
            ],
          ),
          widget.homeModel!.data!.main_carousel!.card_details!.length == 1 ?
              Container() :
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.homeModel!.data!.main_carousel!.card_details!
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

  Widget getDynamicPageWidget(PageSections pageSections){
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
            getPageBanner(pageSections.bannerDetail!.card_details,
                pageSections.bannerDetail!.columns),
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
          viewportFraction: 0.52,
        ),
        itemCount: card_details!.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: clickableImage(
                card_details[itemIndex].id!,
                card_details[itemIndex].type!,
                card_details[itemIndex].action!,
                card_details[itemIndex].icon_url_mobile!, false),
          );
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
          card_details[0].icon_url_mobile!, false);
    } else {
      return columns == 1 ?
      ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            for (var i in card_details)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: clickableImage(i.id!, i.type!, i.action!, i.icon_url_mobile!, false),
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
              card_details[i].icon_url_mobile!, false);
        },
      );
    }
  }


  Widget clickableImage(int id, String type, String action, String imageUrl, bool main){
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
          });
        }
        else if (type == "SCRATCHCARD") {
          Navigator.pushNamed(context, ScratchCardScreen.ROUTE_NAME).then((value) {
            widget.callback!(true);
          });
        }
        AppsFlyer.bannerClick(id, "HOME", action, type, "0");
        NetcoreEvents.bannerClick(id, "HOME", action, type, "0");
      },
      child: Container(
        width: double.maxFinite,
        // margin: EdgeInsets.symmetric(horizontal: 20),
        child: CachedNetworkImage(
          imageUrl: '${imageUrl}?w=520',
          /*placeholder: (context, url) => main ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: true,
              child: Container(
                //width: SizeConfig.screenWidth,
                //height: SizeConfig.screenHeight/1.5,
                color: Color(0xFFDBFFE9),
              )
          ) : Container(),*/
          maxWidthDiskCache: 520,
          errorWidget: (context, url, error) => Container(),
        ),
      ),
    );
  }
}