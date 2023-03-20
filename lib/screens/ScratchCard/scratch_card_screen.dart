import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ouat/data/models/scratchCardsModel.dart';
import 'package:ouat/screens/ScratchCard/scratch_card_bloc.dart';
import 'package:scratcher/widgets.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/scratchCodeModel.dart';
import '../../size_config.dart';
import '../../widgets/general_dialog.dart';
import '../Login/login_screen.dart';
import '../Splash/splash_screen.dart';
import './scratch_card_event.dart';
import './scratch_card_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';

class ScratchCardScreen extends StatefulWidget {
  static const String ROUTE_NAME = "ScratchCard";

  @override
  State<ScratchCardScreen> createState() => _ScratchCardScreenState();
}

class _ScratchCardScreenState extends State<ScratchCardScreen> {
  late ScratchCardBloc scratchCardBloc = ScratchCardBloc(SearchInitState());
  ScratchCardsModel scratchCardsModel = ScratchCardsModel();
  ScratchCodeModel scratchCodeModel = ScratchCodeModel();
  final scratchKey = GlobalKey<ScratcherState>();

  @override
  void initState() {
    getInitState();
    super.initState();
  }

  getCodeState() async {
    scratchCardBloc.add(LoadScratchCodeEvent());
  }

  getInitState() async {
    scratchCardBloc.add(LoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: InkWell(
          onTap: (){
            Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
          },
          child: Container(
            height: 50,
            width: SizeConfig.screenWidth/2,
            color: Color(0xffcd3a62),
            child: Center(
              child: Text(
                "SHOP NOW",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        body: BlocProvider(
          create: (context) => scratchCardBloc,
          child: BaseBlocListener(
              bloc: scratchCardBloc,
              listener: (context, state) {
                if (state is NotAuthorisedState) {
                  Navigator.pushNamed(context, LoginScreen.ROUTE_NAME,
                      arguments: {
                        "callback": (value) {
                          if (value != null) {

                          }
                        }
                      }).then((value) => getInitState());
                }

                if (state is CompletedState) {
                  scratchCardsModel = state.scratchCardsModel!;
                }

                if (state is CompletedCodeState) {
                  scratchCodeModel = state.scratchCodeModel!;
                }

                if(state is ErrorState){
                  GeneralDialog.show(
                    context,
                    title: 'Error',
                    message: state.message,
                    closeOnAction: true,
                    positiveButtonLabel: 'OK',
                    onPositiveTap: () {
                      // Navigator.of(context).pop();
                      //      Navigator.of(context)
                      //          .pushNamed(AddressScreen.ROUTE_NAME, arguments: {
                      //        'selectMode': true,
                      //        'homeMode': true,
                      //      }).then((value) {
                      //        setState(() {
                      //          Address address = value;
                      //          _bloc.add(DefaultAddress(addressId: address.id));
                      //        });
                      //      });
                    },
                  );
                }

              },
              child: BaseBlocBuilder(
                  bloc: scratchCardBloc,
                  condition: (oldState, currentState) {
                    return !(BaseBlocBuilder.isBaseState(currentState));
                  },
                  builder: (BuildContext context, BaseState state) {

                    if (scratchCardsModel.data != null) {
                      return SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                height: 120,
                                imageUrl: 'https://taggd.gumlet.io/prod-banner/scratch-top-icon.png',
                                maxWidthDiskCache: 520,
                                errorWidget: (context, url, error) => Container(),
                              ),
                              Text(
                                  'Scratch Card',
                                style: TextStyle(
                                  fontSize: textScale > 1 ? 20 : 30,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                              Text(
                                'Chance to win exciting offers & deals',
                                style: TextStyle(
                                    fontSize: textScale > 1 ? 10 : 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xffcd3a62),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              if(scratchCardsModel.data!.activeCard != 0)
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: (scratchCardsModel.data!.activeCard! - scratchCardsModel.data!.customerPromo!.length),
                                    itemBuilder: (context, index){
                                      return Scratcher(
                                        key: scratchKey,
                                        color: Colors.white,
                                        image: Image.network(
                                          'https://taggd.gumlet.io/prod-banner/scratch-card-cover.png',
                                          fit: BoxFit.fill,
                                        ),
                                        accuracy: ScratchAccuracy.low,
                                        brushSize: 50,
                                        threshold: 30,
                                        enabled: true,
                                        onThreshold: (){
                                          getCodeState();
                                          scratchKey.currentState!.reveal(duration: Duration(milliseconds: 1));
                                        },
                                        child: Container(
                                            height: 250,
                                            color: Colors.white,
                                            width: SizeConfig.screenWidth,
                                            alignment: Alignment.center,
                                            child: scratchCodeModel.data != null ?
                                            scratchCodeModel.data!.customerPromo![0].code != 'NOCODE' ?
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Yaay!! You\'ve Won',
                                                  style: TextStyle(
                                                    fontSize: textScale > 1 ? 20 : 30,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff0CC862),
                                                  ),
                                                ),
                                                Text(
                                                  scratchCodeModel.data != null ? '${scratchCodeModel.data!.customerPromo![0].title}' : '',
                                                  style: TextStyle(
                                                    fontSize: textScale > 1 ? 15 : 25,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                DottedBorder(
                                                  color: Color(0xff0CC862),
                                                  padding: EdgeInsets.fromLTRB(10, 6, 6, 6),
                                                  child: Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          scratchCodeModel.data != null ? '${scratchCodeModel.data!.customerPromo![0].code}' : '',
                                                          style: TextStyle(
                                                            fontSize: textScale > 1 ? 20 : 30,
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.w600,
                                                            color: Color(0xff0CC862),
                                                          ),
                                                        ),
                                                        IconButton(
                                                            onPressed: () async {
                                                              await Clipboard.setData(ClipboardData(text: "${scratchCodeModel.data!.customerPromo![0].code}"));
                                                              Fluttertoast.showToast(
                                                                  msg: 'Copied to Clipboard',
                                                                  toastLength: Toast.LENGTH_LONG,
                                                                  gravity: ToastGravity.CENTER,
                                                                  timeInSecForIosWeb: 1,
                                                                  backgroundColor: Color(0xffe45582),
                                                                  textColor: Colors.white,
                                                                  fontSize: 16.0
                                                              );
                                                            },
                                                            icon: Icon(
                                                              Icons.copy,
                                                              color: Colors.black,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ) :
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Better Luck',
                                                  style: TextStyle(
                                                    fontSize: textScale > 1 ? 20 : 30,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xff0CC862),
                                                  ),
                                                ),
                                                Text(
                                                  'Next Time',
                                                  style: TextStyle(
                                                    fontSize: textScale > 1 ? 20 : 30,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xff0CC862),
                                                  ),
                                                ),
                                              ],
                                            ) :
                                            Container()
                                        ),
                                      );
                                    }
                                ),
                              if (scratchCardsModel.data!.customerPromo!.length != 0)
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: scratchCardsModel.data!.customerPromo!.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index){
                                      return Card(
                                        child: Container(
                                          width: double.maxFinite,
                                          height: 250,
                                          child: scratchCardsModel.data!.customerPromo![index].code != 'NOCODE' ?
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                'Yaay!! You\'ve Won',
                                                style: TextStyle(
                                                  fontSize: textScale > 1 ? 20 : 30,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff0CC862),
                                                ),
                                              ),
                                              Text(
                                                scratchCardsModel.data != null ? '${scratchCardsModel.data!.customerPromo![0].title}' : '',
                                                style: TextStyle(
                                                  fontSize: textScale > 1 ? 15 : 25,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              DottedBorder(
                                                color: Color(0xff0CC862),
                                                padding: EdgeInsets.fromLTRB(10, 6, 6, 6),
                                                child: Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        '${scratchCardsModel.data!.customerPromo![index].code}',
                                                        style: TextStyle(
                                                          fontSize: textScale > 1 ? 20 : 30,
                                                          fontFamily: 'Inter',
                                                          fontWeight: FontWeight.w600,
                                                          color: Color(0xff0CC862),
                                                        ),
                                                      ),
                                                      IconButton(
                                                          onPressed: () async {
                                                            await Clipboard.setData(ClipboardData(text: "${scratchCardsModel.data!.customerPromo![0].code}"));
                                                            Fluttertoast.showToast(
                                                                msg: 'Copied to Clipboard',
                                                                toastLength: Toast.LENGTH_LONG,
                                                                gravity: ToastGravity.CENTER,
                                                                timeInSecForIosWeb: 1,
                                                                backgroundColor: Color(0xffe45582),
                                                                textColor: Colors.white,
                                                                fontSize: 16.0
                                                            );
                                                          },
                                                          icon: Icon(
                                                            Icons.copy,
                                                            color: Colors.black,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ) :
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Better Luck',
                                                style: TextStyle(
                                                  fontSize: textScale > 1 ? 20 : 30,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff0CC862),
                                                ),
                                              ),
                                              Text(
                                                'Next Time',
                                                style: TextStyle(
                                                  fontSize: textScale > 1 ? 20 : 30,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff0CC862),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Material(child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        enabled: true,
                        child: GridView.count(
                          primary: false,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(2),
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.5,
                          crossAxisCount: 1,
                          children: <Widget>[
                            Container(
                              color: Color(0xFFDBFFE9),
                            ),
                          ],
                        ),
                      )
                      );
                    }
                  })),
        ),
      ),
    );
  }
}
