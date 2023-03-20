import 'package:ouat/data/models/selectAddressModel.dart';
import 'message.dart';


class CheckOutModel {
  bool? success;
  List<dynamic>? message;
  String? code;
  CheckOutData? data;

  CheckOutModel({this.success, this.message, this.code, this.data});

  CheckOutModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    code = json['code'];
    data = json['data'] != null ? new CheckOutData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CheckOutData {
  Address? address;
  List<Credits>? credits;
  List<OrderSummary>? orderSummary;
  List<String>? paymentMethod;
  PricingSummary? pricingSummary;
  String? orderConfirmationEmail;
  PgCustomerData? pgCustomerData;

  CheckOutData(
      {this.address,
        this.credits,
        this.orderSummary,
        this.paymentMethod,
        this.pricingSummary,
        this.orderConfirmationEmail,
        this.pgCustomerData});

  CheckOutData.fromJson(Map<String, dynamic> json) {
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    if (json['credits'] != null) {
      credits = [];
      json['credits'].forEach((v) {
        credits!.add(new Credits.fromJson(v));
      });
    }
    if (json['order_summary'] != null) {
      orderSummary = [];
      json['order_summary'].forEach((v) {
        orderSummary!.add(new OrderSummary.fromJson(v));
      });
    }
    paymentMethod = json['payment_method'].cast<String>();
    pricingSummary = json['pricing_summary'] != null
        ? new PricingSummary.fromJson(json['pricing_summary'])
        : null;
    orderConfirmationEmail = json['order_confirmation_email'] == null ? "" : json['order_confirmation_email'];
    pgCustomerData = json['pg_customer_data'] != null
        ? new PgCustomerData.fromJson(json['pg_customer_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.credits != null) {
      data['credits'] = this.credits!.map((v) => v.toJson()).toList();
    }
    if (this.orderSummary != null) {
      data['order_summary'] = this.orderSummary!.map((v) => v.toJson()).toList();
    }
    data['payment_method'] = this.paymentMethod;
    if (this.pricingSummary != null) {
      data['pricing_summary'] = this.pricingSummary!.toJson();
    }
    data['order_confirmation_email'] = this.orderConfirmationEmail;
    if (this.pgCustomerData != null) {
      data['pg_customer_data'] = this.pgCustomerData!.toJson();
    }
    return data;
  }
}



class Address {
  int? selectedAddressId;
  List<SelectAddressData>? addresses;

  Address({this.selectedAddressId, this.addresses});

  Address.fromJson(Map<String, dynamic> json) {
    selectedAddressId = json['selected_address_id'] == null ? 0 : json['selected_address_id'];
    if (json['addresses'] != null) {
      addresses = [];
      json['addresses'].forEach((v) {
        addresses!.add(new SelectAddressData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selected_address_id'] = this.selectedAddressId;
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Credits {
  double? amount;
  String? creditName;
  String? type;

  Credits({this.amount, this.creditName, this.type});

  Credits.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] == null ? 0.0 : json['amount'];
    creditName = json['credit_name'] == null ? "" : json['credit_name'];
    type = json['type'] == null ? "" : json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['credit_name'] = this.creditName;
    data['type'] = this.type;
    return data;
  }
}

class OrderSummary {
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
  String? edd;
  String? cartItemMessage;

  OrderSummary(
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
        this.edd,
        this.cartItemMessage});

  OrderSummary.fromJson(Map<String, dynamic> json) {
    defaultImageUrl = json['default_image_url'] == null ? "" : json['default_image_url'];
    productName = json['product_name'] == null ? "" : json['product_name'];
    sku = json['sku'] == null ? "" : json['sku'];
    size = json['size'] == null ? "" : json['size'];
    quantity = json['quantity'] == null ? 0 : json['quantity'];
    retailPrice = json['retail_price'] == null ? 0.0 : json[''];
    regularPrice = json['regular_price'];
    priceChange = json['price_change'];
    itemDiscount = json['item_discount'];
    productId = json['product_id'];
    edd = json['edd'];
    cartItemMessage = json['cart_item_message'];
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
    data['edd'] = this.edd;
    data['cart_item_message'] = this.cartItemMessage;
    return data;
  }
}

class PricingSummary {
  double? totalPrice;
  double? totalPlatformDiscount;
  double? totalPromoDiscount;
  String? promoCode;
  double? totalCreditValue;
  double? totalDeliveryCharges;
  double? totalOrderPayable;

  PricingSummary(
      {this.totalPrice,
        this.totalPlatformDiscount,
        this.totalPromoDiscount,
        this.promoCode,
        this.totalCreditValue,
        this.totalDeliveryCharges,
        this.totalOrderPayable});

  PricingSummary.fromJson(Map<String, dynamic> json) {
    totalPrice = json['total_price'] ?? 0.0;
    totalPlatformDiscount = json['total_platform_discount'] ?? 0.0;
    totalPromoDiscount = json['total_promo_discount'] ?? 0.0;
    promoCode = json['promo_code'] == null ? "" : json['promo_code'];
    totalCreditValue = json['total_credit_value']  ?? 0.0;
    totalDeliveryCharges = json['total_delivery_charges'] ?? 0.0;
    totalOrderPayable = json['total_order_payable'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_price'] = this.totalPrice;
    data['total_platform_discount'] = this.totalPlatformDiscount;
    data['total_promo_discount'] = this.totalPromoDiscount;
    data['promo_code'] = this.promoCode;
    data['total_credit_value'] = this.totalCreditValue;
    data['total_delivery_charges'] = this.totalDeliveryCharges;
    data['total_order_payable'] = this.totalOrderPayable;
    return data;
  }
}


class PgCustomerData {
  SavedCards? savedCards;
  String? pgCustomerId;

  PgCustomerData({this.savedCards, this.pgCustomerId});

  PgCustomerData.fromJson(Map<String, dynamic> json) {
    savedCards = json['saved_cards'] != null
        ? new SavedCards.fromJson(json['saved_cards'])
        : null;
    pgCustomerId = json['pg_customer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.savedCards != null) {
      data['saved_cards'] = this.savedCards!.toJson();
    }
    data['pg_customer_id'] = this.pgCustomerId;
    return data;
  }
}

class SavedCards {
  String? entity;
  int? count;
  List<Items>? items;

  SavedCards({this.entity, this.count, this.items});

  SavedCards.fromJson(Map<String, dynamic> json) {
    entity = json['entity'];
    count = json['count'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entity'] = this.entity;
    data['count'] = this.count;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? id;
  String? entity;
  String? token;
  String? bank;
  String? wallet;
  String? method;
  PaymentCard? paymentCard;
  bool? recurring;
  RecurringDetails? recurringDetails;
  String? authType;
  String? mrn;
  int? usedAt;
  int? createdAt;
  int? expiredAt;
  String? status;
  List<String>? notes;
  bool? dccEnabled;
  bool? compliantWithTokenisationGuidelines;

  Items(
      {this.id,
        this.entity,
        this.token,
        this.bank,
        this.wallet,
        this.method,
        this.paymentCard,
        this.recurring,
        this.recurringDetails,
        this.authType,
        this.mrn,
        this.usedAt,
        this.createdAt,
        this.expiredAt,
        this.status,
        this.notes,
        this.dccEnabled,
        this.compliantWithTokenisationGuidelines});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entity = json['entity'];
    token = json['token'];
    bank = json['bank'];
    wallet = json['wallet'];
    method = json['method'];
    paymentCard = json['card'] != null ? new PaymentCard.fromJson(json['card']) : null;
    recurring = json['recurring'];
    recurringDetails = json['recurring_details'] != null
        ? new RecurringDetails.fromJson(json['recurring_details'])
        : null;
    authType = json['auth_type'];
    mrn = json['mrn'];
    usedAt = json['used_at'];
    createdAt = json['created_at'];
    expiredAt = json['expired_at'];
    status = json['status'];
    notes = json['notes'].cast<String>();
    dccEnabled = json['dcc_enabled'];
    compliantWithTokenisationGuidelines =
    json['compliant_with_tokenisation_guidelines'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['entity'] = this.entity;
    data['token'] = this.token;
    data['bank'] = this.bank;
    data['wallet'] = this.wallet;
    data['method'] = this.method;
    if (this.paymentCard != null) {
      data['card'] = this.paymentCard!.toJson();
    }
    data['recurring'] = this.recurring;
    if (this.recurringDetails != null) {
      data['recurring_details'] = this.recurringDetails!.toJson();
    }
    data['auth_type'] = this.authType;
    data['mrn'] = this.mrn;
    data['used_at'] = this.usedAt;
    data['created_at'] = this.createdAt;
    data['expired_at'] = this.expiredAt;
    data['status'] = this.status;
    data['notes'] = this.notes;
    data['dcc_enabled'] = this.dccEnabled;
    data['compliant_with_tokenisation_guidelines'] =
        this.compliantWithTokenisationGuidelines;
    return data;
  }
}

class PaymentCard {
  String? entity;
  String? name;
  String? last4;
  String? network;
  String? type;
  String? issuer;
  bool? international;
  bool? emi;
  String? subType;
  String? tokenIin;
  int? expiryMonth;
  int? expiryYear;
  Flows? flows;

  PaymentCard(
      {this.entity,
        this.name,
        this.last4,
        this.network,
        this.type,
        this.issuer,
        this.international,
        this.emi,
        this.subType,
        this.tokenIin,
        this.expiryMonth,
        this.expiryYear,
        this.flows});

  PaymentCard.fromJson(Map<String, dynamic> json) {
    entity = json['entity'];
    name = json['name'];
    last4 = json['last4'];
    network = json['network'];
    type = json['type'];
    issuer = json['issuer'];
    international = json['international'];
    emi = json['emi'];
    subType = json['sub_type'];
    tokenIin = json['token_iin'];
    expiryMonth = json['expiry_month'];
    expiryYear = json['expiry_year'];
    flows = json['flows'] != null ? new Flows.fromJson(json['flows']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entity'] = this.entity;
    data['name'] = this.name;
    data['last4'] = this.last4;
    data['network'] = this.network;
    data['type'] = this.type;
    data['issuer'] = this.issuer;
    data['international'] = this.international;
    data['emi'] = this.emi;
    data['sub_type'] = this.subType;
    data['token_iin'] = this.tokenIin;
    data['expiry_month'] = this.expiryMonth;
    data['expiry_year'] = this.expiryYear;
    if (this.flows != null) {
      data['flows'] = this.flows!.toJson();
    }
    return data;
  }
}

class Flows {
  bool? otp;
  bool? recurring;

  Flows({this.otp, this.recurring});

  Flows.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    recurring = json['recurring'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['recurring'] = this.recurring;
    return data;
  }
}

class RecurringDetails {
  String? status;
  String? failureReason;

  RecurringDetails({this.status, this.failureReason});

  RecurringDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    failureReason = json['failure_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['failure_reason'] = this.failureReason;
    return data;
  }
}
