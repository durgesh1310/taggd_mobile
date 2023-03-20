import 'dart:convert';
import 'dart:developer';
import 'package:ouat/data/models/addAddressModel.dart';
import 'package:ouat/data/models/addToCartModel.dart';
import 'package:ouat/data/models/addToWishListModel.dart';
import 'package:ouat/data/models/cancelReasonModel.dart';
import 'package:ouat/data/models/cancelReturnItemModel.dart';
import 'package:ouat/data/models/categoryModel.dart';
import 'package:ouat/data/models/checkOutModel.dart';
import 'package:ouat/data/models/createRazorpayCustomerModel.dart';
import 'package:ouat/data/models/customerCreditsModel.dart';
import 'package:ouat/data/models/deepLinkModel.dart';
import 'package:ouat/data/models/deleteCartItemModel.dart';
import 'package:ouat/data/models/deleteWishListModel.dart';
import 'package:ouat/data/models/homeModel.dart';
import 'package:ouat/data/models/isEmailExistModel.dart';
import 'package:ouat/data/models/orderConfirmationModel.dart';
import 'package:ouat/data/models/orderDescriptionModel.dart';
import 'package:ouat/data/models/orderListingModel.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/models/orderStatusV1Model.dart';
import 'package:ouat/data/models/pincodeValidationModel.dart';
import 'package:ouat/data/models/placeOrderModel.dart';
import 'package:ouat/data/models/productDescriptionModel.dart';
import 'package:ouat/data/models/promoListModel.dart';
import 'package:ouat/data/models/promoValidModel.dart';
import 'package:ouat/data/models/recommendationModel.dart';
import 'package:ouat/data/models/searchModel.dart';
import 'package:ouat/data/models/selectAddressModel.dart';
import 'package:ouat/data/models/shippingChargesModel.dart';
import 'package:ouat/data/models/showCartModel.dart';
import 'package:ouat/data/models/showWishListModel.dart';
import 'package:ouat/data/models/sizeExchangedModel.dart';
import 'package:ouat/data/models/sizeExchangingModel.dart';
import 'package:ouat/data/models/sortBarModel.dart';
import 'package:ouat/data/models/suggestionModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/data/prefs/PreferencesManager.dart';
import 'package:ouat/data/remote/user_interface.dart';
import 'package:ouat/utility/constants.dart';

import '../models/commonBannerModel.dart';
import '../models/scratchCardsModel.dart';
import '../models/scratchCodeModel.dart';

class UserRepo {
  UserRepo();
  static final UserRepo _instance = UserRepo._internal();
  static UserRepo getInstance() => _instance;

  UserRepo._internal();

  /* Saved user after login/successfully */
  void saveUserDetails(CustomerDetail? customerDetail){
    PreferencesManager.savePref(Constants.USER, jsonEncode(customerDetail!.toJson()));
  }

  void saveDeepLinkDetails(DeepLinkModel? deepLinkModel){
    PreferencesManager.savePref(Constants.DEEPLINK, jsonEncode(deepLinkModel!.toJson()));
  }

  /*get User Info*/
  CustomerDetail? getSavedUser(){
    String? userString =
        PreferencesManager.getPrefWithDefault(Constants.USER, null);
      
    
    log(userString ?? "");
    
    if (userString != null) {
      return userModelFromJson(userString);
    }
    return null;

  }

  DeepLinkModel? getSavedDeepLink(){
    String? deepLinkString =
        PreferencesManager.getPrefWithDefault(Constants.DEEPLINK, null);

    if(deepLinkString != null){
      return deeplinkModelFromJson(deepLinkString);
    }

    return null;

  }

  deleteSavedUser(){
    PreferencesManager.savePref(Constants.USER, null);

  }

  Future<HomeModel> getHomeScreen()  {
    return UserInterFace.homePageResponse();
  }

  Future<SortBarModel> getSortBar()  {
    return UserInterFace.sortBarResponse();
  }

  Future<CategoryModel> getCategory()  {
    return UserInterFace.categoryResponse();
  }

  Future postOtp(String mob, String otpReason)  {
    return UserInterFace.sendOTPResponse(mob, otpReason);
  }

  Future checkOtp(String otp, String mob, String otpReason)  {
    return UserInterFace.checkOTPResponse(otp, mob, otpReason);
  }

  Future signUpCustomer(String name, String gender, String email, String mobno,)  {
    return UserInterFace.customerCreate(
      name,
      gender,
      email,
      mobno
    );
  }

  Future<SuggestionModel> getSuggestion(String searchKeyword)  {
    return UserInterFace.suggestionResponse(searchKeyword);
  }

  Future<SearchModel> getSearch(String query,List filterData,String sortBy, int count)  {
    return UserInterFace.searchResponse(query,filterData,sortBy,count);
  }

  Future<ProductDescriptionModel> getProductDescription(String pid)  {
    return UserInterFace.productDescriptionResponse(pid);
  }

  Future<PincodeValidationModel> getPincodeCheck(String check)  {
    return UserInterFace.pincodeCheckResponse(check);
  }

  Future<ShowCartModel> getCart()  {
    return UserInterFace.cartResponse();
  }

  Future<AddToCartModel> addToCart(String sku, String quantity)  {
    return UserInterFace.addToCartResponse(sku, quantity);
  }

  Future<DeleteCartItemModel> deleteCartSku(String sku)  {
    return UserInterFace.deleteCartResponse(sku);
  }

  Future<DeleteWishListModel> deleteWishId(int id)  {
    return UserInterFace.deleteWishListResponse(id);
  }
  Future<AddToWishListModel> addToWishList(int id)  {
    return UserInterFace.addToWishListResponse(id);
  }

  Future<ShowWishListModel> getWishList()  {
    return UserInterFace.wishListResponse();
  }

