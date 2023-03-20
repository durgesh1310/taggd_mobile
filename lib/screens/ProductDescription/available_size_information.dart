import 'dart:developer';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:ouat/data/models/productDescriptionModel.dart';
import 'package:ouat/screens/ProductDescription/size_chart.dart';
import '../../size_config.dart';

class AvailableSize extends StatefulWidget {
  String? imageUrl;
  List<SkuResponse>? skuResponse;
  var callbackFunction;
  AvailableSize(
      this.imageUrl,
    this.skuResponse,
    this.callbackFunction
  );

  @override
  _AvailableSizeState createState() => _AvailableSizeState();
}

class _AvailableSizeState extends State<AvailableSize> {
  List notOutOfStock = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available Sizes',
              style: TextStyle(
                  fontFamily: 'RecklessNeue',
                  color: Colors.black,
                  fontSize: 2*SizeConfig.textMultiplier,
                  fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.start,
            ),
            widget.imageUrl == null ?
                Container() :
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SizeChart(widget.imageUrl!)),
                );
              },
              child: Text(
                'Size Guide',
                style: TextStyle(
                    fontFamily: 'RecklessNeue',
                    color: Color(0xffcd3a62),
                    fontSize: 1.75*SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        SizedBox(height: 2*SizeConfig.heightMultiplier,),
        CustomRadioButton(
          elevation: 0,
          height: 45,
          unSelectedBorderColor: Colors.grey,
          selectedBorderColor: Color(0xffcd3a62),
          unSelectedColor: Theme.of(context).canvasColor,
          buttonLables: notOutOfStock.map((e) =>
          '${e.size}'
          ).toList(),
          buttonValues: notOutOfStock.map((e) =>
          '${e.size}'
          ).toList(),
          buttonTextStyle: ButtonTextStyle(
              selectedColor: Colors.white,
              unSelectedColor: Colors.black,
              textStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 2*SizeConfig.textMultiplier,
              )
          ),
          radioButtonValue: (value) {
            int index = 0;
            log(value.toString());
            for(int i = 0; i<widget.skuResponse!.length;i++){
              if(value == widget.skuResponse![i].size){
                index = i;
              }
            }
            widget.callbackFunction(index);
          },
          selectedColor: Colors.black,
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier,
        ),
        Divider(
          color: const Color(0xfff9d8d8),
          thickness: 1,
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier,
        ),
      ],
    );
  }

  @override
  void initState() {
    for(var element in widget.skuResponse!){
      if(element.inventoryCount! > 0){
        notOutOfStock.add(element);
      }
    }
    super.initState();
  }
}
