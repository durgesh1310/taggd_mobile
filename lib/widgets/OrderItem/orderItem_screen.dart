import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ouat/data/models/orderListingModel.dart';
import 'package:ouat/screens/OrderDescription/order_description_screen.dart';
import 'package:ouat/size_config.dart';
import 'package:intl/intl.dart';



class OrderItem extends StatelessWidget {
  OrderListDetailResponse? orderListDetailResponse;
  var callback;
  OrderItem(this.orderListDetailResponse,this.callback);
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, OrderDescriptionScreen.ROUTE_NAME, arguments: {
          "order_number": orderListDetailResponse!.orderNumber,
          "callback": (value){
            callback(true);
          }
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Order No:',
                    style: TextStyle(
                      fontFamily: 'RecklessNeue',
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(right: 30),
                    child: Text(
                        'Order Date:',
                      style: TextStyle(
                        fontFamily: 'RecklessNeue',
                          fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '${orderListDetailResponse!.orderNumber}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      fontSize: textScale>1 ? 1.6*SizeConfig.textMultiplier : 1.4*SizeConfig.textMultiplier,
                    ),
                  ),
                  Text(
                      '${orderListDetailResponse!.orderDate}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      fontSize: textScale>1 ? 1.6*SizeConfig.textMultiplier : 1.4*SizeConfig.textMultiplier,
                    ),
                  )
                ],
              ),
              Column(
                children: orderListDetailResponse!.orderResponseList!.map(
                        (e) => Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Container(
                                    width: 20*SizeConfig.widthMultiplier,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl:
                                      e.thumbNailImageUrl ??
                                          "",
                                      placeholder: (context,
                                          url) =>
                                          Container(),
                                      errorWidget:
                                          (context, url, error) =>
                                          Container(),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: SizeConfig.screenWidth/2,
                                  child: Padding(
                                    padding:  EdgeInsets.only(top: 8.0, left: 8),
                                    child: Text(
                                      '${e.itemName}',
                                      maxLines: 4,
                                      style: TextStyle(
                                          fontFamily: 'RecklessNeue',
                                          fontWeight: FontWeight.bold,
                                        fontSize: 1.9*SizeConfig.textMultiplier
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                if(e.item_pay_amount != 0)
                                Padding(
                                  padding:  EdgeInsets.only(top: 8.0, left: 8),
                                  child: Text(
                                      '₹${numberFormat.format(e.item_pay_amount!.round())}',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: 'Status : ',
                                      style: TextStyle(
                                          fontFamily: 'RecklessNeue',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '${e.orderStatus}',
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xffcd3a62)
                                          ),
                                        ),
                                      ]
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${e.orderStatusDate}',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                ).toList(),
              ),
              Divider(
                color: const Color(0xffcd3a62),
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
