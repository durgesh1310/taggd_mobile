import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouat/data/models/productDescriptionModel.dart';
import '../../size_config.dart';

class ProductInformation extends StatelessWidget {
  List<PdpDetailDescription>? productDescription;
   ProductInformation({required this.productDescription});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: productDescription!.length,
        itemBuilder: (context, index) {
          return getProductInformation(productDescription![index].detail, productDescription![index].displayLabel);
        }
      )
    );
  }

  Widget getProductInformation(List<Detail>? detail, String? displayLabel){
    switch(displayLabel){
      case "Summary":
        return detail!.length == 0 ?
        Container(
          height: 0,
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.heightMultiplier,),
            Text(
              '$displayLabel',
              style: TextStyle(
                  fontFamily: 'RecklessNeue',
                  fontSize: 2*SizeConfig.textMultiplier,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: SizeConfig.heightMultiplier,),
            //getProductInformation(productDescription![]),
            Text(
              '${detail[0].value}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 1.8*SizeConfig.textMultiplier,
              ),
            ),
          ],
        );

      case "Product Attributes":
        return detail!.length == 0 ?
        Container(
          height: 0,
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2*SizeConfig.heightMultiplier,),
            Text(
              '${displayLabel}',
              style: TextStyle(
                  fontFamily: 'RecklessNeue',
                  fontSize: 2*SizeConfig.textMultiplier,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: SizeConfig.heightMultiplier,),
            Table(
                children: detail.map((e) =>
                    TableRow(
                        children: [
                          Padding(
                            padding:  EdgeInsets.all(2*SizeConfig.heightMultiplier),
                            child: Text(
                              '${e.key}',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 1.8*SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(2*SizeConfig.heightMultiplier),
                            child: Text(
                              '${e.value}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 1.8*SizeConfig.textMultiplier,
                              ),
                            ),
                          )
                        ]
                    ),
                ).toList()
            ),
          ],
        );

      case "Shipping & Return Policy":
        return detail!.length == 0 ?
        Container(
          height: 0,
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.heightMultiplier,),
            Text(
              'Shipping & Return Policy',
              style: TextStyle(
                  fontFamily: 'RecklessNeue',
                  fontSize: 2*SizeConfig.textMultiplier,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: SizeConfig.heightMultiplier,),
            RichText(
                text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'To check our Return and Exchange policies, Please ',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.black
                          )
                      ),
                      TextSpan(
                          text: 'Click Here',
                          style: TextStyle(
                              color: Color(0xffcd3a62)
                          )
                      )
                    ]
                )
            ),
          ],
        );

      default:
        return Container();
    }
  }
}
