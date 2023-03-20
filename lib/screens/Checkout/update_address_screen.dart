import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ouat/data/models/selectAddressModel.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import '../../size_config.dart';
import './update_address_bloc.dart';
import './update_address_state.dart';
import './update_address_event.dart';


class UpdateAddressScreen extends StatefulWidget {
  SelectAddressData? data;
  bool? pin;
  var callback;
  static const ROUTE_NAME = 'UpdateAddressScreen';
  UpdateAddressScreen({required this.data,this.pin, this.callback});

  @override
  State<UpdateAddressScreen> createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  final _formKey = GlobalKey<FormState>();


  final TextEditingController name_controller = new TextEditingController();

  final TextEditingController pincode_controller = new TextEditingController();

  final TextEditingController address_controller = new TextEditingController();

  final TextEditingController landmark_controller = new TextEditingController();

  final TextEditingController city_controller = new TextEditingController();

  final TextEditingController state_controller = new TextEditingController();

  final TextEditingController mobile_controller = new TextEditingController();

  late UpdateAddressBloc updateAddressBloc = UpdateAddressBloc(SearchInitState());

  bool valid = false;


  @override
  void initState() {
    if(widget.pin == true){
      name_controller.text = widget.data!.fullName!;
      pincode_controller.text = "";
      address_controller.text = widget.data!.address!;
      landmark_controller.text = widget.data!.landmark!;
      city_controller.text = widget.data!.city!;
      state_controller.text = widget.data!.state!;
      mobile_controller.text = widget.data!.mobile!;
    }
    else{
      name_controller.text = widget.data!.fullName!;
      pincode_controller.text = "${widget.data!.pincode}";
      address_controller.text = widget.data!.address!;
      landmark_controller.text = widget.data!.landmark!;
      city_controller.text = widget.data!.city!;
      state_controller.text = widget.data!.state!;
      mobile_controller.text = widget.data!.mobile!;
    }
  }

  updateAddressState(
      String fullname,
      int pincode,
      String address,
      String landmark,
      String mobile,
      String city,
      String state,
      int address_id){
    updateAddressBloc.add(ProgressEvent(
      fullname,
      pincode,
      address,
      landmark,
      mobile,
      city,
      state,
    address_id));
  }


  pincodeValidInitState(String pincode) async {
    updateAddressBloc.add(LoadingEvent(pincode));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double textScale = MediaQuery.of(context).textScaleFactor;
    return SafeArea(
      child: BlocProvider(
        create: (context) => updateAddressBloc,
        child: BaseBlocListener(
            bloc: updateAddressBloc,
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
                      backgroundColor: Color(0xffe45582),
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
                    msg: state.addAddressModel!.message![0].msgText!,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xffe45582),
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                widget.callback(true);
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
                bloc: updateAddressBloc,
                condition: (oldState, currentState) {
                  return !(BaseBlocBuilder.isBaseState(currentState));
                },
                builder: (BuildContext context, BaseState state) {
                  if(true){
                    return Scaffold(
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
                            'UPDATE ADDRESS',
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
                                    key: _formKey,
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
                                              cursorColor: Color(0xffe45582),
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Color(0xffe45582),
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
                                                  return 'Please enter Valid Name';
                                                }
                                                return null;
                                              },
                                              controller: pincode_controller,
                                              onEditingComplete: (){
                                                pincodeValidInitState(pincode_controller.text.toString());
                                              },
                                              autofillHints: [AutofillHints.postalCode],
                                              cursorColor: Color(0xffe45582),
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(6),
                                              ],
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Color(0xffe45582),
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
                                              cursorColor: Color(0xffe45582),
                                              maxLines: 4,
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Color(0xffe45582),
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
                                              cursorColor: Color(0xffe45582),
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Color(0xffe45582),
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
                                              cursorColor: Color(0xffe45582),
                                              enabled: false,
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Color(0xffe45582),
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
                                              cursorColor: Color(0xffe45582),
                                              enabled: false,
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Color(0xffe45582),
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
                                              cursorColor: Color(0xffe45582),
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(10),
                                              ],
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Color(0xffe45582),
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
                                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xffe45582)),
                                          ),
                                          onPressed: () {
                                            if(_formKey.currentState!.validate()){
                                              FocusManager.instance.primaryFocus?.unfocus();
                                              pincodeValidInitState(pincode_controller.text.toString());
                                              if(valid){
                                                updateAddressState(
                                                    name_controller.text.toString(),
                                                    int.parse(pincode_controller.text),
                                                    address_controller.text.toString(),
                                                    landmark_controller.text.toString(),
                                                    mobile_controller.text.toString(),
                                                    city_controller.text.toString(),
                                                    state_controller.text.toString(),
                                                    widget.data!.addressId!
                                                );
                                              }
                                            }
                                          },
                                          child: Text('Update Address'),
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
                    );
                  }
                  else{
                    return Container();
                  }
                })),
      ),
    );
  }
}