  Future<SearchModel> getPlp(String query,List filterData,String sortBy, int count)  {
    return UserInterFace.plpResponse(query,filterData,sortBy,count);
  }

  Future<SearchModel> getPlpCollection(String query,List filterData,String sortBy, int count)  {
    return UserInterFace.plpCollectionResponse(query, filterData, sortBy, count);
  }

  Future<PromoListModel> getPromo()  {
    return UserInterFace.promoResponse();
  }

  Future<PromoValidModel> checkPromo(List<ShowShoppingCartData>? list, double cart_value, String promo)  {
    return UserInterFace.validPromoResponse(list, cart_value, promo);
  }

  Future<OrderListingModel> getOrderList(int pageNo)  {
    return UserInterFace.orderListingResponse(pageNo);
  }

  Future<OrderDescriptionModel> getOrderDetail(String? order_number)  {
    return UserInterFace.orderDetailResponse(order_number);
  }

  Future<SelectAddressModel> getSelectAddress()  {
    return UserInterFace.selectAddressResponse();
  }

  Future<AddAddressModel> addAddress(
      String fullname,
      int pincode,
      String address,
      String landmark,
      String mobile,
      String city,
      String state,
      )  {
    return UserInterFace.addAddressResponse(
      fullname,
      pincode,
      address,
      landmark,
      mobile,
      city,
      state,
    );
  }

  Future<AddAddressModel> updateAddress(
      String fullname,
      int pincode,
      String address,
      String landmark,
      String mobile,
      String city,
      String state,
      int address_id
      )  {
    return UserInterFace.updateAddressResponse(
      fullname,
      pincode,
      address,
      landmark,
      mobile,
      city,
      state,
      address_id
    );
  }

  Future<CancelReasonModel> getCancelReason(String orderNumber)  {
    return UserInterFace.cancelReasonResponse(orderNumber);
  }

  Future<CancelReturnItemModel> postCancelItem(int order_item_id, String sku, int reason_id, String refund_type)  {
    return UserInterFace.cancelItemResponse(order_item_id, sku, reason_id, refund_type);
  }

  Future<CancelReturnItemModel> postReturnItem(int order_item_id, String sku, int reason_id, String refund_type)  {
    return UserInterFace.returnItemResponse(order_item_id, sku, reason_id, refund_type);
  }

  Future<SizeExchangedModel> postExchangeItem(int order_item_id, String sku, int reason_id)  {
    return UserInterFace.exchangeItemResponse(order_item_id, sku, reason_id);
  }

  Future<CancelReasonModel> getReturnReason(String orderNumber)  {
    return UserInterFace.returnReasonResponse(orderNumber);
  }

  Future<CancelReasonModel> getExchangeReason(String orderNumber)  {
    return UserInterFace.exchangeReasonResponse(orderNumber);
  }

  Future<AddToCartModel> getMergeCart()  {
    return UserInterFace.mergeCart();
  }

  Future<HomeModel> getSpecialPage(String id)  {
    return UserInterFace.specialPageResponse(id);
  }

  Future<CheckOutModel> getCheckOut(String promo_code){
    return UserInterFace.checkOutResponse(promo_code);
  }

  Future<CheckOutModel> refreshCheckOut(int address_id, String promo_code, List credits){
    return UserInterFace.refreshResponse(address_id, promo_code, credits);
  }

  Future<PlaceOrderModel> postPlaceOrder(String paymentMode){
    return UserInterFace.placeOrderResponse(paymentMode);
  }




  Future<OrderStatusV1Model> putOrderStatus(
      int order_id,
      String payment_status,
      String payment_id,
      String razorpay_order_id,
      String signature){
    return UserInterFace.orderStatusResponse(order_id, payment_status, payment_id, razorpay_order_id, signature);
  }

  Future<OrderConfirmationModel> postOrderConfirm(int order_id){
    return UserInterFace.orderConfirmResponse(order_id);
  }

  Future<OrderStatusModel> getItemsNumber(){
    return UserInterFace.itemsNumberResponse();
  }

  Future<ShippingChargesModel> getShippingCharges(String cart_value){
    return UserInterFace.shippingChargesResponse(cart_value);
  }

  Future<CustomerCreditsModel> getCredits(String customer_id){
    return UserInterFace.creditsResponse(customer_id);
  }

  Future<AddToCartModel> getfirstCredits(){
    return UserInterFace.firstResponse();
  }

  Future<AddAddressModel> getDeleteAddress(int address_id){
    return UserInterFace.deleteAddressResponse(address_id);
  }

  Future<RecommendationModel> getRecommendations(String product_id){
    return UserInterFace.recommendResponse(product_id);
  }

  Future<AddToCartModel> postProfileUpdate(String mobile, String email){
    return UserInterFace.profileUpdateResponse(mobile, email);
  }

  Future<IsEmailExistModel> getEmailExistence(String email){
    return UserInterFace.isEmailExistResponse(email);
  }

  Future<SizeExchangingModel> postSizeExchange(int order_item_id){
    return UserInterFace.sizeExchangeResponse(order_item_id);
  }

  Future<AddAddressModel> getDeleteUser(){
    return UserInterFace.deleteResponse();
  }

  Future<CreateRazorpayCustomerModel> postCreateRazorpayCustomerExchange(String name, String mobile, String email){
    return UserInterFace.createRazorpayCustomerResponse(name, mobile, email);
  }

  Future<CommonBannerModel> getCommonBanner(){
    return UserInterFace.bannerResponse();
  }

  Future<ScratchCardsModel> getScratchCards(){
    return UserInterFace.scratchCardsResponse();
  }

  Future<ScratchCodeModel> getScratchCodeCards(){
    return UserInterFace.scratchCodeResponse();
  }

}
