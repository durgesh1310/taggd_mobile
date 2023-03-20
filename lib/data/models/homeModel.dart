import './message.dart';


class HomeModel {
  bool? success;
  List<Message>? message;
  int? code = 0;
  HomeData? data;

  HomeModel({this.success, this.message, this.code, this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = int.tryParse(json['code']);
    data = json['data'] != null ? new HomeData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData['success'] = this.success;
    if (this.message != null) {
      jsonData['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    jsonData['code'] = this.code;
    if (this.data != null) {
      jsonData['data'] = this.data?.toJson();
    }
    return jsonData;
  }
}


class HomeData {
  SeoMetaData? seo_meta_data = SeoMetaData();
  MainCarousel? main_carousel = MainCarousel();
  List<PageSections>? page_sections = [];

  HomeData({this.seo_meta_data, this.main_carousel, this.page_sections});

  HomeData.fromJson(Map<String, dynamic> json) {
    seo_meta_data = json['seo_meta_data'] != null
        ? new SeoMetaData.fromJson(json['seo_meta_data'])
        : null;
    main_carousel = json['main_carousel'] != null
        ? new MainCarousel.fromJson(json['main_carousel'])
        : null;
    if (json['page_sections'] != null) {
      page_sections = [];
      json['page_sections'].forEach((v) {
        page_sections?.add(new PageSections.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = new Map<String, dynamic>();
    if (this.seo_meta_data != null) {
      jsonData['data'] = this.seo_meta_data?.toJson();
    }
    if (this.main_carousel != null) {
      jsonData['main_carousel'] = this.main_carousel?.toJson();
    }
    if (this.page_sections != null) {
      jsonData['page_sections'] =
          this.page_sections?.map((v) => v.toJson()).toList();
    }
    return jsonData;
  }
}

class SeoMetaData {
  String? meta_title;
  String? meta_description;
  String? meta_keyword;
  String? h1_tag;
  String? canonical;
  bool? no_follow;
  bool? no_index;

  SeoMetaData(
      {this.meta_title,
      this.meta_description,
      this.meta_keyword,
      this.h1_tag,
      this.canonical,
      this.no_follow,
      this.no_index});

  SeoMetaData.fromJson(Map<String, dynamic> json) {
    meta_title = json['meta_title'];
    meta_description = json['meta_description'];
    meta_keyword = json['meta_keyword'];
    h1_tag = json['h1_tag'];
    canonical = json['canonical'];
    no_follow = json['no_follow'];
    no_index = json['no_index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData['meta_title'] = this.meta_title;
    jsonData['meta_description'] = this.meta_description;
    jsonData['meta_keyword'] = this.meta_keyword;
    jsonData['h1_tag'] = this.h1_tag;
    jsonData['canonical'] = this.canonical;
    jsonData['no_follow'] = this.no_follow;
    jsonData['no_index'] = this.no_index;
    return jsonData;
  }
}

class MainCarousel {
  int? id;
  bool? live;
  String? name;
  String? type;
  String? shape;
  String? platform;
  int? card_count;
  List<CardDetails>? card_details = [];
  int transition_time = 0;

  MainCarousel({
    this.id,
    this.live,
    this.name,
    this.type,
    this.shape,
    this.platform,
    this.card_count,
    this.card_details,
    this.transition_time = 0,
  });

  MainCarousel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    live = json['live'] ?? false;
    name = json['name'] ?? "";
    type = json['type'] ?? "";
    shape = json['shape'] ?? "";
    platform = json['platform'] ?? "";
    card_count = json['card_count'] ?? 0;
    if (json['card_details'] != null) {
      card_details = [];
      json['card_details'].forEach((v) {
        card_details?.add(new CardDetails.fromJson(v));
      });
    }
    transition_time = json['transition_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData['id'] = this.id;
    jsonData['live'] = this.live;
    jsonData['name'] = this.name;
    jsonData['type'] = this.type;
    jsonData['shape'] = this.shape;
    jsonData['platform'] = this.platform;
    jsonData['card_count'] = this.card_count;
    if (this.card_details != null) {
      jsonData['card_details'] =
          this.card_details?.map((v) => v.toJson()).toList();
    }
    jsonData['transition_time'] = this.transition_time;
    return jsonData;
  }
}

class PageSections {
  String? section_name;
  String? type;
  String? alignment;
  Detail? detail;
  BannerDetail? bannerDetail;

  PageSections({this.section_name, this.type, this.alignment, this.detail, this.bannerDetail});

  PageSections.fromJson(Map<String, dynamic> json) {
    section_name = json['section_name'] ?? " ";
    type = json['type'] ?? "";
    alignment = json['alignment'] ?? "";
    detail = (type == "PAGE_CAROUSEL")
        ? new Detail.fromJson(json['detail'])
        : null;
    bannerDetail = ((type == "BANNER")
        ? new BannerDetail.fromJson(json['detail'])
        : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData['section_name'] = this.section_name;
    jsonData['type'] = this.type;
    jsonData['alignment'] = this.alignment;
    if (this.detail != null) {
      jsonData['detail'] = this.detail?.toJson();
    }
    if (this.bannerDetail != null) {
      jsonData['detail'] = this.bannerDetail?.toJson();
    }
    return jsonData;
  }
}

class Detail {
  int? id;
  bool? live;
  String? name;
  String? type;
  String? shape;
  String? platform;
  int? card_count;
  List<CardDetails>? card_details = [];
  int? transition_time;

  Detail({
    this.id,
    this.live,
    this.name,
    this.type,
    this.shape,
    this.platform,
    this.card_count,
    this.card_details,
    this.transition_time,
  });

  Detail.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    live = json['live'] ?? false;
    name = json['name'].toString();
    type = json['type'].toString();
    shape = json['shape'] ?? "";
    platform = json['platform'] ?? "";
    card_count = json['card_count'] ?? 0;
    if (json['card_details'] != null) {
      card_details = [];
      json['card_details'].forEach((v) {
        card_details?.add(new CardDetails.fromJson(v));
      });
    }
    transition_time = json['transition_time'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData['id'] = this.id;
    jsonData['live'] = this.live;
    jsonData['name'] = this.name;
    jsonData['type'] = this.type;
    jsonData['shape'] = this.shape;
    jsonData['platform'] = this.platform;
    jsonData['card_count'] = this.card_count;
    if (this.card_details != null) {
      jsonData['card_details'] =
          this.card_details?.map((v) => v.toJson()).toList();
    }
    jsonData['transition_time'] = this.transition_time;
    return jsonData;
  }
}

class BannerDetail {
  int? id;
  String? live;
  String? name;
  int? rows;
  int? columns;
  String? platform;
  int? card_count;
  List<CardDetails>? card_details = [];
  int? transition_time;

  BannerDetail({
    this.id,
    this.live,
    this.name,
    this.rows,
    this.columns,
    this.platform,
    this.card_count,
    this.card_details,
    this.transition_time,
  });

  BannerDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    live = json['live'].toString();
    name = json['name'].toString();
    rows = json['rows'] ?? 1;
    columns = json['columns'] ?? 1;
    platform = json['platform'].toString();
    card_count = json['card_count'] ?? 0;
    if (json['card_details'] != null) {
      card_details = [];
      json['card_details'].forEach((v) {
        card_details?.add(new CardDetails.fromJson(v));
      });
    }
    transition_time = json['transition_time'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData['id'] = this.id;
    jsonData['live'] = this.live;
    jsonData['name'] = this.name;
    jsonData['rows'] = this.rows;
    jsonData['columns'] = this.columns;
    jsonData['platform'] = this.platform;
    jsonData['card_count'] = this.card_count;
    if (this.card_details != null) {
      jsonData['card_details'] =
          this.card_details?.map((v) => v.toJson()).toList();
    }
    jsonData['transition_time'] = this.transition_time;
    return jsonData;
  }
}

class CardDetails {
  int? id;
  String? type;
  String? action;
  String? icon_url_web;
  String? icon_url_mobile;

  CardDetails(
      {this.id,
      this.type,
      this.action,
      this.icon_url_web,
      this.icon_url_mobile});

  CardDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    type = json['type'].toString();
    action = json['action'].toString();
    icon_url_web = json['icon_url_web'] ?? "";
    icon_url_mobile = json['icon_url_mobile'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = new Map<String, dynamic>();
    jsonData['id'] = this.id;
    jsonData['type'] = this.type;
    jsonData['action'] = this.action;
    jsonData['icon_url_web'] = this.icon_url_web;
    jsonData['icon_url_mobile'] = this.icon_url_mobile;
    return jsonData;
  }
}
