import 'message.dart';

class ProductDescriptionModel {
  bool? success;
  String? message;
  String? code;
  ProductDescriptionData? data;

  ProductDescriptionModel({this.success, this.message, this.code, this.data});

  ProductDescriptionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    code = json['code'];
    data = json['data'] != null ? new ProductDescriptionData.fromJson(json['data']) : null;
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

class ProductDescriptionData {
  int? productId;
  String? name;
  dynamic price;
  dynamic regularPrice;
  dynamic displayPrice;
  dynamic strikePrice;
  String? vendorName;
  String? discount;
  List? images;
  List<String>? sizeChart;
  Inventory? inventory;
  String? breadCrum;
  String? category;
  String? subCategory;
  String? productType;
  String? productSubtype;
  String? brand;
  String? edd;
  List<String>? msgOnImage;
  bool? isOnSale;
  bool? canWishlist;
  bool? isReturnable;
  bool? isExchangeable;
  bool? isCod;
  String? expiryDate;
  List<SkuResponse>? skuResponse;
  List<PdpDetailDescription>? pdpDetailDescription;
  SeoMetaData? seoMetaData;
  String? urlKey;
  List<String>? offers;
  bool? isItemWishListed;

  ProductDescriptionData(
      {this.productId,
        this.name,
        this.price,
        this.regularPrice,
        this.vendorName,
        this.discount,
        this.images,
        this.sizeChart,
        this.inventory,
        this.breadCrum,
        this.category,
        this.subCategory,
        this.productType,
        this.productSubtype,
        this.brand,
        this.edd,
        this.msgOnImage,
        this.isOnSale,
        this.canWishlist,
        this.isReturnable,
        this.isExchangeable,
        this.isCod,
        this.expiryDate,
        this.skuResponse,
        this.pdpDetailDescription,
        this.seoMetaData,
        this.urlKey,
        this.offers,
        this.isItemWishListed});

  ProductDescriptionData.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'] ?? "";
    name = json['name'] ?? "";
    price = json['price'];
    regularPrice = json['regular_price'];
    vendorName = json['vendor_name'] ?? "";
    discount = json['discount'] ?? "";
    images = json['images'].cast<String>();
    sizeChart = json['size_chart'].cast<String>();
    inventory = json['inventory'] != null
        ? new Inventory.fromJson(json['inventory'])
        : null;
    breadCrum = json['bread_crum'] ?? "";
    category = json['category'] ?? "";
    subCategory = json['sub_category'] ?? "";
    productType = json['product_type'] ?? "";
    productSubtype = json['product_subtype'] ?? "";
    brand = json['brand'] ?? "";
    edd = json['edd'] ?? "";
    msgOnImage = json['msg_on_image'].cast<String>();
    isOnSale = json['is_on_sale'] ?? false;
    canWishlist = json['can_wishlist'] ?? false;
    isReturnable = json['is_returnable'] ?? false;
    isExchangeable = json['is_exchangeable'] ?? false;
    isCod = json['is_cod'] ?? false;
    expiryDate = json['expiry_date'] ?? "";
    if (json['sku_response'] != null) {
      skuResponse = [];
      json['sku_response'].forEach((v) {
        skuResponse!.add(new SkuResponse.fromJson(v));
      });
    }
    if (json['pdp_detail_description'] != null) {
      pdpDetailDescription = [];
      json['pdp_detail_description'].forEach((v) {
        pdpDetailDescription!.add(new PdpDetailDescription.fromJson(v));
      });
    }
    seoMetaData = json['seo_meta_data'] != null
        ? new SeoMetaData.fromJson(json['seo_meta_data'])
        : null;
    urlKey = json['url_key'] ?? "";
    offers = json['offers'].cast<String>();
    isItemWishListed = json['is_item_wish_listed'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['vendor_name'] = this.vendorName;
    data['discount'] = this.discount;
    data['images'] = this.images;
    data['size_chart'] = this.sizeChart;
    if (this.inventory != null) {
      data['inventory'] = this.inventory!.toJson();
    }
    data['bread_crum'] = this.breadCrum;
    data['category'] = this.category;
    data['sub_category'] = this.subCategory;
    data['product_type'] = this.productType;
    data['product_subtype'] = this.productSubtype;
    data['brand'] = this.brand;
    data['edd'] = this.edd;
    data['msg_on_image'] = this.msgOnImage;
    data['is_on_sale'] = this.isOnSale;
    data['can_wishlist'] = this.canWishlist;
    data['is_returnable'] = this.isReturnable;
    data['is_exchangeable'] = this.isExchangeable;
    data['is_cod'] = this.isCod;
    data['expiry_date'] = this.expiryDate;
    if (this.skuResponse != null) {
      data['sku_response'] = this.skuResponse!.map((v) => v.toJson()).toList();
    }
    if (this.pdpDetailDescription != null) {
      data['pdp_detail_description'] =
          this.pdpDetailDescription!.map((v) => v.toJson()).toList();
    }
    if (this.seoMetaData != null) {
      data['seo_meta_data'] = this.seoMetaData!.toJson();
    }
    data['url_key'] = this.urlKey;
    data['offers'] = this.offers;
    data['is_item_wish_listed'] = this.isItemWishListed;
    return data;
  }
}

class Inventory {
  bool? inStock;
  int? ageOfInventory;
  String? inventoryMessage;

