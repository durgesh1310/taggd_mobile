import './message.dart';

class ShowCartModel {
  bool? success = false;
  List<Message>? message;
  String? code;
  CartData? data;

  ShowCartModel({
    this.success,
    this.message, this.code, this.data});

  ShowCartModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    else{
      message = [];
    }
    code = json['code'];
    data = json['data'] != null ? new CartData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CartData {
  int? totalItem;
  List<ShowShoppingCartData>? showShoppingCartData;
  CartItemSummary? cartItemSummary;

  CartData({this.totalItem, this.showShoppingCartData, this.cartItemSummary});

  CartData.fromJson(Map<String, dynamic> json) {
    totalItem = json['total_item'];
    if (json['show_shopping_cart_data'] != null) {
      showShoppingCartData = [];
      json['show_shopping_cart_data'].forEach((v) {
        showShoppingCartData!.add(new ShowShoppingCartData.fromJson(v));
      });
    }
    cartItemSummary = json['cart_item_summary'] != null
        ? new CartItemSummary.fromJson(json['cart_item_summary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_item'] = this.totalItem;
    if (this.showShoppingCartData != null) {
      data['show_shopping_cart_data'] =
          this.showShoppingCartData!.map((v) => v.toJson()).toList();
    }
    if (this.cartItemSummary != null) {
      data['cart_item_summary'] = this.cartItemSummary!.toJson();
    }
    return data;
  }
}

class ShowShoppingCartData {
  String? defaultImageUrl;
  String? productName;
  String? sku;
  String? size;
  int? quantity;
  double? retailPrice;
  double? regularPrice;
  double? priceChange;
  double? itemDiscount;
  int? productId;
  String? category;
  String? subCategory;
  String? productType;
  int? plpId;
  Message? messageDetail;

  ShowShoppingCartData(
      {this.defaultImageUrl,
        this.productName,
        this.sku,
        this.size,
        this.quantity,
        this.retailPrice,
        this.regularPrice,
        this.priceChange,
        this.itemDiscount,
        this.productId,
        this.category,
      this.subCategory,
      this.productType,
      this.plpId,
      this.messageDetail});

  ShowShoppingCartData.fromJson(Map<String, dynamic> json) {
    defaultImageUrl = json['default_image_url'] ?? "";
    productName = json['product_name'] ?? "";
    sku = json['sku'] ?? "";
    size = json['size'] ?? "";
    quantity = json['quantity'] ?? 0;
    retailPrice = json['retail_price'] ?? 0.0;
    regularPrice = json['regular_price'] ?? 0.0;
    priceChange = json['price_change'] ?? 0.0;
    itemDiscount = json['item_discount'] ?? 0.0;
    productId = json['product_id'] ?? 0;
    category = json['category'] ?? "";
    subCategory = json['subCategory'] ?? "";
    productType = json['productType'] ?? "";
    plpId = json['plpId'] ?? 0;
    messageDetail = json['message_detail'] != null
        ? new Message.fromJson(json['message_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['default_image_url'] = this.defaultImageUrl;
    data['product_name'] = this.productName;
    data['sku'] = this.sku;
    data['size'] = this.size;
    data['quantity'] = this.quantity;
    data['retail_price'] = this.retailPrice;
    data['regular_price'] = this.regularPrice;
    data['price_change'] = this.priceChange;
    data['item_discount'] = this.itemDiscount;
    data['product_id'] = this.productId;
    data['category'] = this.category;
    data['subCategory'] = this.subCategory;
    data['productType'] = this.productType;
    data['plpId'] = this.plpId;
    if (this.messageDetail != null) {
      data['message_detail'] = this.messageDetail!.toJson();
    }
    return data;
  }
}

class CartItemSummary {
  double? totalRegularPrice;
  double? totalRetailPrice;
  double? totalplatformDiscount;
  double? totalDiscountByApplyPromo;
  double? shippingCharge;
  double? orderTotal;
  String? message;

  CartItemSummary(
      {this.totalRegularPrice,
        this.totalRetailPrice,
        this.totalplatformDiscount,
        this.totalDiscountByApplyPromo,
        this.shippingCharge,
        this.orderTotal,
        this.message});

  CartItemSummary.fromJson(Map<String, dynamic> json) {
    totalRegularPrice = json['total_regular_price'] ?? 0.0;
    totalRetailPrice = json['total_retail_price'] ?? 0.0;
    totalplatformDiscount = json['totalplatform_discount'] ?? 0.0;
    totalDiscountByApplyPromo = json['total_discount_by_apply_promo'] ?? 0.0;
    shippingCharge = json['shipping_charge'] ?? 0.0;
    orderTotal = json['order_total'] ?? 0.0;
    message = json['message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_regular_price'] = this.totalRegularPrice;
    data['total_retail_price'] = this.totalRetailPrice;
    data['totalplatform_discount'] = this.totalplatformDiscount;
    data['total_discount_by_apply_promo'] = this.totalDiscountByApplyPromo;
    data['shipping_charge'] = this.shippingCharge;
    data['order_total'] = this.orderTotal;
    data['message'] = this.message;
    return data;
  }
}