import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:ouat/data/models/orderConfirmationModel.dart';
import 'package:ouat/size_config.dart';
import 'package:intl/intl.dart';




class OrderConfirmItemScreen extends StatelessWidget {
  OrderItem? orderItem;
  OrderConfirmItemScreen(this.orderItem);
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                width: 20*SizeConfig.widthMultiplier,
                child: CachedNetworkImage(
                  fit: BoxFit.fitWidth,
                  imageUrl:
                  orderItem!.itemDetail!.imageUrl!,
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
                  '${orderItem!.itemDetail!.itemName}',
                  style: TextStyle(
                      fontFamily: 'RecklessNeue',
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 1.9*SizeConfig.textMultiplier
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding:  EdgeInsets.only(top: 8.0, left: 8),
              child: Text(
                '₹${numberFormat.format(orderItem!.itemDetail!.itemPayable!.round())}',
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
                      text: '${orderItem!.orderStatus}',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Color(0xffcd3a62)
                      ),
                    ),
                  ]
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
                'Quantity: ${orderItem!.itemDetail!.quantity}',
              style: TextStyle(
                fontFamily: 'RecklessNeue',
              ),
            )
          ],
        ),
      ],
    );
  }
}
