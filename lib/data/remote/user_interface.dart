import 'dart:convert';
import 'dart:developer';
import 'package:ouat/data/models/cancelReasonModel.dart';
import 'package:ouat/data/models/cancelReturnItemModel.dart';
import 'package:ouat/data/models/checkOutModel.dart';
import 'package:ouat/data/models/commonBannerModel.dart';
import 'package:ouat/data/models/createRazorpayCustomerModel.dart';
import 'package:ouat/data/models/customerCreditsModel.dart';
import 'package:ouat/data/models/isEmailExistModel.dart';
import 'package:ouat/data/models/message.dart';
import 'package:ouat/data/models/orderConfirmationModel.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/models/orderStatusV1Model.dart';
import 'package:ouat/data/models/placeOrderModel.dart';
import 'package:ouat/data/models/recommendationModel.dart';
import 'package:ouat/data/models/scratchCardsModel.dart';
import 'package:ouat/data/models/shippingChargesModel.dart';
import 'package:ouat/data/models/sizeExchangedModel.dart';
import 'package:ouat/data/models/sizeExchangingModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:ouat/data/models/addAddressModel.dart';
import 'package:ouat/data/models/addToCartModel.dart';
import 'package:ouat/data/models/addToWishListModel.dart';
import 'package:ouat/data/models/categoryModel.dart';
import 'package:ouat/data/models/deleteCartItemModel.dart';
import 'package:ouat/data/models/deleteWishListModel.dart';
import 'package:ouat/data/models/homeModel.dart';
import 'package:ouat/data/models/orderDescriptionModel.dart';
import 'package:ouat/data/models/orderListingModel.dart';
import 'package:ouat/data/models/pincodeValidationModel.dart';
import 'package:ouat/data/models/productDescriptionModel.dart';
import 'package:ouat/data/models/promoListModel.dart';
import 'package:ouat/data/models/promoValidModel.dart';
import 'package:ouat/data/models/searchModel.dart';
import 'package:ouat/data/models/selectAddressModel.dart';
import 'package:ouat/data/models/showCartModel.dart';
import 'package:ouat/data/models/showWishListModel.dart';
import 'package:ouat/data/models/signUpModel.dart';
import 'package:ouat/data/models/sortBarModel.dart';
import 'package:ouat/data/models/sendOTPModel.dart';
import 'package:ouat/data/models/suggestionModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/data/remote/api_client.dart';

import '../models/scratchCodeModel.dart';

class UserInterFace {
  static Dio dio = Dio();
  static Future<HomeModel> homePageResponse() async {
    try {
      var response = await ApiClient.getClient()!.get("homepage-service/");

      log(jsonEncode(response.data));

      HomeModel homeModel = HomeModel.fromJson(response.data);
      // print(jsonEncode(response.data));
      return homeModel;
    } on DioError catch (e) {
      log("$e");
      return HomeModel(success: false, message: [
        Message(msgType: "NoInternet", msgText: "No Internet Connection")
      ]);
    } catch (e) {
      log(e.toString());
      return HomeModel(success: false,message: [Message(msgType: "Something Went Wrong", msgText: "Something went wrong")]);
    }
  }

  static Future<SortBarModel> sortBarResponse() async {
    try {
      var response =
          await ApiClient.getClient()!.get("homepage-service/sort-bar");

      print(jsonEncode(response.data));

      SortBarModel sortBarModel = SortBarModel.fromJson(response.data);
      // print(jsonEncode(response.data));
      return sortBarModel;
    } catch (e) {
      if (e is DioError) {}
      print(e);
      return SortBarModel(success: false, data: [], code: '');
    }
  }

  static Future<CategoryModel> categoryResponse() async {
    try {
      var response =
          await ApiClient.getClient()!.get("homepage-service/category-tree");

      print(jsonEncode(response.data));

      CategoryModel categoryModel = CategoryModel.fromJson(response.data);
      // print(categoryModel.success);
      return categoryModel;
    } catch (e) {
      print(e);
      return CategoryModel(
        success: false,
        code: '',
      );
    }
  }

