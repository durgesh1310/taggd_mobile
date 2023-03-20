import 'dart:developer';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/suggestionModel.dart';
import 'package:ouat/screens/Search/search_screen.dart';
import 'package:ouat/size_config.dart';
import 'package:ouat/utility/colors.dart';


class SearchListItem extends StatefulWidget {
  final Function(bool)? onTapSearch;
  final ValueChanged<bool>? callback;
  String? screen;
  SearchListItem({this.onTapSearch, this.callback, this.screen});

  @override
  _SearchListItemState createState() => _SearchListItemState();
}

class _SearchListItemState extends State<SearchListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  FocusNode inputNode = FocusNode();


  Animation? _containerHeight;
  bool keyboardFocus = false;

  late Animation _listOpacity;

  List<SugestionData>? _placePredictions = [];

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _containerHeight = Tween<double>(begin: 60, end: 360).animate(
      CurvedAnimation(
        curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
        parent: _animationController,
      ),
    );
    _listOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
        parent: _animationController,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: SizeConfig.screenWidth,
            padding: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                bottom: 10.0),
            color: Colors.white,
            child: Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: TextFormField(
                           focusNode: inputNode,
                          autofocus: false,
                        style: TextStyle(color: Colors.black),
                        cursorColor: Color(0xffcd3a62),
                        onFieldSubmitted: (value) {
                          log("$value");
                          widget.screen == "Home"
                              ? Navigator.pushNamed(
                                  context, SearchScreen.ROUTE_NAME, arguments: {
                                  "query": value,
                                  "id": "",
                                  "collection": false,
                                  "callback":widget.callback
                                }).then((value) {
                                  widget.onTapSearch!(false);
                                })
                              : Navigator.popAndPushNamed(
                                  context, SearchScreen.ROUTE_NAME, arguments: {
                                  "query": value,
                                  "id": "",
                                  "collection": false,
                                   "callback":widget.callback
                                }).then((value) {
                                  widget.onTapSearch!(false);
                                });
                        },
                        onChanged: (value) async {
                          if (value.isNotEmpty) {
                            SuggestionModel suggestionModel =
                                await DataRepo.getInstance()
                                    .userRepo
                                    .getSuggestion(value);
                            if (suggestionModel.data!.length >= 1) {
                              await _animationController.animateTo(0.5);
                              if (mounted) {
                                setState(() {
                                  _placePredictions = suggestionModel.data;
                                });
                              }
                              await _animationController.forward();
                            } else {
                              if (mounted) {
                                setState(() {
                                  _placePredictions = [];
                                });
                              }
                              await _animationController.reverse();
                            }
                          } else {
                            setState(
                              () {
                                _placePredictions = [];
                              },
                            );
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: DefaultTextStyle(
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.grey),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: AnimatedTextKit(
                                  isRepeatingAnimation: false,
                                  onTap: (){
                                    FocusScope.of(context).requestFocus(inputNode);
                                  },
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      'Earings',
                                      speed: Duration(milliseconds: 100),
                                    ),
                                    TyperAnimatedText('Kurtas',
                                        speed: Duration(milliseconds: 100)),
                                    TyperAnimatedText('One Piece',
                                        speed: Duration(milliseconds: 100)),
                                    TyperAnimatedText('Lehangas',
                                        speed: Duration(milliseconds: 100)),
                                    TyperAnimatedText('Search....',
                                        speed: Duration(milliseconds: 100)),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                          onTap: () {
                            widget.onTapSearch!(false);
                          },
                          child: SvgPicture.asset(
                              'assets/icons/clear.svg',
                              height: 25,
                              width: 25
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                return Container(
                  width: MediaQuery.of(context).size.height,
                  decoration: _containerDecoration(),
                  child: Opacity(
                      opacity: _listOpacity.value,
                      child: (_placePredictions!.length > 0)
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: _placePredictions!.length,
                              itemBuilder: (context, index) {
                                return _placeOption(_placePredictions![index]);
                              })
                          : Container()),
                );
              }),
        ],
      ),
    );
  }

  Widget _placeOption(SugestionData? prediction) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      onPressed: () {
        Navigator.pushNamed(context, SearchScreen.ROUTE_NAME, arguments: {
          "query": prediction!.suggest ?? "",
          "id": "",
          "collection": false,
          "callback": widget.callback
        }).then((value) {
          widget.onTapSearch!(false);
        });
      },
      child: ListTile(
        title: Text('${prediction!.suggest}'),
        leading: prediction.thumbNail == null
            ? Container(
                width: 10,
              )
            : Image.network('${prediction.thumbNail}?w=50&h=50'),
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
    );
  }
}
