import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/cupertino.dart';

class AppsFlyer{

  static AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
    afDevKey: "kp6NBfqSJmQmw5xw3U7hsL",
    appId: "1618165072",
    showDebug: true,
    timeToWaitForATTUserAuthorization: 50, // for iOS 14.5
    //appInviteOneLink: oneLinkID, // Optional field
    //disableAdvertisingIdentifier: false, // Optional field
    //disableCollectASA: false
  );


  static AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);


  static var cartViewPayload = Map<String, dynamic>();
  static var cartItemsPayload = <Map>[];
  static var productPurchase = Map<String, dynamic>();
  static var products = <Map>[];

  static registerationTrack(String name, String gender, String email, String mobno) async {
    bool? result;
    var registerationPayload = {
      "First Name": name.indexOf(' ') == -1 ? name : "${name.substring(0,name.indexOf(' '))}",
      "Last Name": name.indexOf(' ') == -1 ? name : "${name.substring(name.indexOf(' ')+1)}",
      "Gender":"$gender",
      "Email":"$email",
      "Mobile Number":"$mobno",
    };
    try {
      result = await appsflyerSdk.logEvent("Registration", registerationPayload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static loginTrack(String name, String gender, String email, String mobno, int custId) async {
    bool? result;
    var payload = {
      "name": name,
      "gender": "$gender",
      "email": "$email",
      "mobile": "$mobno",
      "customer_id": "$custId"
    };
    try {
      result = await appsflyerSdk.logEvent("Login", payload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static cartViewTrack(var showShoppingCartData,
      double totalRegularPrice,
      double totalplatformDiscount,
      double shippingCharge,
      double totalSavings,
      double orderTotal) async {
    bool? result;
    showShoppingCartData!.forEach((element) {
      cartItemsPayload.add({
        "Category":"${element.category}",
        "Sub-Category":"${element.subCategory}",
        "Image_url":"${element.defaultImageUrl}",
        //"Product Sub-Type":"{element.}",
        "Product Type":"${element.productType}",
        "Product Name":"${element.productName}",
        "Product Price":"${element.retailPrice}",
        "Regular Price":"${element.regularPrice}",
        "Size":"${element.size}",
        "Discount":"${element.itemDiscount}",
      });
    });
    cartViewPayload.putIfAbsent("Products", () => cartItemsPayload);
    cartViewPayload.putIfAbsent("Subtotal", () => "${totalRegularPrice}");
    cartViewPayload.putIfAbsent("OUAT discount", () => "${totalplatformDiscount}");
    cartViewPayload.putIfAbsent("Shipping Cost", () => "${shippingCharge}");
    cartViewPayload.putIfAbsent("Total Saving", () => "${totalSavings}");
    cartViewPayload.putIfAbsent("Order Total", () => "${orderTotal}");
    log(cartViewPayload.toString());
    try {
      result = await appsflyerSdk.logEvent("Cart View", cartViewPayload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static checkOutTrack(double totalRegularPrice,
      double totalplatformDiscount,
      double shippingCharge,
      double orderTotal) async {
    bool? result;
    var checkOutPayload = {
      "Subtotal": "${totalRegularPrice}",
      "OUAT discount": "${totalplatformDiscount}",
      "Shipping Cost": "${shippingCharge}",
      "Order Total": "${orderTotal}"
    };
    try {
      result = await appsflyerSdk.logEvent("Checkout", checkOutPayload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static addToCartTrack(String category,
      String subCategory,
      String imgUrl,
      String productSubtype,
      String productType,
      String name,
      dynamic price,
      dynamic regularPrice,
      String size,
      String discount) async {
    bool? result;
    var addToCartPayload = {
      "Category": "${category}",
      "Sub-Category": "${subCategory}",
      "Image_url": "${imgUrl}",
      "Product Sub-Type": "${productSubtype}",
      "Product Type": "${productType}",
      "Product Name": "${name}",
      "Product Price": "${price}",
      "Regular Price": "${regularPrice}",
      "Size": "${size}",
      "Discount": "${discount}"
    };
    try {
      result = await appsflyerSdk.logEvent("Add to cart", addToCartPayload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static productViewTrack(String category,
      String subCategory,
      String imgUrl,
      String productSubtype,
      String brand,
      String productType,
      String name,
      dynamic price,
      dynamic regularPrice,
      String discount) async {
    bool? result;
    var payload = {
      "Category": "${category}",
      "Sub-Category": "${subCategory}",
      "Image_url": "${imgUrl}",
      "Product Sub-Type": "${productSubtype}",
      "Brand Name": "${brand}",
      "Product Type": "${productType}",
      "Product Name": "${name}",
      "Product Price": "${price}",
      "Regular Price": "${regularPrice}",
      "Discount": "${discount}"
    };
    try {
      result = await appsflyerSdk.logEvent("Product View", payload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static itemSelectedTrack(String category,
      String subCategory,
      String imgUrl,
      String productSubtype,
      String brand,
      String productType,
      String name,
      dynamic price,
      dynamic regularPrice,
      String size,
      String discount) async {
    bool? result;
    var sizePayload = {
      "Category": "${category}",
      "Sub-Category": "${subCategory}",
      "Image_url": "${imgUrl}",
      "Product Sub-Type": "${productSubtype}",
      "Brand Name": "${brand}",
      "Product Type": "${productType}",
      "Product Name": "${name}",
      "Product Price": "${price}",
      "Regular Price": "${regularPrice}",
      "Size": "${size}",
      "Discount": "${discount}"
    };
    try {
      result = await appsflyerSdk.logEvent("ItemSelected", sizePayload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static addToWishlistTrack(String category,
      String subCategory,
      String imgUrl,
      String productType,
      String name,
      dynamic price,
      dynamic regularPrice,
      String size,
      String discount) async {
    bool? result;
    var addToWishlistPayload = {
      "Category": "${category}",
      "Sub-Category": "${subCategory}",
      "Image_url": "${imgUrl}",
      //"Product Sub-Type":"${widget.showShoppingCartData!.}",
      "Product Type": "${productType}",
      "Product Name": "${name}",
      "Product Price": "${price}",
      "Regular Price": "${regularPrice}",
      "Size": "${size}",
      "Discount": "${discount}"
    };
    try {
      result = await appsflyerSdk.logEvent("Add To Wishlist", addToWishlistPayload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static removeFromWishlistTrack(int productId) async {
    bool? result;
    var removeFromWishlistPayload = {
      "Product ID": "${productId}"
    };
    try {
      result = await appsflyerSdk.logEvent("Remove from Wishlist", removeFromWishlistPayload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static removeFromCartTrack(int productId) async {
    bool? result;
    var removeFromCartPayload = {
      "Product ID":"${productId}"
    };
    try {
      result = await appsflyerSdk.logEvent("Remove from cart", removeFromCartPayload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static placeOrderTrack(double totalPrice,
      double totalDeliveryCharges,
      double totalCreditValue,
      double totalOrderPayable,
      String paymentMode) async {
    bool? result;
    var placeOrderPayload = {
      "Sub Total":"${totalPrice}",
      "Shipping cost":"${totalDeliveryCharges}",
      "User Credits":"${totalCreditValue}",
      "Order Total":"${totalOrderPayable}",
      "Payment Mode": paymentMode
    };
    try {
      result = await appsflyerSdk.logEvent("Shipping Details", placeOrderPayload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static productPurchaseTrack(orderItem,
      double promoDiscount,
      double platformDiscount,
      double shippingCharge,
      double oderTotal) async {
    bool? result;
    orderItem!.forEach((element) {
      products.add({
        "Product Name":"${element.itemDetail!.itemName}",
        "Product Price":"${element.itemDetail!.itemPayable}",
        "Product ID":"${element.itemDetail!.productId}",
        //"Product Pattern":"${element.itemDetail!.}",
        //"Product colour":"<Product colour Value>",
        //"Product Size":"${element.itemDetail!.}",
        "Product Image":"${element.itemDetail!.imageUrl}",
        //"Product URL":"<Product URL Value>",
        //"Subtotal":"<Subtotal Value>",
        //"Total Saving":"<Total Saving Value>",
        "Product Quantity":"${element.itemDetail!.quantity}"});
    });
    productPurchase.putIfAbsent("Coupon discount", () => "${promoDiscount}");
    productPurchase.putIfAbsent("Products", () => products);
    productPurchase.putIfAbsent("OUAT discount", () => "${platformDiscount}");
    productPurchase.putIfAbsent("Shipping Charges", () => "${shippingCharge}");
    productPurchase.putIfAbsent("Order Total", () => "${oderTotal}");
    try {
      result = await appsflyerSdk.logEvent("Product Purchase", productPurchase);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static bannerClick(int bannerId, String source, String action, String type, String pageId) async {
    bool? result;
    var payload;
    if(source == "HOME"){
      payload = {
        "Banner Id" : "$bannerId",
        "Source" : "HOME",
        "SOURCE ID" : "0" ,
        "Action" : "$action"
      };
    }
    else{
      payload = {
        "Banner Id" : "$bannerId",
        "Source" : "$source",
        "SOURCE ID" : "$pageId" ,
        "Action" : "$action"
      };
    }
    try {
      result = await appsflyerSdk.logEvent("Banner", payload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static categoryViewed(String subtitle) async {
    bool? result;
    var payload;
    payload ={
      "Subtitle" : "$subtitle"
    };
    try {
      result = await appsflyerSdk.logEvent("Category Viewed", payload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static emailAdded() async {
    bool? result;
    var payload;
    try {
      result = await appsflyerSdk.logEvent("Email Added", payload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }


  static logoutTrack() async {
    bool? result;
    var payload;
    try {
      result = await appsflyerSdk.logEvent("Logout", payload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static paymentInitiatedTrack(double totalPrice,
      double totalDeliveryCharges,
      double totalCreditValue,
      double totalOrderPayable) async {
    bool? result;
    var payload = {
      "Sub Total":"${totalPrice}",
      "Shipping cost":"${totalDeliveryCharges}",
      "User Credits":"${totalCreditValue}",
      "Order Total":"${totalOrderPayable}",
    };
    try {
      result = await appsflyerSdk.logEvent("Payment Initiated", payload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }


  static paymentSuccessTrack(double totalPrice,
      double totalDeliveryCharges,
      double totalCreditValue,
      double totalOrderPayable,
      String paymentMode) async {
    bool? result;
    var paymentSuccesPayload = {
      "Sub Total":"${totalPrice}",
      "Shipping cost":"${totalDeliveryCharges}",
      "User Credits":"${totalCreditValue}",
      "Order Total":"${totalOrderPayable}",
      "Payment Mode": paymentMode,
      "Payment Through": "Online"
    };
    try {
      result = await appsflyerSdk.logEvent("Payment Success", paymentSuccesPayload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  static paymentFailedTrack(double totalPrice,
      double totalDeliveryCharges,
      double totalCreditValue,
      double totalOrderPayable,
      String paymentMode) async {
    bool? result;
    var paymentFailedPayload = {
      "Sub Total":"${totalPrice}",
      "Shipping cost":"${totalDeliveryCharges}",
      "User Credits":"${totalCreditValue}",
      "Order Total":"${totalOrderPayable}",
      "Payment Mode": paymentMode,
      "Payment Through": "Online"
    };
    try {
      result = await appsflyerSdk.logEvent("Payment Failed", paymentFailedPayload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }


  static plpTrack(String query,
      int productId1,
      int productId2,
      int productId3,
      int totalHits) async {
    bool? result;
    var searchPayload = {
      "Keyword":"${query}",
      "product ID":{"id":"${productId1}",
        "id":"${productId2}",
        "id":"${productId3}"
      },
      "Total resultant products":"${totalHits}"
    };
    try {
      result = await appsflyerSdk.logEvent("Product PLP", searchPayload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }


  static collectionTrack(
      String query,
      int productId1,
      int productId2,
      int productId3,
      int totalHits) async {
    bool? result;
    var searchPayload = {
      "Keyword":"${query}",
      "product ID":{"id":"${productId1}",
        "id":"${productId2}",
        "id":"${productId3}"
      },
      "Total resultant products":"${totalHits}"
    };
    try {
      result = await appsflyerSdk.logEvent("Product Collection", searchPayload);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }




}