  static Future sendOTPResponse(String mob, String otpReason) async {
    try {
      var response = await ApiClient.getClient()!.post(
          "customer-service/v1/send-otp/",
          data: {"signin_id": "$mob", "otp_reason": "$otpReason"});

      print(jsonEncode(response.data));
      SendOTPModel sendOTPModel = SendOTPModel.fromJson(response.data);
      // print(categoryModel.success);
      return sendOTPModel;
    } catch (e) {
      print(e);
      return SendOTPModel(
        success: false,
        code: '',
      );
    }
  }

  static Future checkOTPResponse(String otp, String mob, otpReason) async {
    try {
      var response = await ApiClient.getClient()!
          .post("customer-service/validate-otp/", data: {
        "signin_id": "$mob",
        "otp_reason": "$otpReason",
        "otp": "$otp"
      });

      log(jsonEncode(response.data));
      ValidateOTPModel validateOTPModel =
          ValidateOTPModel.fromJson(response.data);
      // print(categoryModel.success);
      return validateOTPModel;
    } catch (e) {
      print(e);
      return ValidateOTPModel(
        success: false,
        code: '',
      );
    }
  }

  static Future customerCreate(
      String name, String gender, String email, String mobno) async {
    try {
      String firstName = "", lastName = "";
      if (name.contains(' ')) {
        firstName = name.substring(0, name.indexOf(' '));
        lastName = name.substring(name.indexOf(' ') + 1, name.length);
      } else {
        firstName = name;
        lastName = '';
      }
      log(firstName);
      log(lastName);
      var response = await ApiClient.getClient()!
          .post("customer-service/customers", data: {
        "first_name": "$firstName",
        "last_name": "$lastName",
        "gender": "$gender",
        "mobile": "$mobno",
        "email_id": "$email",
        "source": "",
        "medium": "",
        "campaign": ""
      });

      print(jsonEncode(response.data));
      SignUpModel signUpModel = SignUpModel.fromJson(response.data);
      // print(categoryModel.success);
      return signUpModel;
    } catch (e) {
      print(e);
      return SignUpModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<SuggestionModel> suggestionResponse(
      String searchKeyword) async {
    try {
      var response = await ApiClient.getClient()!
          .get("suggestionandsearch-service/auto-suggest/${searchKeyword}");

      print(jsonEncode(response.data));

      SuggestionModel suggestionModel = SuggestionModel.fromJson(response.data);
      // print(jsonEncode(response.data));
      return suggestionModel;
    } catch (e) {
      if (e is DioError) {}
      print(e);
      return SuggestionModel(success: false, data: [], code: '');
    }
  }

  static Future<SearchModel> searchResponse(
      String query, List filterdata, String sortBy, int count) async {
    try {
      Map data = {
        "query": "$query",
        "from": count,
        "filters": filterdata,
        "sort_by": {"sort_by": "$sortBy"}
      };
      log(data.toString());
      var response = await ApiClient.getClient()!
          .post("suggestionandsearch-service/search-plp/$query", data: {
        "query": "$query",
        "from": count,
        "filters": filterdata,
        "sort_by": {"sort_by": "$sortBy"}
      });
      log(jsonEncode(response.data));
      SearchModel searchModel = SearchModel.fromJson(response.data);
      // print(categoryModel.success);
      return searchModel;
    } catch (e) {
      print(e);
      return SearchModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<ProductDescriptionModel> productDescriptionResponse(
      String pid) async {
    try {
      var response =
          await ApiClient.getClient()!.get("plp-pdp-service/ouat/product/$pid");

      log(jsonEncode(response.data));
      ProductDescriptionModel productDescriptionModel =
          ProductDescriptionModel.fromJson(response.data);
      // print(categoryModel.success);
      return productDescriptionModel;
    } catch (e) {
      print(e);
      return ProductDescriptionModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<PincodeValidationModel> pincodeCheckResponse(
      String check) async {
    try {
      var response = await ApiClient.getClient()!
          .get("plp-pdp-service/ouat/pincode?pincode=${check}");

      print(jsonEncode(response.data));

      PincodeValidationModel pincodeValidationModel =
          PincodeValidationModel.fromJson(response.data);
      // print(jsonEncode(response.data));
      return pincodeValidationModel;
    } catch (e) {
      if (e is DioError) {}
      print(e);
      return PincodeValidationModel(
        success: false,
      );
    }
  }

  static Future<ShowCartModel> cartResponse() async {
    try {
      var response = await ApiClient.getClient()!
          .get("cart-service/show-shopping-cart-detail");

      print(jsonEncode(response.data));

      ShowCartModel showCartModel = ShowCartModel.fromJson(response.data);
      // print(categoryModel.success);
      return showCartModel;
    } catch (e) {
      print(e);
      return ShowCartModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<AddToCartModel> addToCartResponse(
      String sku, String quantity) async {
    try {
      var response =
          await ApiClient.getClient()!.post("cart-service/add-to-cart", data: {
        "location": {"name": "", "longitude": "", "latitude": ""},
        "sku": "$sku",
        "quantity": "$quantity",
        "utm_source": "",
        "utm_campaign ": "",
        "utm_medium": ""
      });

      print(jsonEncode(response.data));
      AddToCartModel addToCartModel = AddToCartModel.fromJson(response.data);
      // print(categoryModel.success);
      return addToCartModel;
    } catch (e) {
      print(e);
      return AddToCartModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<DeleteCartItemModel> deleteCartResponse(String sku) async {
    try {
      var response = await ApiClient.getClient()!
          .post("cart-service/delete-cart-item", data: {"sku": "$sku"});

      print(jsonEncode(response.data));
      DeleteCartItemModel deleteCartItemModel =
          DeleteCartItemModel.fromJson(response.data);
      // print(categoryModel.success);
      return deleteCartItemModel;
    } catch (e) {
      print(e);
      return DeleteCartItemModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<DeleteWishListModel> deleteWishListResponse(int id) async {
    try {
      var response =
          await ApiClient.getClient()!.delete("wishlist-service/wishlist/$id");

      print(jsonEncode(response.data));
      DeleteWishListModel deleteWishListModel =
          DeleteWishListModel.fromJson(response.data);
      // print(categoryModel.success);
      return deleteWishListModel;
    } catch (e) {
      print(e);
      return DeleteWishListModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<AddToWishListModel> addToWishListResponse(int id) async {
    try {
      var response =
          await ApiClient.getClient()!.post("wishlist-service/wishlist", data: {
        "product_id": id,
        "from_price": 100,
        "to_price": 120,
        "source": "PDP",
        "source_id": 2,
        "platform": "WEB",
        "utm_campaign": "",
        "utm_medium": "",
        "utm_source": ""
      });

      print(jsonEncode(response.data));
      AddToWishListModel addToWishListModel =
          AddToWishListModel.fromJson(response.data);
      // print(categoryModel.success);
      return addToWishListModel;
    } catch (e) {
      print(e);
      return AddToWishListModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<ShowWishListModel> wishListResponse() async {
    try {
      var response =
          await ApiClient.getClient()!.get("wishlist-service/wishlist");

      print(jsonEncode(response.data));

      ShowWishListModel showWishListModel =
          ShowWishListModel.fromJson(response.data);
      // print(categoryModel.success);
      return showWishListModel;
    } catch (e) {
      print(e);
      return ShowWishListModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<SearchModel> plpResponse(
      String query, List filterdata, String sortBy, int count) async {
    try {
      Map data = {
        "query": "$query",
        "from": count,
        "filters": filterdata,
        "sort_by": {"sort_by": "$sortBy"}
      };
      log(data.toString());
      var response = await ApiClient.getClient()!
          .post("plp-pdp-service/$query/plp", data: {
        "query": "$query",
        "from": count,
        "filters": filterdata,
        "sort_by": {"sort_by": "$sortBy"}
      });

      log(jsonEncode(response.data));
      SearchModel searchModel = SearchModel.fromJson(response.data);
      // print(categoryModel.success);
      return searchModel;
    } catch (e) {
      print(e);
      return SearchModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<SearchModel> plpCollectionResponse(
      String query, List filterdata, String sortBy, int count) async {
    try {
      Map data = {
        "query": "$query",
        "from": count,
        "filters": filterdata,
        "sort_by": {"sort_by": "$sortBy"}
      };
      log(data.toString());
      var response = await ApiClient.getClient()!
          .post("plp-pdp-service/collection/$query/plp", data: {
        "query": "$query",
        "from": count,
        "filters": filterdata,
        "sort_by": {"sort_by": "$sortBy"}
      });

      log(jsonEncode(response.data));
      SearchModel searchModel = SearchModel.fromJson(response.data);
      // print(categoryModel.success);
      return searchModel;
    } catch (e) {
      print(e);
      return SearchModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<PromoListModel> promoResponse() async {
    try {
      var response = await ApiClient.getClient()!
          .get("promotion-service/internal/active-Promo");

      print(jsonEncode(response.data));

      PromoListModel promoListModel = PromoListModel.fromJson(response.data);
      // print(categoryModel.success);
      return promoListModel;
    } catch (e) {
      print(e);
      return PromoListModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<PromoValidModel> validPromoResponse(
      List<ShowShoppingCartData>? list, double cart_value, String promo) async {
    try {
      var params = <Map>[];
      for (int i = 0; i < list!.length; i++) {
        params.add({
          "sku": list[i].sku,
          "quantity": list[i].quantity,
          "retail_price": list[i].retailPrice,
          "category": list[i].category,
          "sub_Category": list[i].subCategory,
          "product_type": list[i].productType,
          "plp_id": list[i].plpId,
          "p_id": list[i].productId
        });
      }
      print(params);
      var data = Map<String, dynamic>();
      data.putIfAbsent("promocode", () => "$promo");
      data.putIfAbsent("payment_mode", () => "ALL");
      data.putIfAbsent("platform", () => null);
      data.putIfAbsent("cart_value", () => "$cart_value");
      data.putIfAbsent("cart_item_list", () => params);
      print(jsonEncode(data));
      var response = await ApiClient.getClient()!
          .post("promotion-service/apply-promocode", data: jsonEncode(data));

      log(jsonEncode(data));
      PromoValidModel promoValidModel = PromoValidModel.fromJson(response.data);
      // print(categoryModel.success);
      return promoValidModel;
    } catch (e) {
      print(e);
      return PromoValidModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<OrderListingModel> orderListingResponse(int pageNo) async {
    try {
      var response = await ApiClient.getClient()!
          .get("customer-order-service/my-orders/$pageNo");

      print(jsonEncode(response.data));

      OrderListingModel orderListingModel =
          OrderListingModel.fromJson(response.data);
      // print(categoryModel.success);
      return orderListingModel;
    } catch (e) {
      print(e);
      return OrderListingModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<OrderDescriptionModel> orderDetailResponse(
      String? order_number) async {
    try {
      var response = await ApiClient.getClient()!.post(
          "customer-order-service/order-detail",
          data: {"order_number": "$order_number"});

      log(jsonEncode(response.data));
      OrderDescriptionModel orderDescriptionModel =
          OrderDescriptionModel.fromJson(response.data);
      // print(categoryModel.success);
      return orderDescriptionModel;
    } catch (e) {
      print(e);
      return OrderDescriptionModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<SelectAddressModel> selectAddressResponse() async {
    try {
      SharedPreferences userData = await SharedPreferences.getInstance();
      int customer_id = userData.getInt('customer_id')!;
      var response =
      await ApiClient.getClient()!.get("customer-service/customers/$customer_id/address");

      log(jsonEncode(response.data));

      SelectAddressModel selectAddressModel =
          SelectAddressModel.fromJson(response.data);
      // print(categoryModel.success);
      return selectAddressModel;
    } catch (e) {
      print(e);
      return SelectAddressModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<AddAddressModel> addAddressResponse(
    String fullname,
    int pincode,
    String address,
    String landmark,
    String mobile,
    String city,
    String state,
  ) async {
    try {
      var response = await ApiClient.getClient()!
          .post("customer-service/customers/add-address", data: {
        "full_name": "$fullname",
        "pincode": pincode,
        "address": "$address",
        "landmark": "$landmark",
        "mobile": "$mobile",
        "city": "$city",
        "state": "$state"
      });

      print(jsonEncode(response.data));
      AddAddressModel addAddressModel = AddAddressModel.fromJson(response.data);
      // print(categoryModel.success);
      return addAddressModel;
    } catch (e) {
      print(e);
      return AddAddressModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<AddAddressModel> updateAddressResponse(
      String fullname,
      int pincode,
      String address,
      String landmark,
      String mobile,
      String city,
      String state,
      int address_id) async {
    try {
      SharedPreferences userData = await SharedPreferences.getInstance();
      int customer_id = userData.getInt('customer_id')!;
      var response = await ApiClient.getClient()!
          .post("customer-service/customers/update-address", data: {
        "customer_id": customer_id,
        "full_name": "$fullname",
        "pincode": pincode,
        "address": "$address",
        "landmark": "$landmark",
        "mobile": "$mobile",
        "city": "$city",
        "state": "$state",
        "address_id": address_id
      });

      print(jsonEncode(response.data));
      AddAddressModel addAddressModel = AddAddressModel.fromJson(response.data);
      // print(categoryModel.success);
      return addAddressModel;
    } catch (e) {
      print(e);
      return AddAddressModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<CancelReasonModel> cancelReasonResponse(String orderNumber) async {
    try {
      var response =
          await ApiClient.getClient()!.get("order-service/cancel/v1/reason/${orderNumber}");

      log(jsonEncode(response.data));

      CancelReasonModel cancelReasonModel =
          CancelReasonModel.fromJson(response.data);
      // print(categoryModel.success);
      return cancelReasonModel;
    } catch (e) {
      print(e);
      return CancelReasonModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<CancelReasonModel> returnReasonResponse(String orderNumber) async {
    try {
      var response =
          await ApiClient.getClient()!.get("order-service/return/v1/reason/${orderNumber}");

      print(jsonEncode(response.data));

      CancelReasonModel cancelReasonModel =
      CancelReasonModel.fromJson(response.data);
      // print(categoryModel.success);
      return cancelReasonModel;
    } catch (e) {
      print(e);
      return CancelReasonModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<CancelReasonModel> exchangeReasonResponse(String orderNumber) async {
    try {
      var response =
          await ApiClient.getClient()!.get("order-service/exchange/v1/reason/${orderNumber}");

      print(jsonEncode(response.data));

      CancelReasonModel cancelReasonModel =
      CancelReasonModel.fromJson(response.data);
      // print(categoryModel.success);
      return cancelReasonModel;
    } catch (e) {
      print(e);
      return CancelReasonModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<AddToCartModel> mergeCart() async {
    try {
      var response =
          await ApiClient.getClient()!.get("cart-service/merge-cart");

      print(jsonEncode(response.data));
      AddToCartModel addToCartModel = AddToCartModel.fromJson(response.data);
      log(jsonEncode(response.data));
      return addToCartModel;
    } catch (e) {
      print(e);
      return AddToCartModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<CancelReturnItemModel> cancelItemResponse(
      int order_item_id, String sku, int reason_id, String refund_type) async {
    try {
      var response = await ApiClient.getClient()!
          .post("order-service/cancel/process", data: {
        "order_item_id": order_item_id,
        "sku": "$sku",
        "refund_type": "$refund_type",
        "reason_id": reason_id
      });

      log(jsonEncode(response.data));
      CancelReturnItemModel cancelReturnItemModel =
          CancelReturnItemModel.fromJson(response.data);
      // print(categoryModel.success);
      return cancelReturnItemModel;
    } catch (e) {
      print(e);
      return CancelReturnItemModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<CancelReturnItemModel> returnItemResponse(
      int order_item_id, String sku, int reason_id, String refund_type) async {
    try {
      var response = await ApiClient.getClient()!
          .post("order-service/return/process", data: {
        "order_item_id": order_item_id,
        "sku": "$sku",
        "refund_type": "$refund_type",
        "reason_id": reason_id
      });

      print(jsonEncode(response.data));
      CancelReturnItemModel cancelReturnItemModel =
          CancelReturnItemModel.fromJson(response.data);
      // print(categoryModel.success);
      return cancelReturnItemModel;
    } catch (e) {
      print(e);
      return CancelReturnItemModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<SizeExchangedModel> exchangeItemResponse(
      int order_item_id, String sku, int reason_id) async {
    try {
      var response = await ApiClient.getClient()!
          .post("order-service/exchange/v2/process", data: {
        "order_item_id": order_item_id,
        "sku": "$sku",
        "reason_id": reason_id
      });

      print(jsonEncode(response.data));
      SizeExchangedModel sizeExchangedModel =
      SizeExchangedModel.fromJson(response.data);
      // print(categoryModel.success);
      return sizeExchangedModel;
    } catch (e) {
      print(e);
      return SizeExchangedModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<HomeModel> specialPageResponse(String id) async {
    try {
      var response =
          await ApiClient.getClient()!.get("homepage-service/page/$id");

      log(jsonEncode(response.data));
      HomeModel homeModel = HomeModel.fromJson(response.data);
      // print(categoryModel.success);
      return homeModel;
    } catch (e) {
      print(e);
      return HomeModel(success: false);
    }
  }

  static Future<CheckOutModel> checkOutResponse(String promo_code) async {
    var response;
    try {
      if (promo_code == "") {
        response = await ApiClient.getClient()!.get("checkout-service/proceed");
      } else {
        response = await ApiClient.getClient()!
            .get("checkout-service/proceed?promoCode=\'$promo_code\'");
      }

      //print(jsonEncode(response.data));
      log(jsonEncode(response.data));
      CheckOutModel checkOutModel = CheckOutModel.fromJson(response.data);
      // print(categoryModel.success);
      return checkOutModel;
    } catch (e) {
      print(e);
      return CheckOutModel(success: false);
    }
  }

  static Future<CheckOutModel> refreshResponse(
      int address_id, String promo_code, List credits) async {
    try {
      var params = [];
      for (int i = 0; i < credits.length; i++) {
        params.add(credits[i]);
      }
      print(params);
      var data = Map<String, dynamic>();
      data.putIfAbsent("address_id", () => address_id);
      data.putIfAbsent("promo_code", () => "$promo_code");
      data.putIfAbsent("applied_credits", () => params);
      print(jsonEncode(data));
      var response = await ApiClient.getClient()!
          .post("checkout-service/do-refresh", data: jsonEncode(data));

      log(jsonEncode(response.data));
      CheckOutModel checkOutModel = CheckOutModel.fromJson(response.data);
      // print(categoryModel.success);
      return checkOutModel;
    } catch (e) {
      print(e);
      return CheckOutModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<OrderStatusV1Model> orderStatusResponse(
      int order_id,
      String payment_status,
      String payment_id,
      String razorpay_order_id,
      String signature) async {
    try {
      var response = await ApiClient.getClient()!.put(
          "checkout-service/v1/status?order_id=$order_id&payment_status=$payment_status",
          data: {
            "razorpay_payment_id" : "$payment_id",
            "razorpay_order_id" : "$razorpay_order_id",
            "razorpay_signature" : "$signature"
          });

      log(jsonEncode(response.data));
      OrderStatusV1Model orderStatusV1Model =
      OrderStatusV1Model.fromJson(response.data);
      // print(categoryModel.success);
      return orderStatusV1Model;
    } catch (e) {
      print(e);
      return OrderStatusV1Model();
    }
  }

  static Future<PlaceOrderModel> placeOrderResponse(String paymentMode) async {
    try {
      var response = await ApiClient.getClient()!.post(
          "checkout-service/do-refresh-2",
          data: {"paymentMode": "$paymentMode"});

      print(jsonEncode(response.data));
      PlaceOrderModel placeOrderModel = PlaceOrderModel.fromJson(response.data);
      // print(categoryModel.success);
      return placeOrderModel;
    } catch (e) {
      print(e);
      return PlaceOrderModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<OrderConfirmationModel> orderConfirmResponse(
      int order_id) async {
    try {
      var response = await ApiClient.getClient()!.post(
          "customer-order-service/order-confirmation",
          data: {"order_id": order_id});

      print(jsonEncode(response.data));
      OrderConfirmationModel orderConfirmationModel =
          OrderConfirmationModel.fromJson(response.data);
      // print(categoryModel.success);
      return orderConfirmationModel;
    } catch (e) {
      print(e);
      return OrderConfirmationModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<ShippingChargesModel> shippingChargesResponse(String cart_value) async {
    try {
      var response =
          await ApiClient.getClient()!.get("cart-service/v1/shipping-charges/$cart_value");

      log(jsonEncode(response.data));
      ShippingChargesModel shippingChargesModel =
          ShippingChargesModel.fromJson(response.data);
      // print(categoryModel.success);
      return shippingChargesModel;
    } catch (e) {
      print(e);
      return ShippingChargesModel(success: false);
    }
  }

  static Future<OrderStatusModel> itemsNumberResponse() async {
    try {
      var response = await ApiClient.getClient()!.get("cart-service/cart-item");

      print(jsonEncode(response.data));
      OrderStatusModel orderStatusModel =
          OrderStatusModel.fromJson(response.data);
      // print(categoryModel.success);
      return orderStatusModel;
    } catch (e) {
      return OrderStatusModel(success: false);
    }
  }

  static Future<CustomerCreditsModel> creditsResponse(
      String customer_id) async {
    try {
      var response = await ApiClient.getClient()!
          .get("customer-service/customers/credit/$customer_id");

      log(jsonEncode(response.data));
      CustomerCreditsModel customerCreditsModel =
          CustomerCreditsModel.fromJson(response.data);
      // print(categoryModel.success);
      return customerCreditsModel;
    } catch (e) {
      print(e);
      return CustomerCreditsModel(success: false);
    }
  }

  static Future<AddToCartModel> firstResponse() async {
    try {
      var response = await ApiClient.getClient()!
          .get("customer-service/customers/first-install");

      print(jsonEncode(response.data));
      AddToCartModel firstCreditsModel = AddToCartModel.fromJson(response.data);
      // print(categoryModel.success);
      return firstCreditsModel;
    } catch (e) {
      print(e);
      return AddToCartModel(success: false);
    }
  }

  static Future<AddAddressModel> deleteAddressResponse(int address_id) async {
    try {
      var response = await ApiClient.getClient()!
          .delete("customer-service/customers/delete-address/$address_id");

      log(jsonEncode(response.data));
      AddAddressModel addAddressModel = AddAddressModel.fromJson(response.data);
      // print(categoryModel.success);
      return addAddressModel;
    } catch (e) {
      print(e);
      return AddAddressModel(success: false);
    }
  }

  static Future<RecommendationModel> recommendResponse(
      String product_id) async {
    try {
      var response = await ApiClient.getClient()!
          .get("suggestionandsearch-service/search-plp/recommend/$product_id");

      log(jsonEncode(response.data));
      RecommendationModel recommendationModel =
          RecommendationModel.fromJson(response.data);
      // print(categoryModel.success);
      return recommendationModel;
    } catch (e) {
      print(e);
      return RecommendationModel();
    }
  }

  static Future<AddToCartModel> profileUpdateResponse(
      String mobile, String email) async {
    try {
      var response = await ApiClient.getClient()!.post(
          "customer-service/customers/add-address-guest",
          data: {"full_name": "", "mobile": "$mobile", "email": "$email"});

      print(jsonEncode(response.data));
      AddToCartModel profileUpdateModel =
          AddToCartModel.fromJson(response.data);
      // print(categoryModel.success);
      return profileUpdateModel;
    } catch (e) {
      print(e);
      return AddToCartModel(
        success: false,
        code: '',
      );
    }
  }

  static Future<IsEmailExistModel> isEmailExistResponse(
      String email) async {
    try {
      var response = await ApiClient.getClient()!
          .get("customer-service/customers/email/$email");

      log(jsonEncode(response.data));
      IsEmailExistModel isEmailExistModel =
      IsEmailExistModel.fromJson(response.data);
      // print(categoryModel.success);
      return isEmailExistModel;
    } catch (e) {
      print(e);
      return IsEmailExistModel(success: false);
    }
  }

  static Future<SizeExchangingModel> sizeExchangeResponse(int order_item_id) async{
    try {
      var response = await ApiClient.getClient()!
          .post("order-service/exchange/items/$order_item_id");

      log(jsonEncode(response.data));
      SizeExchangingModel sizeExchangeModel =
      SizeExchangingModel.fromJson(response.data);
      // print(categoryModel.success);
      return sizeExchangeModel;
    } catch (e) {
      print(e);
      return SizeExchangingModel(success: false);
    }
  }

  static Future<AddAddressModel> deleteResponse() async {
    try {
      var response = await ApiClient.getClient()!
          .get("customer-service/customers/delete-user");

      log(jsonEncode(response.data));
      AddAddressModel deactivateModel = AddAddressModel.fromJson(response.data);
      // print(categoryModel.success);
      return deactivateModel;
    } catch (e) {
      print(e);
      return AddAddressModel(success: false);
    }
  }

  static Future<CreateRazorpayCustomerModel> createRazorpayCustomerResponse(String name, String mobile, String email) async{
    try {
      log(name);
      log(email);
      log(mobile);
      var response = await ApiClient.getClient()!
          .post(
          "checkout-service/payment-gateway-customer",
          data: {
            "name": "",
            "email": "$email",
            "contact": "$mobile"
          }
      );

      log(jsonEncode(response.data));
      CreateRazorpayCustomerModel createRazorpayCustomerModel =
      CreateRazorpayCustomerModel.fromJson(response.data);
      // print(categoryModel.success);
      return createRazorpayCustomerModel;
    } catch (e) {
      print(e);
      return CreateRazorpayCustomerModel(success: false);
    }
  }


  static Future<CommonBannerModel> bannerResponse() async {
    try {
      var response = await ApiClient.getClient()!
          .get("homepage-service/promo-banner");

      log(jsonEncode(response.data));
      CommonBannerModel commonBannerModel = CommonBannerModel.fromJson(response.data);
      // print(categoryModel.success);
      return commonBannerModel;
    } catch (e) {
      print(e);
      return CommonBannerModel(success: false);
    }
  }

  static Future<ScratchCardsModel> scratchCardsResponse() async {
    try {
      var response = await ApiClient.getClient()!
          .get("promotion-service/gamification/load-scratchcard");

      log(jsonEncode(response.data));
      ScratchCardsModel scratchCardsModel = ScratchCardsModel.fromJson(response.data);
      // print(categoryModel.success);
      return scratchCardsModel;
    } catch (e) {
      print(e);
      return ScratchCardsModel(success: false);
    }
  }

  static Future<ScratchCodeModel> scratchCodeResponse() async {
    try {
      var response = await ApiClient.getClient()!
          .get("promotion-service/gamification/load-scratchcard-offer");

      log(jsonEncode(response.data));
      ScratchCodeModel scratchCodeModel = ScratchCodeModel.fromJson(response.data);
      // print(categoryModel.success);
      return scratchCodeModel;
    } catch (e) {
      print(e);
      return ScratchCodeModel(success: false);
    }
  }

}
