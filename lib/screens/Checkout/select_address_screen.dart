import 'dart:developer';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ouat/utility/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/widgets/general_dialog.dart';
import './payment_state.dart';
import './payment_bloc.dart';
import './payment_event.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ouat/data/models/checkOutModel.dart';
import 'package:ouat/screens/Checkout/shipping_address_screen.dart';
import 'package:ouat/screens/Checkout/update_address_screen.dart';
import '../../size_config.dart';

class SelectAddressScreen extends StatefulWidget {
  static const String ROUTE_NAME = "SelectAddressScreen";
  Address? address;
  var callback;
  SelectAddressScreen(this.address, this.callback);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  var selectedIndex;
  late PaymentBloc paymentBloc = PaymentBloc(SearchInitState());

  @override
  void initState() {
    if(widget.address!.addresses != null){
      for(int i = 0; i<widget.address!.addresses!.length ; i++){
        if(widget.address!.selectedAddressId != null &&
            widget.address!.selectedAddressId == widget.address!.addresses![i].addressId){
          selectedIndex = i;
          break;
        }
        else{
          selectedIndex = 0;
        }
      }
    }
    super.initState();
  }

  pincodeValidInitState(String pincode) async {
    paymentBloc.add(PincodeEvent(pincode));
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
    if(widget.address!.addresses != null){
      return BlocProvider(
        create: (context) => paymentBloc,
        child: BaseBlocListener(
            bloc: paymentBloc,
            listener: (context, state) {

              if(state is CompletedCheckState){
                if(state.pincodeValidationModel!.data == null){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Color(0xffcd3a62),
                    duration: Duration(seconds: 3),
                    content: Text(state.pincodeValidationModel!.message!.runtimeType != String
                        ? state.pincodeValidationModel!.message![0].msgText!
                        : state.pincodeValidationModel!.message!,
                      style: TextStyle(color: Colors.white),
                    ),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Colors.white,
                      onPressed: () {
                        // Some code to undo the change.
                      },
                    ),
                  ));
                  Navigator.pushNamed(context, UpdateAddressScreen.ROUTE_NAME, arguments: {
                    "data": widget.address!.addresses![selectedIndex],
                    "pin": true,
                    "callback": (value){
                      if(value != null){
                        widget.callback(widget.address!.addresses![selectedIndex].addressId, 0);
                        setState(() {
                        });
                      }
                    }
                  });
                }
                else{
                  widget.callback(widget.address!.addresses![selectedIndex].addressId, 1);
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
                bloc: paymentBloc,
                condition: (oldState, currentState) {
                  return !(BaseBlocBuilder.isBaseState(currentState));
                },
                builder: (BuildContext context, BaseState state) {
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
                        'Select Address',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'RecklessNeue',
                            fontSize: textScale >1 ? 2.5*SizeConfig.textMultiplier : 2.8*SizeConfig.textMultiplier,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                      actions: [
                        Center(
                          child: Text(
                            'Step 1 of 2',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                color: Colors.grey
                            ),
                          ),
                        ),
                      ],
                    ),
                    bottomNavigationBar: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, ShippingAddressScreen.ROUTE_NAME, arguments: {
                                "callback": (value){
                                  if(value != null){
                                    widget.callback(widget.address!.addresses![selectedIndex].addressId, 0);
                                  }
                                }
                              });
                            },
                            child: Container(
                              height: 50,
                              width: SizeConfig.screenWidth/2,
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  "NEW ADDRESS",
                                  style: TextStyle(
                                      color: Color(0xffcd3a62),
                                      fontWeight: FontWeight.bold,
                                    fontSize: textScale >1 ? 1.7*SizeConfig.textMultiplier : 2.2*SizeConfig.textMultiplier,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if(widget.address!.addresses != null){
                                pincodeValidInitState(widget.address!.addresses![selectedIndex].pincode.toString());
                              }
                              else{
                                Fluttertoast.showToast(msg: 'Please Add a Address');
                              }
                            },
                            child: Container(
                              height: 50,
                              width: SizeConfig.screenWidth/2,
                              color: Color(0xffcd3a62),
                              child: Center(
                                child: Text(
                                  "NEXT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    fontSize: textScale >1 ? 1.8*SizeConfig.textMultiplier : 2.3*SizeConfig.textMultiplier,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    body: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.address!.addresses!.length,
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
                              child: RadioListTile(
                                value: index,
                                groupValue: selectedIndex,
                                isThreeLine: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                                onChanged: (val){
                                  setSelectedRadio(val);
                                },
                                title: Text(
                                  '${widget.address!.addresses![index].fullName}',
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
                                      text: '${widget.address!.addresses![index].address}\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Inter',
                                      ),
                                      children: <TextSpan>[
                                        if(widget.address!.addresses![index].landmark != "")
                                          TextSpan(
                                            text: '${widget.address!.addresses![index].landmark}\n',
                                          ),
                                        TextSpan(
                                          text: '${widget.address!.addresses![index].city}, ',
                                        ),
                                        TextSpan(
                                          text: '${widget.address!.addresses![index].state}, ',
                                        ),
                                        TextSpan(
                                          text: '${widget.address!.addresses![index].pincode}\n',
                                        ),
                                        TextSpan(
                                          text: '${widget.address!.addresses![index].mobile}',
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
                                      "data": widget.address!.addresses![index],
                                      "callback": (value){
                                        if(value != null){
                                          widget.callback(widget.address!.addresses![selectedIndex].addressId, 0);
                                          setState(() {
                                          });
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
                            ),
                          ),
                        );
                      },
                    ),
                  );
                })),
      );
    }
    else{
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
            'Select Address',
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: 'RecklessNeue',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),
          ),
          actions: [
            Center(
              child: Text(
                'Step 1 of 2',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: Colors.grey
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffcd3a62),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, ShippingAddressScreen.ROUTE_NAME, arguments: {
                    "callback": (value){
                      if(value != null){
                        widget.callback(widget.address!.addresses![selectedIndex].addressId, 0);
                      }
                    }
                  });
                },
                child: Text('Add New Address'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffcd3a62),
                ),
                onPressed: () {
                  if(widget.address!.addresses != null){
                    widget.callback(widget.address!.addresses![selectedIndex].addressId , 1);
                  }
                  else{
                    Fluttertoast.showToast(msg: 'Please Add a Address');
                  }
                },
                child: Text('Next'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
