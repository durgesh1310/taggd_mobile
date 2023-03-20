// import 'package:bloc/bloc.dart';
import 'dart:developer';
import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/addToCartModel.dart';
import 'package:ouat/data/models/addToWishListModel.dart';
import 'package:ouat/data/models/deleteWishListModel.dart';
import 'package:ouat/data/models/productDescriptionModel.dart';
import 'package:ouat/data/models/showWishListModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/data/repo/user_repo.dart';
import './wishlist_event.dart';
import './wishlist_state.dart';
import 'package:ouat/data/prefs/PreferencesManager.dart';



class WishListBloc extends BaseBloc{

  final UserRepo userRepo = UserRepo();

  WishListBloc(BaseState initialState) : super(SearchInitState());

  @override
  WishListState get initialState => SearchInitState();

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
        ShowWishListModel showWishListModel = await dataRepo.userRepo
            .getWishList();
        if (showWishListModel.success ?? false) {
          yield CompletedState(showWishListModel: showWishListModel);
        } else {
          // yield  ErrorState('We aren’t serving here yet');
          yield ErrorState("some thing went wrong");
        }
      }
    }

    if (event is SizeEvent) {
      yield ShowProgressLoader('Loading...');
      ProductDescriptionModel productDescriptionModel =
      await dataRepo.userRepo.getProductDescription(event.pid);
      if (productDescriptionModel.success ?? false) {
        yield SizeState(productDescriptionModel: productDescriptionModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is LoadingEvent) {
      yield ShowProgressLoader('Loading...');
      DeleteWishListModel deleteWishListModel = await dataRepo.userRepo.deleteWishId(event.product_id);
      if (deleteWishListModel.success ?? false) {
        yield CompletedCheckState(deleteWishListModel: deleteWishListModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }


    if (event is ProgressEvent) {
      yield ShowProgressLoader('Loading...');
      AddToWishListModel addToWishListModel = await dataRepo.userRepo.addToWishList(event.product_id);
      if (addToWishListModel.success ?? false) {
        yield CompletedAddingState(addToWishListModel: addToWishListModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is ProgressingEvent) {
      yield ShowProgressLoader('Loading...');
      AddToCartModel addToCartModel = await dataRepo.userRepo.addToCart(event.sku, event.quantity);
      if (addToCartModel.success) {
        yield CompletedCartState(addToCartModel: addToCartModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }
  }



}