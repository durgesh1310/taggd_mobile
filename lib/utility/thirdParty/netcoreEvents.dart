import 'dart:developer';

import 'package:smartech_flutter_plugin/smartech_plugin.dart';


class NetcoreEvents{
  static var cartViewPayload = Map<String, dynamic>();
  static var cartItemsPayload = <Map>[];
  static var productPurchase = Map<String, dynamic>();
  static var products = <Map>[];

  static void netcoreScreen(String screenName) async {
    var screen = {
      "Screen Name" : "$screenName"
    };
    SmartechPlugin().trackEvent("Screen", screen);
  }

  static registerationTrack(String name, String gender, String email, String mobno) async{
    var registerationPayload = {
      "First Name": name.indexOf(' ') == -1 ? name : "${name.substring(0,name.indexOf(' '))}",
      "Last Name": name.indexOf(' ') == -1 ? name : "${name.substring(name.indexOf(' ')+1)}",
      "Gender":"$gender",
      "Email":"$email",
      "Mobile Number":"$mobno",
    };
    SmartechPlugin().trackEvent("Registration", registerationPayload);
    var map = {
      "EMAIL": email,
      "MOBILE": mobno,
      "FIRSTNAME": name.indexOf(' ') == -1 ? name : "${name.substring(0,name.indexOf(' '))}",
      "LASTNAME": name.indexOf(' ') == -1 ? name : "${name.substring(name.indexOf(' ')+1)}"
    };
    SmartechPlugin().updateUserProfile(map);
  }

  static loginTrack(String name, String gender, String email, String mobno, int custId) async{
    var payload = {
      "name": name,
      "gender": "$gender",
      "email": "$email",
      "mobile": "$mobno",
      "customer_id": "$custId"
    };
    SmartechPlugin().trackEvent("Login", payload);
  }

  static cartViewTrack(var showShoppingCartData,
      double totalRegularPrice,
      double totalplatformDiscount, 
      double shippingCharge,
      double totalSavings,
      double orderTotal) async{
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
    SmartechPlugin().trackEvent("Cart View", cartViewPayload);
  }

  static checkOutTrack(double totalRegularPrice,
      double totalplatformDiscount,
      double shippingCharge,
      double orderTotal) async{
    var checkOutPayload = {
      "Subtotal": "${totalRegularPrice}",
      "OUAT discount": "${totalplatformDiscount}",
      "Shipping Cost": "${shippingCharge}",
      "Order Total": "${orderTotal}"
    };
    SmartechPlugin().trackEvent("Checkout", checkOutPayload);
  }

  static searchTrack(String query, 
      int productId1, 
      int productId2,
      int productId3,
      int totalHits) async{
    var searchPayload = {
      "Keyword":"${query}",
      "product ID":{"id":"${productId1}",
        "id":"${productId2}",
        "id":"${productId3}"
      },
      "Total resultant products":"${totalHits}"
    };
    SmartechPlugin().trackEvent("Product Search", searchPayload);
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
    SmartechPlugin().trackEvent("Add to cart", addToCartPayload);
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

    SmartechPlugin().trackEvent("Product View", payload);
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
    SmartechPlugin().trackEvent("ItemSelected", sizePayload);
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
    SmartechPlugin().trackEvent("Wishlist", addToWishlistPayload);
  }

  static removeFromWishlistTrack(int productId) async {
    var removeFromWishlistPayload = {
      "Product ID": "${productId}"
    };
    SmartechPlugin()
        .trackEvent("Remove from Wishlist", removeFromWishlistPayload);
  }

  static removeFromCartTrack(int productId) async{
    var removeFromCartPayload = {
      "Product ID":"${productId}"
    };
    SmartechPlugin().trackEvent("Remove from cart", removeFromCartPayload);
  }

  static placeOrderTrack(double totalPrice,
      double totalDeliveryCharges,
      double totalCreditValue,
      double totalOrderPayable,
      String paymentMode) async{
    var placeOrderPayload = {
      "Sub Total":"${totalPrice}",
      "Shipping cost":"${totalDeliveryCharges}",
      "User Credits":"${totalCreditValue}",
      "Order Total":"${totalOrderPayable}",
      "Payment Mode": paymentMode
    };
    SmartechPlugin().trackEvent("Shipping Details", placeOrderPayload);
  }

