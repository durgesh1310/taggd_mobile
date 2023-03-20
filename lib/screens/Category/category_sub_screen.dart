import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ouat/CustomWidget/sub_category_listTile.dart';
import 'package:ouat/data/models/categoryModel.dart';
import '../../size_config.dart';

class SubCategory extends StatefulWidget {
  List<ParentChildResponse?> parentChildResponse;
  String? title;
  String? imageUrl;
  var callback;

  SubCategory({
    required this.parentChildResponse,
    required this.title,
    required this.imageUrl,
    this.callback
  });

  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              pinned: true,
              centerTitle: false,
              title: Text(
                "${widget.title}",
                style: TextStyle(
                  fontFamily: 'RecklessNeue',
                    fontWeight: FontWeight.bold,
                    fontSize: 2 * SizeConfig.textMultiplier,
                    color: Colors.black,
                    ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return SubCategoryListTile(
                  index: index,
                  parentChildResponse: widget.parentChildResponse[index],
                  callback: widget.callback,
                );
              }, childCount: widget.parentChildResponse.length
              ),
            ),
          ],
        ),
      ),
    );
  }
}
