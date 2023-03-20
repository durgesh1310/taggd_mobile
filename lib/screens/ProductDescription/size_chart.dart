
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SizeChart extends StatelessWidget {
  String imageUrl;
  SizeChart(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
            'Size Guide',
          style: TextStyle(
              fontFamily: 'RecklessNeue',
            color: Colors.black
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back,
              color: Colors.black
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          child: CachedNetworkImage(
            fit: BoxFit.scaleDown,
            imageUrl: '${imageUrl}',
            placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation(Colors.pink),
                )),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