  static productPurchaseTrack(orderItem,
      double promoDiscount,
      double platformDiscount,
      double shippingCharge,
      double oderTotal) async{
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
    SmartechPlugin().trackEvent("Product Purchase", productPurchase);
  }

  static bannerClick(int bannerId, String source, String action, String type, String pageId) async {
    var payload;
    if(source == "HOME"){
      payload = {
        "Banner Id" : "$bannerId",
        "Source" : "HOME",
        "SOURCE ID" : "0" ,
        "Action" : "$action"
      };
    }
    else if (source == "SPECIAL"){
      payload = {
        "Banner Id" : "$bannerId",
        "Source" : "SPECIAL",
        "SOURCE ID" : "$pageId" ,
        "Action" : "$action"
      };
    }
    else{
      payload = {
        "Banner Id" : "$bannerId",
        "Source" : "PLP",
        "SOURCE ID" : "$pageId" ,
        "Action" : "$action"
      };
    }
    SmartechPlugin().trackEvent("Banner", payload);
  }

  static categoryViewed(String subtitle) async {
    var payload;
    payload ={
      "Subtitle" : "$subtitle"
    };
    SmartechPlugin().trackEvent("Category Viewed", payload);
  }

  static emailAdded() async {
    var payload;
    SmartechPlugin().trackEvent("Email Added", payload);
  }


  static logoutTrack() async {
    var payload;
    SmartechPlugin().trackEvent("Logout", payload);
  }

  static paymentInitiatedTrack(double totalPrice,
      double totalDeliveryCharges,
      double totalCreditValue,
      double totalOrderPayable
      ) async {
    var payload = {
      "Sub Total":"${totalPrice}",
      "Shipping cost":"${totalDeliveryCharges}",
      "User Credits":"${totalCreditValue}",
      "Order Total":"${totalOrderPayable}",
    };
    SmartechPlugin().trackEvent("Payment Initiated", payload);
  }


  static paymentSuccessTrack(double totalPrice,
      double totalDeliveryCharges,
      double totalCreditValue,
      double totalOrderPayable,
      String paymentMode) async {
    var paymentSuccesPayload = {
      "Sub Total":"${totalPrice}",
      "Shipping cost":"${totalDeliveryCharges}",
      "User Credits":"${totalCreditValue}",
      "Order Total":"${totalOrderPayable}",
      "Payment Mode": paymentMode,
      "Payment Through": "Online"
    };
    SmartechPlugin().trackEvent("Payment Success", paymentSuccesPayload);
  }

  static paymentFailedTrack(double totalPrice,
      double totalDeliveryCharges,
      double totalCreditValue,
      double totalOrderPayable,
      String paymentMode) async {
    var paymentFailedPayload = {
      "Sub Total":"${totalPrice}",
      "Shipping cost":"${totalDeliveryCharges}",
      "User Credits":"${totalCreditValue}",
      "Order Total":"${totalOrderPayable}",
      "Payment Mode": paymentMode,
      "Payment Through": "Online"
    };
    SmartechPlugin().trackEvent("Payment Failed", paymentFailedPayload);
  }


  static plpTrack(String query,
      int productId1,
      int productId2,
      int productId3,
      int totalHits) async {
    var searchPayload = {
      "Keyword":"${query}",
      "product ID":{"id":"${productId1}",
        "id":"${productId2}",
        "id":"${productId3}"
      },
      "Total resultant products":"${totalHits}"
    };
    SmartechPlugin().trackEvent("Product PLP", searchPayload);
  }


  static collectionTrack(
      String query,
      int productId1,
      int productId2,
      int productId3,
      int totalHits) async {
    var searchPayload = {
      "Keyword":"${query}",
      "product ID":{"id":"${productId1}",
        "id":"${productId2}",
        "id":"${productId3}"
      },
      "Total resultant products":"${totalHits}"
    };
    SmartechPlugin().trackEvent("Product Collection", searchPayload);
  }



}