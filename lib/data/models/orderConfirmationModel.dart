import 'message.dart';

class OrderConfirmationModel {
  bool? success;
  List<Message>? message;
  String? code;
  OrderConfirmationData? data;

  OrderConfirmationModel({this.success, this.message, this.code, this.data});

  OrderConfirmationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = json['code'];
    data = json['data'] != null ? new OrderConfirmationData.fromJson(json['data']) : null;
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


class OrderConfirmationData {
  String? bannerImage;
  int? orderNumber;
  String? customOrderNumber;
  String? orderDate;
  List<OrderItem>? orderItem;
  PriceSummary? priceSummary;
  ShippingAddress? shippingAddress;

  OrderConfirmationData(
      {this.bannerImage,
        this.orderNumber,
        this.customOrderNumber,
        this.orderDate,
        this.orderItem,
        this.priceSummary,
        this.shippingAddress});

  OrderConfirmationData.fromJson(Map<String, dynamic> json) {
    bannerImage = json['banner_image'] ?? "";
    orderNumber = json['order_number'] ?? 0;
    customOrderNumber = json['custom_order_number'] ?? "";
    orderDate = json['order_date'] ?? "";
    if (json['order_item'] != null) {
      orderItem = [];
      json['order_item'].forEach((v) {
        orderItem!.add(new OrderItem.fromJson(v));
      });
    }
    priceSummary = json['price_summary'] != null
        ? new PriceSummary.fromJson(json['price_summary'])
        : null;
    shippingAddress = json['shipping_address'] != null
        ? new ShippingAddress.fromJson(json['shipping_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_image'] = this.bannerImage;
    data['order_number'] = this.orderNumber;
    data['custom_order_number'] = this.customOrderNumber;
    data['order_date'] = this.orderDate;
    if (this.orderItem != null) {
      data['order_item'] = this.orderItem!.map((v) => v.toJson()).toList();
    }
    if (this.priceSummary != null) {
      data['price_summary'] = this.priceSummary!.toJson();
    }
    if (this.shippingAddress != null) {
      data['shipping_address'] = this.shippingAddress!.toJson();
    }
    return data;
  }
}

class OrderItem {
  int? orderItemId;
  String? orderStatus;
  ItemDetail? itemDetail;

  OrderItem({this.orderItemId, this.orderStatus, this.itemDetail});

  OrderItem.fromJson(Map<String, dynamic> json) {
    orderItemId = json['order_item_id'] ?? 0;
    orderStatus = json['order_status'] ?? "";
    itemDetail = json['item_detail'] != null
        ? new ItemDetail.fromJson(json['item_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_item_id'] = this.orderItemId;
    data['order_status'] = this.orderStatus;
    if (this.itemDetail != null) {
      data['item_detail'] = this.itemDetail!.toJson();
    }
    return data;
  }
}

class ItemDetail {
  int? productId;
  String? sku;
  String? itemName;
  String? imageUrl;
  int? quantity;
  int? itemPayable;

  ItemDetail(
      {this.productId,
        this.sku,
        this.itemName,
        this.imageUrl,
        this.quantity,
        this.itemPayable});

  ItemDetail.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'] ?? 0;
    sku = json['sku'] ?? "";
    itemName = json['item_name'] ?? "";
    imageUrl = json['image_url'] ?? "";
    quantity = json['quantity'] ?? 0;
    itemPayable = json['item_payable'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['sku'] = this.sku;
    data['item_name'] = this.itemName;
    data['image_url'] = this.imageUrl;
    data['quantity'] = this.quantity;
    data['item_payable'] = this.itemPayable;
    return data;
  }
}

class PriceSummary {
  double? oderTotal;
  double? orderPayable;
  double? platformDiscount;
  double? promoDiscount;
  double? creditApplied;
  double? shippingCharge;
  String? promocode;

  PriceSummary(
      {this.oderTotal,
        this.orderPayable,
        this.platformDiscount,
        this.promoDiscount,
        this.creditApplied,
        this.shippingCharge,
        this.promocode});

  PriceSummary.fromJson(Map<String, dynamic> json) {
    oderTotal = json['oder_total'] ?? 0.0;
    orderPayable = json['order_payable'] ?? 0.0;
    platformDiscount = json['platform_discount'] ?? 0.0;
    promoDiscount = json['promo_discount'] ?? 0.0;
    creditApplied = json['credit_applied'] ?? 0.0;
    shippingCharge = json['shipping_charge'] ?? 0.0;
    promocode = json['promocode'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oder_total'] = this.oderTotal;
    data['order_payable'] = this.orderPayable;
    data['platform_discount'] = this.platformDiscount;
    data['promo_discount'] = this.promoDiscount;
    data['credit_applied'] = this.creditApplied;
    data['shipping_charge'] = this.shippingCharge;
    data['promocode'] = this.promocode;
    return data;
  }
}

class ShippingAddress {
  String? fullName;
  int? pincode;
  String? address;
  String? landmark;
  String? city;
  String? state;
  String? mobile;
  int? addressId;

  ShippingAddress(
      {this.fullName,
        this.pincode,
        this.address,
        this.landmark,
        this.city,
        this.state,
        this.mobile,
        this.addressId});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'] ?? "";
    pincode = json['pincode'] ?? 0;
    address = json['address'] ?? "";
    landmark = json['landmark'] ?? "";
    city = json['city'] ?? "";
    state = json['state'] ?? "";
    mobile = json['mobile'] ?? "";
    addressId = json['address_id'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['pincode'] = this.pincode;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['city'] = this.city;
    data['state'] = this.state;
    data['mobile'] = this.mobile;
    data['address_id'] = this.addressId;
    return data;
  }
}