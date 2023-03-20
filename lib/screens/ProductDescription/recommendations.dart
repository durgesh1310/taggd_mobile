import 'package:flutter/material.dart';
import 'package:ouat/data/models/recommendationModel.dart';
import 'package:ouat/size_config.dart';
import 'package:ouat/widgets/ProductItem/productItem_screen.dart';

class Recommendations extends StatelessWidget {
  RecommendationModel recommendationModel;
  final ValueChanged<bool>? callback;
  Recommendations(this.recommendationModel,this.callback);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recommendationModel.data!.results!.length,
      itemBuilder: (context, index){
        return recommendationModel.data!.results![index].values!.length > 0 ?
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text(
                '${recommendationModel.data!.results![index].key}',
                style: TextStyle(
                    fontFamily: 'RecklessNeue',
                    fontSize: 2 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendationModel.data!.results![index].values!.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ProductItem(
                          plpCard: recommendationModel.data!.results![index].values![i],
                          callback: (val) {
                            if (callback != null) {
                              callback!(val);
                            }
                          }, //callback: widget.callback,
                        ),
                      );
                    }
                ),
              ),
            ),
          ],
        ):
        Container(height: 0,);
      },
    );
  }
}