  Inventory({this.inStock});

  Inventory.fromJson(Map<String, dynamic> json) {
    inStock = json['in_stock']  ?? true;
    ageOfInventory = json['age_of_inventory'];
    inventoryMessage = json['inventory_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['in_stock'] = this.inStock;
    data['age_of_inventory'] = this.ageOfInventory;
    data['inventory_message'] = this.inventoryMessage;
    return data;
  }
}

class SkuResponse {
  dynamic retailPrice;
  dynamic regularPrice;
  String? sku;
  int? inventoryCount;
  String? discount;
  String? size;

  SkuResponse(
      {this.retailPrice,
        this.regularPrice,
        this.sku,
        this.inventoryCount,
        this.discount,
        this.size});

  SkuResponse.fromJson(Map<String, dynamic> json) {
    retailPrice = json['retail_price'] ?? 0.0;
    regularPrice = json['regular_price'] ?? 0.0;
    sku = json['sku'] ?? "";
    inventoryCount = json['inventory_count'] ?? 0;
    discount = json['discount'] ?? "";
    size = json['size'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['retail_price'] = this.retailPrice;
    data['regular_price'] = this.regularPrice;
    data['sku'] = this.sku;
    data['inventory_count'] = this.inventoryCount;
    data['discount'] = this.discount;
    data['size'] = this.size;
    return data;
  }
}

class PdpDetailDescription {
  String? displayLabel;
  List<Detail>? detail;

  PdpDetailDescription({this.displayLabel, this.detail});

  PdpDetailDescription.fromJson(Map<String, dynamic> json) {
    displayLabel = json['display_label'] ?? "";
    if (json['detail'] != null) {
      detail = [];
      json['detail'].forEach((v) {
        detail!.add(new Detail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_label'] = this.displayLabel;
    if (this.detail != null) {
      data['detail'] = this.detail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail {
  String? key;
  String? value;

  Detail({this.key, this.value});

  Detail.fromJson(Map<String, dynamic> json) {
    key = json['key'] ?? "";
    value = json['value'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}

class SeoMetaData {
  String? h1;
  int? noFollow;
  int? noIndex;
  String? canonicalUrl;
  String? metaKeywords;
  String? metaDescription;
  String? metaTitle;

  SeoMetaData(
      {this.h1,
        this.noFollow,
        this.noIndex,
        this.canonicalUrl,
        this.metaKeywords,
        this.metaDescription,
        this.metaTitle});

  SeoMetaData.fromJson(Map<String, dynamic> json) {
    h1 = json['h1'];
    noFollow = json['no_follow'];
    noIndex = json['no_index'];
    canonicalUrl = json['canonical_url'];
    metaKeywords = json['meta_keywords'];
    metaDescription = json['meta_description'];
    metaTitle = json['meta_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['h1'] = this.h1;
    data['no_follow'] = this.noFollow;
    data['no_index'] = this.noIndex;
    data['canonical_url'] = this.canonicalUrl;
    data['meta_keywords'] = this.metaKeywords;
    data['meta_description'] = this.metaDescription;
    data['meta_title'] = this.metaTitle;
    return data;
  }
}