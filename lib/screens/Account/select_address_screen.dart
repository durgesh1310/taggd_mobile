import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ouat/data/models/selectAddressModel.dart';
import 'package:ouat/screens/Checkout/shipping_address_screen.dart';
import 'package:ouat/screens/Checkout/update_address_screen.dart';
import '../../size_config.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import './select_address_bloc.dart';
import './select_address_state.dart';
import './select_address_event.dart';

class SelectAccountAddressScreen extends StatefulWidget {
  static const String ROUTE_NAME = "SelectAccountAddressScreen";


  @override
  State<SelectAccountAddressScreen> createState() => _SelectAccountAddressScreenState();
}

class _SelectAccountAddressScreenState extends State<SelectAccountAddressScreen> {
  late SelectAddressBloc selectAddressBloc = SelectAddressBloc(SearchInitState());
  SelectAddressModel? selectAddressModel = SelectAddressModel();
  var selectedIndex = 0;

  @override
  void initState() {
    getSelectAddressInitState();
    super.initState();
  }

  getSelectAddressInitState() async {
    selectAddressBloc.add(LoadEvent());
  }

  deleteSelectedAddressState(int address_id) async{
    selectAddressBloc.add(DeletingEvent(address_id));
  }

  setSelectedRadio(var val){
    setState(() {
      selectedIndex = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double textScale = MediaQuery.of(context).textScaleFactor;
    return BlocProvider(
      create: (context) => selectAddressBloc,
      child: BaseBlocListener(
          bloc: selectAddressBloc,
          listener: (context, state) {

            if (state is CompletedState) {
              selectAddressModel = state.selectAddressModel;

            }

            if(state is DeleteState){
              if (state.deleteAddressModel!.message!.first.msgType !=
                  'INFO') {
                final snackBar = SnackBar(
                  backgroundColor: Color(0xffcd3a62),
                  duration: Duration(seconds: 3),
                  content: Text(
                    '${state.deleteAddressModel!.message![0].msgText!}',
                    style: TextStyle(color: Colors.white),
                  ),
                  action: SnackBarAction(
                    label: 'Undo',
                    textColor: Colors.white,
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                getSelectAddressInitState();
              }
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
              bloc: selectAddressBloc,
              condition: (oldState, currentState) {
                return !(BaseBlocBuilder.isBaseState(currentState));
              },
              builder: (BuildContext context, BaseState state) {

                if (state is CompletedState && selectAddressModel!.data != null) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      centerTitle: true,
                      title: Text(
                        'Saved Address',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'RecklessNeue',
                            fontSize: textScale >1 ? 2.5*SizeConfig.textMultiplier : 2.8*SizeConfig.textMultiplier,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                    ),
                    bottomNavigationBar: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, ShippingAddressScreen.ROUTE_NAME, arguments: {
                          "callback": (value){
                            if(value != null){
                              getSelectAddressInitState();
                            }
                          }
                        });
                      },
                      child: Container(
                        height: 50,
                        width: SizeConfig.screenWidth/2,
                        color: Color(0xffcd3a62),
                        child: Center(
                          child: Text(
                            "ADD NEW ADDRESS",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    body: ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectAddressModel!.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xffcd3a62),
                                    style: BorderStyle.solid
                                ),
                                borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    value: index,
                                    groupValue: selectedIndex,
                                    onChanged: (val){
                                      setSelectedRadio(val);
                                    },
                                    title: Text(
                                      '${selectAddressModel!.data![index].fullName}',
                                      style: TextStyle(
                                          fontFamily: 'RecklessNeue',
                                          color: Colors.black,
                                          fontSize: 2*SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.bold
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    subtitle: RichText(
                                      text: TextSpan(
                                          text: '${selectAddressModel!.data![index].address}\n',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            if(selectAddressModel!.data![index].landmark != "")
                                              TextSpan(
                                                text: '${selectAddressModel!.data![index].landmark}\n',
                                              ),
                                            TextSpan(
                                              text: '${selectAddressModel!.data![index].city}, ',
                                            ),
                                            TextSpan(
                                              text: '${selectAddressModel!.data![index].state}, ',
                                            ),
                                            TextSpan(
                                              text: '${selectAddressModel!.data![index].pincode}\n',
                                            ),
                                            TextSpan(
                                              text: '${selectAddressModel!.data![index].mobile}',
                                            ),
                                          ]
                                      ),
                                    ),
                                    controlAffinity: ListTileControlAffinity.leading,
                                    selectedTileColor: Colors.grey[400],
                                    activeColor: Color(0xffcd3a62),
                                    secondary: IconButton(
                                      onPressed: (){
                                        Navigator.pushNamed(context, UpdateAddressScreen.ROUTE_NAME, arguments: {
                                          "data": selectAddressModel!.data![index],
                                          "callback": (value){
                                            if(value != null){
                                              getSelectAddressInitState();
                                            }
                                          }
                                        });
                                      },
                                      icon: SvgPicture.asset(
                                        'assets/icons/edit.svg',
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(0xffcd3a62),
                                          minimumSize: Size(
                                              SizeConfig.screenWidth,
                                              5*SizeConfig.heightMultiplier
                                          )
                                      ),
                                      onPressed: () {
                                        deleteSelectedAddressState(selectAddressModel!.data![index].addressId!);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                  fontFamily: 'RecklessNeue',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      centerTitle: true,
                      title: Text(
                        'Saved Address',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'RecklessNeue',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                    ),
                    body: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xffcd3a62),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, ShippingAddressScreen.ROUTE_NAME, arguments: {
                            "callback": (value){
                              if(value != null){
                                getSelectAddressInitState();
                              }
                            }
                          });
                        },
                        child: Text('Add New Address'),
                      ),
                    ),
                  );
                }
              })),
    );
  }
}