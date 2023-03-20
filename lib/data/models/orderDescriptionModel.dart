import 'message.dart';

class OrderDescriptionModel {
  bool? success;
  List<Message>? message;
  String? code;
  OrderDescriptionData? data;

  OrderDescriptionModel({this.success, this.message, this.code, this.data});

  OrderDescriptionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = json['code'];
    data = json['data'] != null ? new OrderDescriptionData.fromJson(json['data']) : null;
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


class OrderDescriptionData {
  int? orderNumber;
  String? customOrderNumber;
  String? orderDate;
  List<OrderItem>? orderItem;
  PriceSummary? priceSummary;
  ShippingAddress? shippingAddress;
  String? orderType;

  OrderDescriptionData(
      {this.orderNumber,
        this.customOrderNumber,
        this.orderDate,
        this.orderItem,
        this.priceSummary,
        this.shippingAddress,
        this.orderType});

  OrderDescriptionData.fromJson(Map<String, dynamic> json) {
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
    orderType = json['order_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['order_type'] = this.orderType;
    return data;
  }
}

class OrderItem {
  int? orderItemId;
  String? orderStatus;
  String? orderStatusDate;
  String? addtionalMessage;
  String? action;
  ItemDetail? itemDetail;
  List<ActionButton>? actionButton;
  TrackingDetail? trackingDetail;

  OrderItem(
      {this.orderItemId,
        this.orderStatus,
        this.orderStatusDate,
        this.addtionalMessage,
        this.action,
        this.itemDetail,
        this.actionButton,
        this.trackingDetail});

  OrderItem.fromJson(Map<String, dynamic> json) {
    orderItemId = json['order_item_id'] ?? 0;
    orderStatus = json['order_status'] ?? "";
    orderStatusDate = json['order_status_date'] ?? "";
    addtionalMessage = json['addtional_message'] ?? "";
    action = json['action'] ?? "";
    itemDetail = json['item_detail'] != null
        ? new ItemDetail.fromJson(json['item_detail'])
        : null;
    if (json['action_button'] != null) {
      actionButton = [];
      json['action_button'].forEach((v) {
        actionButton!.add(new ActionButton.fromJson(v));
      });
    }
    trackingDetail = json['tracking_detail'] != null
        ? new TrackingDetail.fromJson(json['tracking_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_item_id'] = this.orderItemId;
    data['order_status'] = this.orderStatus;
    data['order_status_date'] = this.orderStatusDate;
    data['addtional_message'] = this.addtionalMessage;
    data['action'] = this.action;
    if (this.itemDetail != null) {
      data['item_detail'] = this.itemDetail!.toJson();
    }
    if (this.actionButton != null) {
      data['action_button'] = this.actionButton!.map((v) => v.toJson()).toList();
    }
    if (this.trackingDetail != null) {
      data['tracking_detail'] = this.trackingDetail!.toJson();
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
  String? size;
  int? itemPayable;

  ItemDetail(
      {this.productId,
        this.sku,
        this.itemName,
        this.imageUrl,
        this.quantity,
        this.size,
        this.itemPayable});

  ItemDetail.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'] ?? 0;
    sku = json['sku'] ?? "";
    itemName = json['item_name'] ?? "";
    imageUrl = json['image_url'] ?? "";
    quantity = json['quantity'] ?? 0;
    size = json['size'] ?? "";
    itemPayable = json['item_payable'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['sku'] = this.sku;
    data['item_name'] = this.itemName;
    data['image_url'] = this.imageUrl;
    data['quantity'] = this.quantity;
    data['size'] = this.size;
    data['item_payable'] = this.itemPayable;
    return data;
  }
}

class ActionButton {
  String? actionType;
  String? actionUrl;

  ActionButton({this.actionType, this.actionUrl});

  ActionButton.fromJson(Map<String, dynamic> json) {
    actionType = json['actionType'] ?? "";
    actionUrl = json['actionUrl'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['actionType'] = this.actionType;
    data['actionUrl'] = this.actionUrl;
    return data;
  }
}

class TrackingDetail {
  List<MileStones>? mileStones;
  AdditionalDetail? additionalDetail;

  TrackingDetail({this.mileStones, this.additionalDetail});

  TrackingDetail.fromJson(Map<String, dynamic> json) {
    if (json['mile_stones'] != null) {
      mileStones = [];
      json['mile_stones'].forEach((v) {
        mileStones!.add(new MileStones.fromJson(v));
      });
    }
    additionalDetail = json['additional_detail'] != null
        ? new AdditionalDetail.fromJson(json['additional_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mileStones != null) {
      data['mile_stones'] = this.mileStones!.map((v) => v.toJson()).toList();
    }
    if (this.additionalDetail != null) {
      data['additional_detail'] = this.additionalDetail!.toJson();
    }
    return data;
  }
}

class MileStones {
  int? sequence;
  String? label;
  String? date;
  bool? isCurrentStatus;

  MileStones({this.sequence, this.label, this.date, this.isCurrentStatus});

  MileStones.fromJson(Map<String, dynamic> json) {
    sequence = json['sequence'] ?? 0;
    label = json['label'] ?? "";
    date = json['date'] ?? "";
    isCurrentStatus = json['is_current_status'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sequence'] = this.sequence;
    data['label'] = this.label;
    data['date'] = this.date;
    data['is_current_status'] = this.isCurrentStatus;
    return data;
  }
}

class AdditionalDetail {
  String? awb;
  String? courierCompany;
  String? message;

  AdditionalDetail({this.awb, this.courierCompany, this.message});

  AdditionalDetail.fromJson(Map<String, dynamic> json) {
    awb = json['awb'] ?? "";
    courierCompany = json['courier_company'] ?? "";
    message = json['message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['awb'] = this.awb;
    data['courier_company'] = this.courierCompany;
    data['message'] = this.message;
    return data;
  }
}

class PriceSummary {
  double? orderPayable;
  double? platformDiscount;
  double? promoDiscount;
  double? creditApplied;
  double? shippingCharge;
  String? promocode;
  double? oderTotal;

  PriceSummary(
      {this.orderPayable,
        this.platformDiscount,
        this.promoDiscount,
        this.creditApplied,
        this.shippingCharge,
        this.promocode,
        this.oderTotal});

  PriceSummary.fromJson(Map<String, dynamic> json) {
    orderPayable = json['order_payable'] ?? 0.0;
    platformDiscount = json['platform_discount'] ?? 0.0;
    promoDiscount = json['promo_discount'] ?? 0.0;
    creditApplied = json['credit_applied'] ?? 0.0;
    shippingCharge = json['shipping_charge'] ?? 0.0;
    promocode = json['promocode'] ?? "";
    oderTotal = json['oder_total'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_payable'] = this.orderPayable;
    data['platform_discount'] = this.platformDiscount;
    data['promo_discount'] = this.promoDiscount;
    data['credit_applied'] = this.creditApplied;
    data['shipping_charge'] = this.shippingCharge;
    data['promocode'] = this.promocode;
    data['oder_total'] = this.oderTotal;
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
    pincode = json['pincode'];
    address = json['address'] ?? "";
    landmark = json['landmark'] ?? "";
    city = json['city'] ?? "";
    state = json['state'] ?? "";
    mobile = json['mobile'] ?? "";
    addressId = json['address_id'];
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