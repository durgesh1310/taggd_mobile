import './message.dart';

class SearchModel {
  bool? success;
  List<Message>? message;
  String? code;
  SearchData? data;

  SearchModel({
    this.success,
    this.message,
    this.code,
    this.data});

  SearchModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = json['code'];
    data = json['data'] != null ? new SearchData.fromJson(json['data']) : null;
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


class SearchData {
  int? totalHits;
  String? query;
  SeoMetaData? seoMetaData;
  String? plpTimer;
  String? plpBanner;
  List<PlpCard>? plpCard;
  List<Filters>? filters;
  SortBy? sortBy;
  MobileBanner? mobileBanner;
  MobileBanner? webBanner;
  MobileBanner? mobileBannerV2;

  SearchData(
      {this.totalHits,
        this.query,
        this.seoMetaData,
        this.plpTimer,
        this.plpBanner,
        this.plpCard,
        this.filters,
        this.sortBy,
        this.mobileBanner,
        this.webBanner,
      this.mobileBannerV2});

  SearchData.fromJson(Map<String, dynamic> json) {
    totalHits = json['total_hits'] ?? 0;
    query = json['query'] ?? "";
    seoMetaData = json['seo_meta_data'] != null
        ? new SeoMetaData.fromJson(json['seo_meta_data'])
        : null;
    plpTimer = json['plp_timer'] ;
    plpBanner = json['plp_banner'] ?? "";
    if (json['plp_card'] != null) {
      plpCard = [];
      json['plp_card'].forEach((v) {
        plpCard!.add(new PlpCard.fromJson(v));
      });
    }
    if (json['filters'] != null) {
      filters = [];
      json['filters'].forEach((v) {
        filters!.add(new Filters.fromJson(v));
      });
    }
    sortBy =
    json['sort_by'] != null ? new SortBy.fromJson(json['sort_by']) : null;
    mobileBanner = json['mobile_banner'] != null
        ? new MobileBanner.fromJson(json['mobile_banner'])
        : null;
    webBanner = json['web_banner'] != null
        ? new MobileBanner.fromJson(json['web_banner'])
        : null;
    mobileBannerV2 = json['mobile_banner_v2'] != null
        ? new MobileBanner.fromJson(json['mobile_banner_v2'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_hits'] = this.totalHits;
    data['query'] = this.query;
    if (this.seoMetaData != null) {
      data['seo_meta_data'] = this.seoMetaData!.toJson();
    }
    data['plp_timer'] = this.plpTimer;
    data['plp_banner'] = this.plpBanner;
    if (this.plpCard != null) {
      data['plp_card'] = this.plpCard!.map((v) => v.toJson()).toList();
    }
    if (this.filters != null) {
      data['filters'] = this.filters!.map((v) => v.toJson()).toList();
    }
    if (this.sortBy != null) {
      data['sort_by'] = this.sortBy!.toJson();
    }
    if (this.mobileBanner != null) {
      data['mobile_banner'] = this.mobileBanner!.toJson();
    }
    if (this.webBanner != null) {
      data['web_banner'] = this.webBanner!.toJson();
    }
    if (this.mobileBannerV2 != null) {
      data['mobile_banner_v2'] = this.mobileBannerV2!.toJson();
    }
    return data;
  }
}

class SeoMetaData {
  String? h1;
  String? h1Tag;
  bool? noFollow;
  bool? noIndex;
  String? canonicalUrl;
  String? keyword;

  SeoMetaData(
      {this.h1, this.h1Tag, this.noFollow, this.noIndex, this.canonicalUrl, this.keyword});

  SeoMetaData.fromJson(Map<String, dynamic> json) {
    h1 = json['h1'];
    h1Tag = json['h1_tag'];
    noFollow = json['no_follow'];
    noIndex = json['no_index'];
    canonicalUrl = json['canonical_url'];
    keyword = json['keyword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['h1'] = this.h1;
    data['h1_tag'] = this.h1Tag;
    data['no_follow'] = this.noFollow;
    data['no_index'] = this.noIndex;
    data['canonical_url'] = this.canonicalUrl;
    data['keyword'] = this.keyword;
    return data;
  }
}

class PlpCard {
  int? productId;
  String? name;
  int? maxRetailPrice;
  int? maxRegularPrice;
  String? price;
  String? currencyCode;
  String? discount;
  List<String>? imageUrls;
  List<String>? sizeChartImageUrls;
  String? action;
  String? type;
  String? deliveryMessage;
  String? vendorName;
  List<SkuInfo>? skuInfo;
  bool? isWishlisted;
  bool? canWishlist;
  List<String>? messageOnImage;
  bool? stockStatus;
  String? stockMsg;
  bool? isOnSale;
  String? brandName;
  String? urlKey;

  PlpCard(
      {this.productId,
        this.name,
        this.maxRetailPrice,
        this.maxRegularPrice,
        this.price,
        this.currencyCode,
        this.discount,
        this.imageUrls,
        this.sizeChartImageUrls,
        this.action,
        this.type,
        this.deliveryMessage,
        this.vendorName,
        this.skuInfo,
        this.isWishlisted,
        this.canWishlist,
        this.messageOnImage,
        this.stockStatus,
        this.stockMsg,
        this.isOnSale,
       this.brandName,
      this.urlKey});

  PlpCard.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'] ?? 0;
    name = json['name'] ?? "";
    maxRetailPrice = json['max_retail_price'] ?? 0;
    maxRegularPrice = json['max_regular_price'] ?? 0;
    price = json['price'] ?? "";
    currencyCode = json['currency_code'] ?? "";
    discount = json['discount'] ?? "";
    imageUrls = json['image_urls'] == null ? [] : json['image_urls'].cast<String>();
    sizeChartImageUrls = json['size_chart_image_urls'] == null ? [] : json['size_chart_image_urls'].cast<String>();
    action = json['action'] ?? "";
    type = json['type'] ?? "";
    deliveryMessage = json['delivery_message'] ?? "";
    vendorName = json['vendor_name'] ?? "";
    if (json['sku_info'] != null) {
      skuInfo = [];
      json['sku_info'].forEach((v) {
        skuInfo!.add(new SkuInfo.fromJson(v));
      });
    }
    isWishlisted = json['is_wishlisted'] ?? false;
    canWishlist = json['can_wishlist'];
    messageOnImage = json['message_on_image'] == null ? [] : json['message_on_image'].cast<String>();
    stockStatus = json['stock_status'];
    stockMsg = json['stock_msg'];
    isOnSale = json['is_on_sale'] ?? false;
    brandName = json['brand_name'] ?? "";
    urlKey = json['url_key'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['max_retail_price'] = this.maxRetailPrice;
    data['max_regular_price'] = this.maxRegularPrice;
    data['price'] = this.price;
    data['currency_code'] = this.currencyCode;
    data['discount'] = this.discount;
    data['image_urls'] = this.imageUrls;
    data['size_chart_image_urls'] = this.sizeChartImageUrls;
    data['action'] = this.action;
    data['type'] = this.type;
    data['delivery_message'] = this.deliveryMessage;
    data['vendor_name'] = this.vendorName;
    if (this.skuInfo != null) {
      data['sku_info'] = this.skuInfo!.map((v) => v.toJson()).toList();
    }
    data['is_wishlisted'] = this.isWishlisted;
    data['can_wishlist'] = this.canWishlist;
    data['messageOnImage'] = this.messageOnImage;
    data['stock_status'] = this.stockStatus;
    data['stock_msg'] = this.stockMsg;
    data['is_on_sale'] = this.isOnSale;
    data['brand_name'] = this.brandName;
    data['url_key'] = this.urlKey;
    return data;
  }
}

class SkuInfo {
  String? sku;
  String? size;

  SkuInfo({this.sku, this.size});

  SkuInfo.fromJson(Map<String, dynamic> json) {
    sku = json['sku'] ?? "";
    size = json['size'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku'] = this.sku;
    data['size'] = this.size;
    return data;
  }
}

class Filters {
  String? type;
  String? filterName;
  String? displayName;
  List<FilterData>? data;
  bool? isMulti;

  Filters({this.type, this.filterName, this.displayName, this.data, this.isMulti});

  Filters.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? "";
    filterName = json['filter_name'] ?? "";
    displayName = json['display_name'] ?? "";
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new FilterData.fromJson(v));
      });
    }
    isMulti = json['is_multi'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['filter_name'] = this.filterName;
    data['display_name'] = this.displayName;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['is_multi'] = this.isMulti;
    return data;
  }
}

class FilterData {
  String? key;
  dynamic value;
  bool? isSelected;
  String? otherInfo;
  double? from;
  double? to;

