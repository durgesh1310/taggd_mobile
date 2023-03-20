import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/screens/Checkout/shipping_address_bloc.dart';
import '../../size_config.dart';
import './shipping_address_bloc.dart';
import './shipping_address_state.dart';
import './shipping_address_event.dart';

class ShippingAddressScreen extends StatelessWidget {
  static const String ROUTE_NAME = "ShippingAddressScreen";
  var callback;
  ShippingAddressScreen({this.callback});

  final _shipKey = GlobalKey<FormState>();
  final TextEditingController name_controller = new TextEditingController();
  final TextEditingController pincode_controller = new TextEditingController();
  final TextEditingController address_controller = new TextEditingController();
  final TextEditingController landmark_controller = new TextEditingController();
  final TextEditingController city_controller = new TextEditingController();
  final TextEditingController state_controller = new TextEditingController();
  final TextEditingController mobile_controller = new TextEditingController();
  late ShippingAddressBloc shippingAddressBloc = ShippingAddressBloc(SearchInitState());
  bool valid = false;


  addAddressState(
      String fullname,
      int pincode,
      String address,
      String landmark,
      String mobile,
      String city,
      String state,){
    shippingAddressBloc.add(ProgressEvent(fullname,
      pincode,
      address,
      landmark,
      mobile,
      city,
      state,));
  }



  pincodeValidInitState(String pincode) async {
    shippingAddressBloc.add(LoadingEvent(pincode));
  }

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => shippingAddressBloc,
      child: BaseBlocListener(
          bloc: shippingAddressBloc,
          listener: (context, state) {

            if(state is CompletedCheckState){
              if(state.pincodeValidationModel!.data == null){
                Fluttertoast.showToast(
                    msg: state.pincodeValidationModel!.message!.runtimeType != String
                        ? state.pincodeValidationModel!.message![0].msgText!
                        : state.pincodeValidationModel!.message!,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xffcd3a62),
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
              else{
                state_controller.text = state.pincodeValidationModel!.data!.state!;
                city_controller.text = state.pincodeValidationModel!.data!.city!;
                valid = true;
              }
            }


            if (state is CompletedAddingState) {
              Fluttertoast.showToast
                (
                  msg: state.addAddressModel!.message![0].msgText!
              );
              callback(true);
              Navigator.pop(context);
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
              bloc: shippingAddressBloc,
              condition: (oldState, currentState) {
                return !(BaseBlocBuilder.isBaseState(currentState));
              },
              builder: (BuildContext context, BaseState state) {
                if(true){
                  return SafeArea(
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                        leading: IconButton(
                          icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black
                          ),
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.pop(context);
                          },
                        ),
                        centerTitle: false,
                        title: Text(
                          'SHIPPING ADDRESS',
                          style: TextStyle(
                              fontFamily: 'RecklessNeue',
                              fontSize: textScale >1 ? 2.5*SizeConfig.textMultiplier : 2*SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        )
                      ),
                      body: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Center(
                                  child: Form(
                                    key: _shipKey,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            elevation: 7,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Your name must be at least 2 characters.';
                                                }
                                                else if(!RegExp(r'[a-zA-Z]').hasMatch(value)){
                                                  return 'Your name must be at least 2 characters.';
                                                }
                                                return null;
                                              },
                                              controller: name_controller,
                                              autofillHints: [AutofillHints.name],
                                              cursorColor: Color(0xffcd3a62),
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Color(0xffcd3a62),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black)
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.grey)
                                                  ),
                                                  labelText: "Name"
                                              ),
                                              keyboardType: TextInputType.name,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            elevation: 7,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter your Pincode';
                                                }
                                                else if(!RegExp("^[1-9]{1}[0-9]{2}\\s{0,1}[0-9]{3}\$").hasMatch("$value")){
                                                  return 'Please enter Valid Pincode';
                                                }
                                                return null;
                                              },
                                              controller: pincode_controller,
                                              onEditingComplete: (){
                                                pincodeValidInitState(pincode_controller.text.toString());
                                              },
                                              autofillHints: [AutofillHints.postalCode],
                                              cursorColor: Color(0xffcd3a62),
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(6),
                                                ],
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Color(0xffcd3a62),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black)
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.grey)
                                                  ),
                                                  labelText: "Pincode"
                                              ),
                                              keyboardType: TextInputType.number,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            elevation: 7,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter your Address';
                                                }
                                                return null;
                                              },
                                              onTap: (){
                                                pincodeValidInitState(pincode_controller.text.toString());
                                              },
                                              controller: address_controller,
                                              autofillHints: [AutofillHints.fullStreetAddress],
                                              cursorColor: Color(0xffcd3a62),
                                              maxLines: 4,
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Color(0xffcd3a62),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black)
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.grey)
                                                  ),
                                                  labelText: "Address"
                                              ),
                                              keyboardType: TextInputType.streetAddress,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            elevation: 7,
                                            child: TextFormField(
                                              controller: landmark_controller,
                                              cursorColor: Color(0xffcd3a62),
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Color(0xffcd3a62),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black)
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.grey)
                                                  ),
                                                  labelText: "Landmark"
                                              ),
                                              keyboardType: TextInputType.text,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            elevation: 7,
                                            child: TextFormField(
                                              controller: city_controller,
                                              //autofillHints: [AutofillHints.addressCity],
                                              cursorColor: Color(0xffcd3a62),
                                              enabled: false,
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Color(0xffcd3a62),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black)
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.grey)
                                                  ),
                                                  labelText: "City"
                                              ),
                                              keyboardType: TextInputType.text,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            elevation: 7,
                                            child: TextFormField(
                                              controller: state_controller,
                                              //autofillHints: [AutofillHints.addressState],
                                              cursorColor: Color(0xffcd3a62),
                                              enabled: false,
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Color(0xffcd3a62),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black)
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.grey)
                                                  ),
                                                  labelText: "State"
                                              ),
                                              keyboardType: TextInputType.text,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            elevation: 7,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Your mobile number must be 10 digit.';
                                                }
                                                else if(!RegExp(r'(^[0-9]{10}$)').hasMatch("$value")){
                                                  return 'Your mobile number must be 10 digit.';
                                                }
                                                return null;
                                              },
                                              controller: mobile_controller,
                                              autofillHints: [AutofillHints.telephoneNumberDevice],
                                              cursorColor: Color(0xffcd3a62),
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(10),
                                              ],
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Color(0xffcd3a62),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.black)
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.grey)
                                                  ),
                                                  labelText: "Mobile No."
                                              ),
                                              keyboardType: TextInputType.number,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xffcd3a62)),
                                          ),
                                          onPressed: () {
                                            if(_shipKey.currentState!.validate()){
                                              FocusManager.instance.primaryFocus?.unfocus();
                                              pincodeValidInitState(pincode_controller.text.toString());
                                              if(valid){
                                                addAddressState(
                                                    name_controller.text.toString(),
                                                    int.parse(pincode_controller.text),
                                                    address_controller.text.toString(),
                                                    landmark_controller.text.toString(),
                                                    mobile_controller.text.toString(),
                                                    city_controller.text.toString(),
                                                    state_controller.text.toString());
                                                _shipKey.currentState!.reset();
                                              }
                                            }
                                          },
                                          child: Text(
                                              'Add Address',
                                            style: TextStyle(
                                              fontFamily: 'RecklessNeue',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                else{
                  return Container();
                }
              })),
    );
  }
}
