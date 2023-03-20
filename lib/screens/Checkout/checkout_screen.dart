import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ouat/data/models/checkOutModel.dart';
import 'package:ouat/screens/Checkout/checkout_bloc.dart';
import 'package:ouat/screens/Checkout/payment_screen.dart';
import 'package:ouat/screens/Checkout/select_address_screen.dart';
import 'package:ouat/screens/Checkout/shipping_address_screen.dart';
import 'package:ouat/screens/Login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './checkout_state.dart';
import './checkout_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/widgets/general_dialog.dart';



class CheckOutScreen extends StatefulWidget {
  static const ROUTE_NAME = 'CheckOutScreen';
  String promocode;
  CheckOutScreen({required this.promocode});
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  late CheckOutBloc checkOutBloc = CheckOutBloc(SearchInitState());
  CheckOutModel? checkOutModel = CheckOutModel();
  int _currentPage = 0;
  int selectedAddress = 0;
  PageController _pageController = PageController();
  var callBackFunction;
  bool justAddedOne = false;
  bool cod = false;
  final TextEditingController guest_controller = new TextEditingController();
  final _guestCheckoutKey = GlobalKey<FormState>();
  late SharedPreferences userData;
  var mobile;
  var email;
  var name;

  @override
  void initState() {
    // categoryBloc = BlocProvider.of<CategoryBloc>(context);
    initSharedPref();
    getInitState();
    super.initState();
  }

  _onChanged(int index){
    setState(() {
      _currentPage = index;
    });
  }

  saveInitState(String mob, String mail) async {
    checkOutBloc.add(GuestEvent(mob , mail));
  }

  getInitState() async {
    checkOutBloc.add(LoadEvent("${widget.promocode}"));
  }

  saveCustomerInRazorpay() async{
    checkOutBloc.add(CreateRazorpayCustomerEvent(
        name,
        mobile,
        email
    ));
  }

  initSharedPref() async{
    userData = await SharedPreferences.getInstance();
    mobile = (userData.getString('mobile') ?? '');
    email = (userData.getString('email') ?? '');
    name = (userData.getString('name') ?? '');
  }

  pincodeValidInitState(String pincode) async {
    checkOutBloc.add(PincodeEvent(pincode));
  }

  refreshState(int address_id, String promo_code, List credits) async{
    checkOutBloc.add(LoadingEvent(address_id, promo_code, credits));
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
                padding:
                EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: BlocProvider(
                  create: (context) => checkOutBloc,
                  child: BaseBlocListener(
                      bloc: checkOutBloc,
                      listener: (context, state) {

                        if(state is CompletedCheckState){
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


                        if(state is GuestState){
                          if(state.profileUpdateModel!.message!.first.msgType == 'INFO'){
                            getInitState();
                          }
                          else{
                            Fluttertoast.showToast(
                                msg: state.profileUpdateModel!.message![0].msgText!,
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Color(0xffcd3a62),
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                        }

                        if (state is CompletedState) {
                          checkOutModel = state.checkOutModel;
                          if(checkOutModel!.data!.address != null && checkOutModel!.data!.address!.addresses != null){
                            for(int i = 0; i<checkOutModel!.data!.address!.addresses!.length ; i++){
                              if(checkOutModel!.data!.address!.selectedAddressId != null &&
                                  checkOutModel!.data!.address!.selectedAddressId == checkOutModel!.data!.address!.addresses![i].addressId){
                                selectedAddress = i;
                                break;
                              }
                              else{
                                selectedAddress = 0;
                              }
                            }
                          }
                          else{
                            Navigator.pushNamed(context, ShippingAddressScreen.ROUTE_NAME, arguments: {
                              "callback": (value){
                                if(value != null){
                                  justAddedOne = true;
                                  getInitState();
                                }
                              }
                            });
                          }
                          if(checkOutModel!.data!.pgCustomerData == null){
                            saveCustomerInRazorpay();
                          }
                          //pincodeValidInitState(checkOutModel!.data!.address!.addresses![selectedAddress].pincode.toString());
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
                          bloc: checkOutBloc,
                          condition: (oldState, currentState) {
                            return !(BaseBlocBuilder.isBaseState(currentState));
                          },
                          builder: (BuildContext context, BaseState state) {

                            if (checkOutModel!.data != null) {
                              return PageView.builder(
                                  scrollDirection: Axis.horizontal,
                                  controller: _pageController,
                                  itemCount: 2,
                                  onPageChanged: _onChanged,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, int index){
                                    if(justAddedOne){
                                      return getBody(1, checkOutModel!.data);
                                    }
                                    else{
                                      return getBody(index, checkOutModel!.data);
                                    }
                                  }
                              );
                            } else {
                              return Container();
                            }
                          })),
                ))
        )
    );
  }

  Widget getBody(int? localindex, CheckOutData? data){
    switch (localindex) {
      case 0: return SelectAddressScreen(data!.address, (value, next){
        if(value != null){
          if(next == 1){
            _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          }
          refreshState(value, "${widget.promocode}", []);
        }
      });
      case 1: return PaymentScreen(checkOutModel!, (value){
        if(value != null){
          refreshState(checkOutModel!.data!.address!.selectedAddressId!, "${widget.promocode}", value);
        }
      });


      default: return Container();
    }
  }

  Future _enterGuest(BuildContext ctx, int type) async{
    await showModalBottomSheet(context: ctx,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(icon: Icon(Icons.clear),
                          onPressed: (){
                            Navigator.of(context).pop();
                          })
                    ],
                  ),*/
              Padding(
                padding: EdgeInsets.all(8),
                child: Form(
                  key: _guestCheckoutKey,
                  child: TextFormField(
                    validator: type == 10 ? (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Mobile Number';
                      }
                      else if(!RegExp(r'(^[0-9]{10}$)').hasMatch("$value")){
                        return 'Please enter Valid Mobile Number';
                      }
                      return null;
                    } : (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Your Email';
                      }
                      else if(!value.contains(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))){
                        return 'Please enter a valid Email';
                      }
                      return null;
                    },
                    controller: guest_controller,
                    cursorColor: Color(0xffcd3a62),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                        labelText: type == 10 ? "Mobile No." : "Email"
                    ),
                    keyboardType: type == 10 ? TextInputType.number : TextInputType.emailAddress,
                  ),
                ),
              ),
              CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl: type == 10 ? "https://taggd.gumlet.io/logo/apps/mobile.png" :"https://taggd.gumlet.io/logo/apps/email.png",
                placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      valueColor: AlwaysStoppedAnimation(Color(0xffcd3a62)),
                    )),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xffcd3a62)),
                ),
                onPressed: () {
                  if(_guestCheckoutKey.currentState!.validate()){
                    if(guest_controller.text.toString().length == 10){
                      userData.setString('mobile', guest_controller.text.toString());
                      saveInitState(guest_controller.text.toString(), email.toString());
                    }
                    else{
                      userData.setString('email', guest_controller.text.toString());
                      saveInitState(mobile.toString(), guest_controller.text.toString());
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          );
        });
  }
}