  FilterData({this.key, this.value, this.isSelected, this.otherInfo ,this.from, this.to});

  FilterData.fromJson(Map<String, dynamic> json) {
    key = json['key'] ?? "";
    value = json['value'];
    isSelected = json['is_selected'] ?? false;
    otherInfo = json['other_info'] ?? null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    data['is_selected'] = this.isSelected;
    data['other_info'] = this.otherInfo;
    return data;
  }
}

class SortBy {
  List<SortByData>? data;

  SortBy({this.data});

  SortBy.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new SortByData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SortByData {
  String? key;
  String? value;
  bool? isSelected;

  SortByData({this.key, this.value, this.isSelected});

  SortByData.fromJson(Map<String, dynamic> json) {
    key = json['key'] ?? "";
    value = json['value'] ?? "";
    isSelected = json['is_selected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    data['is_selected'] = this.isSelected;
    return data;
  }
}

class MobileBanner {
  int? componentId;
  String? componentType;
  ComponentJson? componentJson;
  bool? isRepeat;
  String? repeatAfterOccurrences;

  MobileBanner(
      {this.componentId,
        this.componentType,
        this.componentJson,
        this.isRepeat,
        this.repeatAfterOccurrences});

  MobileBanner.fromJson(Map<String, dynamic> json) {
    componentId = json['component_id'];
    componentType = json['component_type'];
    componentJson = json['component_json'] != null
        ? new ComponentJson.fromJson(json['component_json'])
        : null;
    isRepeat = json['is_repeat'] ?? false;
    repeatAfterOccurrences = json['repeat_after_occurrences'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['component_id'] = this.componentId;
    data['component_type'] = this.componentType;
    if (this.componentJson != null) {
      data['component_json'] = this.componentJson!.toJson();
    }
    data['is_repeat'] = this.isRepeat;
    data['repeat_after_occurrences'] = this.repeatAfterOccurrences;
    return data;
  }
}

class ComponentJson {
  int? id;
  bool? live;
  String? name;
  int? rows;
  int? columns;
  String? platform;
  List<CardDetails>? cardDetails;

  ComponentJson(
      {this.id,
        this.live,
        this.name,
        this.rows,
        this.columns,
        this.platform,
        this.cardDetails});

  ComponentJson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    live = json['live'];
    name = json['name'];
    rows = json['rows'];
    columns = json['columns'];
    platform = json['platform'];
    if (json['card_details'] != null) {
      cardDetails = <CardDetails>[];
      json['card_details'].forEach((v) {
        cardDetails!.add(new CardDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['live'] = this.live;
    data['name'] = this.name;
    data['rows'] = this.rows;
    data['columns'] = this.columns;
    data['platform'] = this.platform;
    if (this.cardDetails != null) {
      data['card_details'] = this.cardDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CardDetails {
  int? id;
  String? type;
  String? action;
  String? iconUrlWeb;
  String? iconUrlMobile;

  CardDetails(
      {this.id, this.type, this.action, this.iconUrlWeb, this.iconUrlMobile});

  CardDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    action = json['action'];
    iconUrlWeb = json['icon_url_web'];
    iconUrlMobile = json['icon_url_mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['action'] = this.action;
    data['icon_url_web'] = this.iconUrlWeb;
    data['icon_url_mobile'] = this.iconUrlMobile;
    return data;
  }
}