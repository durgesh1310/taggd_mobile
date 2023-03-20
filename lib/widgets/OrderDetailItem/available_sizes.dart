import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:ouat/data/models/sizeExchangingModel.dart';
import '../../size_config.dart';

class ExchangeAvailableSizes extends StatefulWidget {
  List<SkuResponseDetails>? skuResponse;
  var callbackFunction;
  ExchangeAvailableSizes(
      this.skuResponse,
      this.callbackFunction
      );

  @override
  State<ExchangeAvailableSizes> createState() => _ExchangeAvailableSizesState();
}

class _ExchangeAvailableSizesState extends State<ExchangeAvailableSizes> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        SizedBox(height: 2*SizeConfig.heightMultiplier,),
        CustomRadioButton(
          elevation: 0,
          height: 45,
          unSelectedBorderColor: Colors.grey,
          selectedBorderColor: Color(0xffcd3a62),
          unSelectedColor: Theme.of(context).canvasColor,
          buttonLables: widget.skuResponse!.map((e) =>
          '${e.skuSize}'
          ).toList(),
          buttonValues: widget.skuResponse!.map((e) =>
          '${e.skuSize}'
          ).toList(),
          buttonTextStyle: ButtonTextStyle(
              selectedColor: Colors.white,
              unSelectedColor: Colors.black,
              textStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 2*SizeConfig.textMultiplier
              )
          ),
          radioButtonValue: (value) {
            int index = 0;
            for(int i = 0; i<widget.skuResponse!.length;i++){
              if(value == widget.skuResponse![i].skuSize){
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
}

