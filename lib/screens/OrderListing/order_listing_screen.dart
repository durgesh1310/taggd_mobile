import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ouat/data/models/orderListingModel.dart';
import 'package:ouat/screens/Login/login_screen.dart';
import 'package:ouat/screens/OrderListing/order_listing_bloc.dart';
import 'package:ouat/screens/Splash/splash_screen.dart';
import 'package:ouat/widgets/OrderItem/orderItem_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../../size_config.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:ouat/widgets/message_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import './order_listing_state.dart';
import './order_listing_event.dart';
import './order_listing_bloc.dart';

class OrderListingScreen extends StatefulWidget {
  static const String ROUTE_NAME = "OrderListingScreen";

  @override
  State<OrderListingScreen> createState() => _OrderListingScreenState();
}

class _OrderListingScreenState extends State<OrderListingScreen> {
  late OrderListingBloc orderListingBloc = OrderListingBloc(SearchInitState());
  OrderListingModel? orderListingModel = OrderListingModel();
  int pageNo = 1;
  List<OrderListDetailResponse>? orderListDetailResponse = [];
  ScrollController _scrollController = ScrollController();
  bool isLastPosition = false;


  bool stopShowingCirclularBar = true;

  @override
  void initState() {
    // categoryBloc = BlocProvider.of<CategoryBloc>(context);
    getOrderListingInitState();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  getOrderListingInitState() async {
    orderListingBloc.add(LoadEvent(pageNo));
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        isLastPosition = true;
      });
      pageNo += 1;
      // getSearchData();

      getNextPageData();

      // _bloc.add(FetchNextPageEvent(widget.category!.id, pageNo,
      //     productListState.response, selectedTag, sortingType, isBackSoon));
    }
  }

  getNextPageData() {
    orderListingBloc.add(NextSearchLoadEvent(pageNo, orderListDetailResponse));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder(
      bloc: orderListingBloc,
      builder: (BuildContext context, dynamic state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: const Color(0xffffd2d2),
            title: Text(
              "My Orders",
              style: TextStyle(
                  fontFamily: 'RecklessNeue',
                  fontWeight: FontWeight.bold,
                  fontSize: 2 * SizeConfig.textMultiplier,
                  color: Colors.black),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            child: BaseBlocListener(
              bloc: orderListingBloc,
              listener: (context, state) {
                if (state is CompletedState) {
                  orderListingModel = state.orderListingModel;
                  if (orderListingModel!.data != null) {
                    orderListDetailResponse =
                        state.orderListingModel!.data!.orderListDetailResponse;
                   if( orderListingModel!.data!.orderListDetailResponse!.length < 6){
                     stopShowingCirclularBar = false;
                   }
                  }
                }

                if (state is NoMoreItemState) {
                  this.stopShowingCirclularBar = false;
                  //Fluttertoast.showToast(msg: "No more items");
                }
              },
              child: getBody(),
            ),
          ),
        );
      },
    );
  }

  Widget searchSimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.builder(
          itemCount: 4,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight / 2,
              color: Color(0xFFDBFFE9),
            );
          }),
    );
  }

  Widget getBody() {
    return BaseBlocBuilder(
      bloc: orderListingBloc,
      builder: (BuildContext context, BaseState state) {
        if (state is LoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
          // if((pageNo)*count <= orderListDetailResponse!.length){
          //   return searchSimmer();
          // }
        }

        if (state is CompletedState) {
          if (orderListingModel!.data != null &&
              orderListingModel!.data!.orderListDetailResponse!.length > 0) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: orderListDetailResponse!.length,
                      itemBuilder: (context, index) {
                        return OrderItem(orderListDetailResponse![index],
                            (value) {
                          getOrderListingInitState();
                        });
                      }),
                  (this.stopShowingCirclularBar)?CircularProgressIndicator():Container(),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            );
          } else {
            return Container(
              height: MediaQuery.of(context).size.height,

              width: MediaQuery.of(context).size.width,

              // width: SizeConfig.widthMultiplier,
              child: Column(
                children: [
                  Expanded(
                      child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: CachedNetworkImage(
                            width: 200,
                            height: 200,
                            // fit: BoxFit.fitWidth,
                            imageUrl:
                                "https://taggd.gumlet.io/logo/empty-order-list-icon.png",
                            placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                              strokeWidth: 1,
                              valueColor:
                                  AlwaysStoppedAnimation(Color(0xffcd3a62)),
                            )),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Text(orderListingModel!.message!.first.msgText!),
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
                  ))
                ],
              ),
            );
          }
        } else {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              //SliverToBoxAdapter(
              // child: MessageScreen(orderListingModel!.message!),
              //),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return OrderItem(orderListDetailResponse![index], (value) {
                    getOrderListingInitState();
                  });
                }, childCount: orderListDetailResponse!.length),
              ),
            ],
          );
        }
      },
      condition: (oldState, currentState) {
        return !(BaseBlocBuilder.isBaseState(currentState));
      },
    );
  }
}
