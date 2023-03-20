import 'package:flutter/material.dart';
import '../size_config.dart';
import 'package:intl/intl.dart';



class ShowOrderSummary extends StatelessWidget {
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');
  double? subtotal;
  double? platformDiscount;
  double? promoDiscount;
  String? promoCode;
  double? credits;
  String? creditsType;
  double? deliveryCharges;
  String? shippingMessage;
  double? totalSavings;
  double? orderTotal;
  ShowOrderSummary({
    this.subtotal,
    this.platformDiscount,
    this.promoDiscount,
    this.promoCode,
    this.credits,
    this.creditsType,
    this.deliveryCharges,
    this.shippingMessage,
    this.totalSavings,
    this.orderTotal});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "ORDER SUMMARY",
          style: TextStyle(
              fontFamily: 'RecklessNeue',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 2 *
                  SizeConfig.textMultiplier),
        ),
        Text(
          "Includes GST and all government taxes",
          style: TextStyle(
              fontFamily: 'Inter',
              color: Colors.grey,
              fontStyle: FontStyle.italic),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8.0),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              Text(
                "Subtotal",
                style: TextStyle(
                  fontFamily: 'RecklessNeue',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "₹${numberFormat.format(subtotal!.round())}",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
        platformDiscount ==
            0.0
            ? Container()
            : Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8.0),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              Text(
                "TAGGD Discount",
                style: TextStyle(
                  fontFamily:
                  'RecklessNeue',
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
              Text(
                "₹${numberFormat.format(platformDiscount!.round())}",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
        promoDiscount! > 0
            ? Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8.0),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              Text(
                "Discount ($promoCode)",
                style: TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  fontFamily:
                  'RecklessNeue',
                  color: Color(0xffcd3a62),
                ),
              ),
              Text(
                "₹${numberFormat.format(promoDiscount!.round())}",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        )
            : Container(),
        credits! > 0.0 ?
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${creditsType}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RecklessNeue',
                ),
              ),
              Text(
                "₹${numberFormat.format(credits!.round())}",
                style: TextStyle(
                  color: Color(0xffcd3a62),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ) :
        Container(),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8.0),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              Text(
                "Shipping",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RecklessNeue',
                ),
              ),
              Text(
                "₹${numberFormat.format(deliveryCharges!.round())}",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
        shippingMessage != null
            ? Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8.0),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment
                .center,
            children: [
              Text(
                "${shippingMessage}",
                style: TextStyle(
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        )
            : Container(),
        totalSavings == 0.0
            ? Container()
            : Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8.0),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              Text(
                "Total Savings",
                style: TextStyle(
                    fontFamily:
                    'RecklessNeue',
                    fontWeight:
                    FontWeight.bold,
                    color: Colors.green),
              ),
              Text(
                "₹${numberFormat.format(totalSavings!.round())}",
                style: TextStyle(
                  color:
                  Colors.green,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 2,
          color: Color(0xffcd3a62),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8.0),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              Text(
                "Order Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RecklessNeue',
                ),
              ),
              Text(
                "₹${numberFormat.format(orderTotal!.round())}",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
