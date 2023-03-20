import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ouat/data/models/NetBankingModel.dart';

class BankScreen extends StatefulWidget {
  static const String ROUTE_NAME = "BankScreen";
  List<NetBankingModel>? bank;
  var callback;
  BankScreen({this.bank, this.callback});
  @override
  _BankScreenState createState() => new _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  Widget appBarTitle = new Text(
    "Banks",
    style: new TextStyle(color: Colors.white),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  List<dynamic> _list = [];
  bool _isSearching = false;
  String _searchText = "";
  List searchresult = [];
  List searchLogo = [];
  List searchKey = [];

  _BankScreenState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    values();
  }

  void values() {
    _list = widget.bank!;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: globalKey,
        appBar: buildAppBar(context),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                  child: searchresult.length != 0 || _controller.text.isNotEmpty
                      ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchresult.length,
                    itemBuilder: (BuildContext context, int index) {
                      String listData = searchresult[index];
                      String logo = searchLogo[index];
                      log(searchLogo.toString());
                      return ListTile(
                        onTap: (){
                          widget.callback(searchKey[index]);
                          Navigator.pop(context);
                        },
                        leading:  CachedNetworkImage(
                          height: 30,
                          width: 30,
                          fit: BoxFit.scaleDown,
                          imageUrl: '${logo}',
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                valueColor: AlwaysStoppedAnimation(Color(0xffcd3a62)),
                              )),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        title: Text(listData.toString()),
                      );
                    },
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.bank!.length,
                    itemBuilder: (BuildContext context, int index) {
                      String? listData = widget.bank![index].bankName;
                      return new ListTile(
                        onTap: (){
                          widget.callback(widget.bank![index].bankKey);
                          Navigator.pop(context);
                        },
                        leading:  CachedNetworkImage(
                          height: 30,
                          width: 30,
                          fit: BoxFit.scaleDown,
                          imageUrl: '${widget.bank![index].bankLogoUrl}',
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                valueColor: AlwaysStoppedAnimation(Color(0xffcd3a62)),
                              )),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        title: new Text(listData.toString()),
                      );
                    },
                  ))
            ],
          ),
        ));
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
        centerTitle: true,
        title: appBarTitle,
        backgroundColor: Color(0xffD73656),
        actions: <Widget>[
          IconButton(
            icon: icon,
            onPressed: () {
              setState(() {
                if (this.icon.icon == Icons.search) {
                  this.icon =  Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = TextField(
                    controller: _controller,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.white)),
                    onChanged: searchOperation,
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = Text(
        "Banks",
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _controller.clear();
      searchresult.clear();
      searchLogo.clear();
      searchKey.clear();
    });
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    searchKey.clear();
    searchLogo.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _list.length; i++) {
        String? data = widget.bank![i].bankName;
        String? logoBank = widget.bank![i].bankLogoUrl;
        String? bankKey = widget.bank![i].bankKey;
        if (data!.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
          searchKey.add(bankKey);
          searchLogo.add(logoBank);
          //log(searchLogo.toString());
        }
      }
    }
  }
}