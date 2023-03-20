import 'dart:developer';
import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/addToCartModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/data/prefs/PreferencesManager.dart';
import 'package:ouat/data/repo/user_repo.dart';
import './custom_otp_sheet_state.dart';
import './custom_otp_sheet_event.dart';

class ValidateOTPBloc extends BaseBloc {
  final UserRepo userRepo = UserRepo();

  ValidateOTPBloc(BaseState initialState) : super(ValidateSearchInitState());

  @override
  ValidateOTPState get initialState => ValidateSearchInitState();

  DataRepo dataRepo = DataRepo.getInstance();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is OtpVerifyEvent) {
      yield ShowProgressLoader('Loading...');
      print(event.otp);
      print(event.phoneNo);
      ValidateOTPModel validateOTPModel = await dataRepo.userRepo
          .checkOtp(event.otp, event.phoneNo, event.otpReason);
      if (validateOTPModel.success) {
        if (event.otpReason == "LOGIN") {
          await PreferencesManager.init();
          CustomerDetail? customerDetail = CustomerDetail();
          customerDetail = validateOTPModel.data!.customerDetail;
          if (customerDetail != null) {
            customerDetail.token = validateOTPModel.data!.token ?? "";
            DataRepo.getInstance()
                .userRepo
                .saveUserDetails(validateOTPModel.data!.customerDetail);
            var customerModel = DataRepo.getInstance().userRepo.getSavedUser();
            log("$customerModel");
          }
        }
        yield CompletedValidateState(validateOTPModel: validateOTPModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is MergeEvent) {
      AddToCartModel addToMergeCartModel =
          await dataRepo.userRepo.getMergeCart();
      if (addToMergeCartModel.success) {
        yield CompletedMergeState(addToMergeCartModel: addToMergeCartModel);
      } else {
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is FirstEvent) {
      yield ShowProgressLoader('Loading...');
      AddToCartModel addToCartModel = await dataRepo.userRepo.getfirstCredits();
      if (addToCartModel.success) {
        PreferencesManager.prefs!.setBool('login', false);
        yield FirstLoginCreditsState(addToCartModel: addToCartModel);
        //  yield OnceLoggedState();
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }
  }
}
