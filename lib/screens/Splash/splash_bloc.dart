import 'dart:developer';
import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/categoryModel.dart';
import 'package:ouat/data/models/homeModel.dart';
import 'package:ouat/data/models/orderListingModel.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/models/sortBarModel.dart';
import 'package:ouat/data/prefs/PreferencesManager.dart';
import 'package:ouat/data/repo/user_repo.dart';
import 'package:ouat/screens/Splash/splash_event.dart';
import 'package:ouat/screens/Splash/splash_state.dart';
import 'package:ouat/utility/constants.dart';


class SplashActivityBloc extends BaseBloc {
  final UserRepo userRepo = UserRepo();
  SplashActivityBloc(BaseState initialState) : super(SplashInitState());

  @override
  SplashActivityState get initialState => UnInitialized();
  DataRepo dataRepo = DataRepo.getInstance();

  @override
  Stream<SplashActivityState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadAssetsEvent) {
      try {
        await PreferencesManager.init();
        bool data =
            PreferencesManager.getPref(Constants.SIGNUPACTIVITY) ?? false;
        log("$data");
        HomeModel homeModel = await dataRepo.userRepo.getHomeScreen();
        SortBarModel sortBarModel = await dataRepo.userRepo.getSortBar();
        OrderStatusModel? orderStatusModel =
            await dataRepo.userRepo.getItemsNumber();
        if ((homeModel.success ?? false) && (sortBarModel.success ?? false)) {
          yield DoneState(
              homeModel: homeModel,
              sortBarModel: sortBarModel,
              orderStatusModel: orderStatusModel,
              boolisSignUpScreen: data);
        } else if (homeModel.message!.first.msgType == "NoInternet") {
          yield ErrorState("No Internet");
        } else {
          yield ErrorState(homeModel.message!.first.msgText!);
        }
      } catch (e) {
        log("$e");
      }
    }

    if(event is LoadCategoryEvent){
      CategoryModel categoryModel = await dataRepo.userRepo.getCategory();
      dataRepo.categoryManager.saveCategory(categoryModel);
    }

    if(event is LoadCheckLoginEvent){
      try {
        await PreferencesManager.init();
        OrderListingModel orderListingModel = await dataRepo.userRepo.getOrderList(1);
        if (orderListingModel.success == false &&
            orderListingModel.message![0].msgText == "Unauthorized" &&
            orderListingModel.code == "500"
        ) {
          PreferencesManager.clean();
          await PreferencesManager.init();
          PreferencesManager.savePref(Constants.SIGNUPACTIVITY, true);
        }
      } catch (e) {
        log("$e");
      }
    }
  }
}
