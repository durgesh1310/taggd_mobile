import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ouat/data/models/searchModel.dart';
import '../../size_config.dart';
import 'package:ouat/screens/Search/search_bloc.dart';
import 'package:ouat/screens/Search/search_state.dart';
import 'package:intl/intl.dart';



class FiltersScreen extends StatefulWidget {
  List<Filters>? filters;
  static const ROUTE_NAME = 'FiltersScreen';
  FiltersScreen({required this.filters});

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen>
    with SingleTickerProviderStateMixin {
  late SearchBloc searchBloc = SearchBloc(SearchInitState());
  int? selectedIndex;
  String? type = "";
  List selectedata = [];
  int div = 1;
  double _lowerValue = 0;
  double _upperValue = 0;
  late RangeValues _currentRangeValues;
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("${widget.filters}");
    selectedIndex = 0;
    type = widget.filters![0].type;
    _currentRangeValues = RangeValues(
        double.parse(widget
            .filters![0].data![0].value
            .toString()),
        double.parse(widget
            .filters![0].data![1].value
            .toString()));
    _lowerValue = double.parse(widget
        .filters![0].data![0].value
        .round()
        .toString());
    _upperValue = double.parse(widget
        .filters![0].data![1].value
        .round()
        .toString());
    if (widget.filters![0].displayName ==
        'Price') {
      div = 100;
    } else {
      div = _currentRangeValues.end.toInt();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          TextButton(
            // textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context, []);
            },
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
            child: Text("Clear All"),
            // shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffcd3a62))
            ),
            child: TextButton(
              // textColor: Colors.white,
              onPressed: () {
                widget.filters!.forEach((element) {
                  // int index = widget.filters!.indexOf(element);

                  element.data!.forEach((localelement) {
                    // log("${element.isSelected}")
                    SelectedFilterData selectedFilterData = SelectedFilterData();
                    if (localelement.isSelected ?? false) {
                      if (localelement.from != null || localelement.to != null) {
                        selectedFilterData.value = localelement.key;
                        selectedFilterData.type = element.type;
                        selectedFilterData.keyData = element.filterName;
                        selectedFilterData.from = localelement.from.toString();
                        selectedFilterData.to = localelement.to.toString();
                      } else {
                        selectedFilterData.value = localelement.key;
                        selectedFilterData.type = element.type;
                        selectedFilterData.keyData = element.filterName;
                      }
                      selectedata.add(selectedFilterData.toJson());
                      log("${element.filterName}");
                      // log("${element.type}");

                    }
                  });
                });
                // selectedata.add(selectedFilterData.toJson());
                log("SELEKLKELKRLKRLEKR");
                log("${selectedata}");
                Navigator.pop(context, selectedata);
              },
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
              child: Text(
                  "Apply",
                style: TextStyle(
                  color: Color(0xffcd3a62)
                ),
              ),
              // shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ),
        ],
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Row(
          children: [
            Container(
              width: SizeConfig.screenWidth/3.5,
              height: SizeConfig.screenHeight,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: getTypeFilterDisplayName(),
            ),
            Expanded(child: getFilterSelectedName())
          ],
        ),
      ),
    );
  }

  Widget getTypeFilterDisplayName() {
    return ListView.builder(
      itemCount: widget.filters!.length,
      itemBuilder: (context, index) {
        String filterName = widget.filters![index].displayName ?? "";
        return GestureDetector(
          onTap: () {
            type = widget.filters![index].type;
            setState(() {
              selectedIndex = index;
              if (type == 'range') {
                _currentRangeValues = RangeValues(
                    double.parse(widget
                        .filters![selectedIndex ?? 0].data![0].value
                        .toString()),
                    double.parse(widget
                        .filters![selectedIndex ?? 0].data![1].value
                        .toString()));
                _lowerValue = double.parse(widget
                    .filters![selectedIndex ?? 0].data![0].value
                    .round()
                    .toString());
                _upperValue = double.parse(widget
                    .filters![selectedIndex ?? 0].data![1].value
                    .round()
                    .toString());
                if (widget.filters![selectedIndex ?? 0].displayName ==
                    'Price') {
                  div = 100;
                } else {
                  div = _currentRangeValues.end.toInt();
                }
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
                color: (selectedIndex == index)
                    ? Colors.white
                    : Colors.transparent,
                border: Border.all(
                    color: (selectedIndex == index)
                        ? Colors.white
                        : Colors.black12)),
            child: Text(
              filterName,
              style: TextStyle(
                  fontFamily: 'RecklessNeue',
                  fontWeight: (selectedIndex == index)
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ),
        );
      },
    );
  }

  Widget getFilterSelectedName() {
    switch (type) {
      case 'range':
        return getRange();

      case 'term':
        return getTermWidget();

      default:
        return Container();
    }
  }

  Widget getRange() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '${widget.filters![selectedIndex ?? 0].displayName} Range',
            style: TextStyle(
                fontFamily: 'RecklessNeue',
                fontWeight: FontWeight.bold,
                fontSize: 2.5 * SizeConfig.textMultiplier),
          ),
        ),
        RangeSlider(
          inactiveColor: Colors.black,
          activeColor: Color(0xffcd3a62),
          values: _currentRangeValues,
          onChangeEnd: (RangeValues endValues) {
            log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Adding");
            log("${widget.filters![selectedIndex ?? 0].displayName}");
            widget.filters![selectedIndex ?? 0].data![0].isSelected = true;
            // widget.filters![selectedIndex ?? 0].data![1].isSelected = true;
            widget.filters![selectedIndex ?? 0].data![0].from =
                endValues.start.roundToDouble();
            widget.filters![selectedIndex ?? 0].data![0].to =
                endValues.end.roundToDouble();
          },
          max: double.parse(
              widget.filters![selectedIndex ?? 0].data![1].value.toString()),
          min: double.parse(
              widget.filters![selectedIndex ?? 0].data![0].value.toString()),
          labels: RangeLabels(
            _currentRangeValues.start.round().toString(),
            _currentRangeValues.end.round().toString(),
          ),
          divisions: div,
          onChanged: (RangeValues values) {
            _lowerValue = values.start.round().toDouble();
            _upperValue = values.end.round().toDouble();
            setState(() {
              _currentRangeValues = values;
            });
          },
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.filters![selectedIndex ?? 0].displayName == 'Price'
                  ? '₹' + numberFormat.format(_lowerValue.round()).toString()
                  : _lowerValue.round().toString() + '%',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 2 * SizeConfig.textMultiplier),
            ),
            Text(
              '-',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 2 * SizeConfig.textMultiplier),
            ),
            Text(
              widget.filters![selectedIndex ?? 0].displayName == 'Price'
                  ? '₹' + numberFormat.format(_upperValue.round()).toString()
                  : _upperValue.round().toString() + '%',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 2 * SizeConfig.textMultiplier),
            )
          ],
        ),
      ],
    );
  }

  Widget getTermWidget() {
    return (selectedIndex != null)
        ? ListView.builder(
            itemCount: widget.filters![selectedIndex ?? 0].data!.length,
            itemBuilder: (context, index) {
              String name =
                  widget.filters![selectedIndex ?? 0].data![index].key ?? "";
              String value = widget
                  .filters![selectedIndex ?? 0].data![index].value
                  .toString();
              if(widget.filters![selectedIndex ?? 0].data![index].otherInfo != null
              && widget.filters![selectedIndex ?? 0].filterName == 'color' &&
                  widget.filters![selectedIndex ?? 0].displayName == 'Color'){
                Color color = widget
                    .filters![selectedIndex ?? 0].data![index].otherInfo!.isEmpty ?
                const Color(0xFFFFFF) :
                HexColor.fromHex(widget
                    .filters![selectedIndex ?? 0].data![index].otherInfo!);
                return CheckboxListTile(
                  value: widget.filters![selectedIndex ?? 0].data![index]
                      .isSelected,
                  onChanged: (bool? value){
                    setState(() {
                      if (widget.filters![selectedIndex ?? 0].data![index]
                          .isSelected ??
                          false) {
                        log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Removing");
                        log("${widget.filters![selectedIndex ?? 0].displayName}");
                        widget.filters![selectedIndex ?? 0].data![index]
                            .isSelected = false;
                      } else {
                        log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Adding");
                        log("${widget.filters![selectedIndex ?? 0].displayName}");
                        widget.filters![selectedIndex ?? 0].data![index]
                            .isSelected = true;
                      }
                    });
                  },
                  secondary: Text(
                    value,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.grey,
                        fontStyle: FontStyle.italic),
                  ),
                  title: Container(
                    width: SizeConfig.screenWidth / 2,
                    child: Row(
                      children: [
                        widget.filters![selectedIndex ?? 0].data![index].otherInfo!.isEmpty ?
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xffd6d6d6))
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage('https://taggd.gumlet.io/logo/multiolor-swatch.png'),
                            radius: 10,
                          ),
                        ):
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Color(0xffd6d6d6))
                          ),
                          child: CircleAvatar(
                            backgroundColor: color,
                            radius: 10,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: (widget.filters![selectedIndex ?? 0]
                                .data![index].isSelected ??
                                false)
                                ? Color(0xffcd3a62)
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Color(0xffcd3a62),
                  checkColor: Colors.white,
                );
              }
              else{
                return CheckboxListTile(
                  value: widget.filters![selectedIndex ?? 0].data![index]
                      .isSelected,
                  onChanged: (bool? value){
                    setState(() {
                      if (widget.filters![selectedIndex ?? 0].data![index]
                          .isSelected ??
                          false) {
                        log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Removing");
                        log("${widget.filters![selectedIndex ?? 0].displayName}");
                        widget.filters![selectedIndex ?? 0].data![index]
                            .isSelected = false;
                      } else {
                        log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Adding");
                        log("${widget.filters![selectedIndex ?? 0].displayName}");
                        widget.filters![selectedIndex ?? 0].data![index]
                            .isSelected = true;
                      }
                    });
                  },
                  secondary: Text(
                    value,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.grey,
                        fontStyle: FontStyle.italic),
                  ),
                  title: Container(
                    width: SizeConfig.screenWidth / 2,
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: (widget.filters![selectedIndex ?? 0]
                            .data![index].isSelected ??
                            false)
                            ? Color(0xffcd3a62)
                            : Colors.black,
                      ),
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Color(0xffcd3a62),
                  checkColor: Colors.white,
                );
              }
            },
          )
        : Container();
  }
}

class SelectedFilterData {
  String? keyData;
  String? value;
  String? type;
  String? from;
  String? to;
  SelectedFilterData({this.keyData, this.value, this.type, this.from, this.to});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["key"] = this.keyData;
    data["value"] = this.value;
    data["type"] = this.type;
    data["from"] = this.from;
    data["to"] = this.to;

    return data;
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
