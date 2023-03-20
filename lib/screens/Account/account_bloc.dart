import 'dart:developer';
import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/addAddressModel.dart';
import 'package:ouat/data/models/customerCreditsModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/data/prefs/PreferencesManager.dart';
import 'package:ouat/data/repo/user_repo.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends BaseBloc {
  final UserRepo userRepo = UserRepo();
  // SplashActivityBloc(userRepo) : assert(userRepo != null);

  AccountBloc(BaseState initialState) : super(AccountInitState());

  @override
  AccountState get initialState => AccountInitState();

  // SplashActivityBloc(SplashActivityState initialState) : super(initialState);
  DataRepo dataRepo = DataRepo.getInstance();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadEvent) {
      await PreferencesManager.init();
      CustomerDetail? customerDetail = dataRepo.userRepo.getSavedUser();
      log("$customerDetail");
      if (customerDetail == null) {
        yield NotAuthorisedState();
      }
      else {
        CustomerCreditsModel customerCreditsModel = await dataRepo.userRepo.getCredits(customerDetail.customerId.toString());
        yield AuthorisedState(
            name: customerDetail.firstName,
            email: customerDetail.email,
            mobile: customerDetail.mobile,
            customerCreditsModel: customerCreditsModel
        );
      }
    }

    if(event is DeleteEvent){
      yield ShowProgressLoader('Loading...');
      AddAddressModel? deleteUserModel = await dataRepo.userRepo.getDeleteUser();
      if(deleteUserModel.success ?? false || deleteUserModel.code == 200){
        yield DeleteState(deleteUserModel: deleteUserModel);
      }
      else{
        yield ErrorState("Something went Wrong");
      }
    }
  }
}
