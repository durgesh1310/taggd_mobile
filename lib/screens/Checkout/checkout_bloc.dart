// import 'package:bloc/bloc.dart';
import 'dart:developer';

import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/addToCartModel.dart';
import 'package:ouat/data/models/createRazorpayCustomerModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/data/prefs/PreferencesManager.dart';
import 'package:ouat/data/models/checkOutModel.dart';
import 'package:ouat/data/models/pincodeValidationModel.dart';
import 'package:ouat/data/models/placeOrderModel.dart';
import 'package:ouat/data/repo/user_repo.dart';
import './checkout_event.dart';
import './checkout_state.dart';

class CheckOutBloc extends BaseBloc{

  final UserRepo userRepo = UserRepo();

  CheckOutBloc(BaseState initialState) : super(SearchInitState());

  @override
  CheckOutState get initialState => SearchInitState();

  DataRepo dataRepo = DataRepo.getInstance();


  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadEvent) {
      yield ShowProgressLoader('Loading...');
      await PreferencesManager.init();
      CustomerDetail? customerDetail = dataRepo.userRepo.getSavedUser();
      log("$customerDetail");
      if (customerDetail == null) {
        yield NotAuthorisedState();
      } else {
        CheckOutModel checkOutModel = await dataRepo.userRepo.getCheckOut(
            event.promoCode);
        if (checkOutModel.success ?? false) {
          yield CompletedState(checkOutModel: checkOutModel);
        } else {
          // yield  ErrorState('We aren’t serving here yet');
          yield ErrorState("some thing went wrong");
        }
      }
    }

    if (event is LoadingEvent) {
      yield ShowProgressLoader('Loading...');
      CheckOutModel checkOutModel = await dataRepo.userRepo.refreshCheckOut(
          event.address_id, event.promo_code, event.applied_credits);
      if (checkOutModel.success ?? false) {
        yield CompletedState(checkOutModel: checkOutModel);
      }
      else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is PincodeEvent) {
      PincodeValidationModel pincodeValidationModel =
      await dataRepo.userRepo.getPincodeCheck(event.pincode);
      if (pincodeValidationModel.success ?? false) {
        yield CompletedCheckState(
            pincodeValidationModel: pincodeValidationModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is GuestEvent) {
      yield ShowProgressLoader('Loading...');
      AddToCartModel profileUpdateModel = await dataRepo.userRepo.postProfileUpdate(event.mobile, event.email);
      if (profileUpdateModel.success) {
        yield GuestState(profileUpdateModel: profileUpdateModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if(event is CreateRazorpayCustomerEvent){
      CreateRazorpayCustomerModel createRazorpayCustomerModel = await dataRepo.userRepo.postCreateRazorpayCustomerExchange(
          event.name,
          event.mobile,
          event.email);
      if(createRazorpayCustomerModel.success ?? false){
        yield CreateRazorpayCustomerState(createRazorpayCustomerModel: createRazorpayCustomerModel);
      }
      else{
        //yield ErrorState("Something Went Wrong");
      }
    }

  }

}