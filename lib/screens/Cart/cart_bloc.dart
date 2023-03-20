// import 'package:bloc/bloc.dart';
import 'dart:developer';

import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/addToWishListModel.dart';
import 'package:ouat/data/models/deleteCartItemModel.dart';
import 'package:ouat/data/models/addToCartModel.dart';
import 'package:ouat/data/models/isEmailExistModel.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/models/promoValidModel.dart';
import 'package:ouat/data/models/shippingChargesModel.dart';
import 'package:ouat/data/models/showCartModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/data/prefs/PreferencesManager.dart';
import 'package:ouat/data/repo/user_repo.dart';
import '../../data/models/commonBannerModel.dart';
import './cart_event.dart';
import './cart_state.dart';


class CartBloc extends BaseBloc{

  final UserRepo userRepo = UserRepo();

  CartBloc(BaseState initialState) : super(SearchCartInitState());

  @override
  CartState get initialState => SearchCartInitState();

  DataRepo dataRepo = DataRepo.getInstance();


  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadCartEvent) {
      //yield ShowProgressLoader('Loading...');
      ShowCartModel showCartModel = await dataRepo.userRepo.getCart();
      if (showCartModel.success ?? false || showCartModel.code == 200)  {
        yield CompletedCartState(showCartModel: showCartModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorCartState("some thing went wrong");
      }
    }

    if(event is LoadDeliveryEvent){
      ShippingChargesModel shippingChargesModel = await dataRepo.userRepo.getShippingCharges(event.cart_value);
      if(shippingChargesModel.success ?? false || shippingChargesModel.code == 200){
        yield CompletedDeliverState(shippingChargesModel: shippingChargesModel);
      }
      else{
        yield ErrorDeliverState("some thing went wrong");
      }
    }
    

    if (event is LoadingEvent) {
      //yield ShowProgressLoader('Loading...');
      DeleteCartItemModel deleteCartItemModel = await dataRepo.userRepo.deleteCartSku(event.sku);
      if (deleteCartItemModel.success || deleteCartItemModel == 200) {
        yield CompletedCheckState(deleteCartItemModel: deleteCartItemModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorCartState("some thing went wrong");
      }
    }


    if (event is CountingEvent) {
      //yield ShowProgressLoader('Loading...');
      OrderStatusModel orderStatusModel = await dataRepo.userRepo.getItemsNumber();
      if (orderStatusModel.success ?? false) {
        yield CountingState(orderStatusModel: orderStatusModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorCartState("some thing went wrong");
      }
    }

    if (event is ProgressEvent) {
      //yield ShowProgressLoader('Loading...');
      AddToCartModel addToCartModel = await dataRepo.userRepo.addToCart(event.sku, event.quantity);
      if (addToCartModel.success) {
        yield CompletedAddingState(addToCartModel: addToCartModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorCartState("some thing went wrong");
      }
    }

    if (event is WishlistingEvent) {
      //yield ShowProgressLoader('Loading...');
      await PreferencesManager.init();
      CustomerDetail? customerDetail = dataRepo.userRepo.getSavedUser();
      log("$customerDetail");
      if (customerDetail == null) {
        //yield NotAuthorisedState();
      }
      else{
        AddToWishListModel addToWishListModel = await dataRepo.userRepo.addToWishList(event.product_id);
        if (addToWishListModel.success ?? false) {
          yield WishlistingState(addToWishListModel: addToWishListModel);
        } else {
          // yield  ErrorState('We aren’t serving here yet');
          yield ErrorCartState("some thing went wrong");
        }
      }
    }

    if (event is GuestEvent) {
      yield ShowProgressLoader('Loading...');
      AddToCartModel profileUpdateModel = await dataRepo.userRepo.postProfileUpdate(event.mobile, event.email);
      if (profileUpdateModel.success) {
        yield GuestState(profileUpdateModel: profileUpdateModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorCartState("some thing went wrong");
      }
    }

    if (event is IsEmailEvent) {
      yield ShowProgressLoader('Loading...');
      IsEmailExistModel isEmailExistModel = await dataRepo.userRepo.getEmailExistence(event.email);
      if (isEmailExistModel.success) {
        yield IsEmailState(isEmailExistModel: isEmailExistModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorCartState("some thing went wrong");
      }
    }

    if(event is BannerEvent){
      CommonBannerModel commonBannerModel = await dataRepo.userRepo.getCommonBanner();
      if (commonBannerModel.success ?? false) {
        yield BannerState(commonBannerModel: commonBannerModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorBannerState();
      }
    }


  }



}