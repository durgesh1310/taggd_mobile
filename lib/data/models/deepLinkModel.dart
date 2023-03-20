import 'dart:convert';


DeepLinkModel? deeplinkModelFromJson(String str) {
  if(str.isNotEmpty){
    return DeepLinkModel.fromJson(json.decode(str));
  }
  else{
    return null;
  }
}

String deeplinkModelToJson(DeepLinkModel data) => json.encode(data.toJson());
class DeepLinkModel {
  var mediaSource;
  var deepLinkSub1;
  var deepLinkValue;
  var isDeferred;
  //String? matchType;
  //String? clickHttpReferrer;
  //String? campaign;
  //String? campaignId;
  //String? afSub1;
  //String? afSub2;
  //String? afSub3;
  //String? afSub4;
  //String? afSub5;

  DeepLinkModel(
      {this.mediaSource,
        this.deepLinkSub1,
        this.deepLinkValue,
        this.isDeferred,
        //this.matchType,
        //this.clickHttpReferrer,
        //this.campaign,
        //this.campaignId,
        //this.afSub1,
        //this.afSub2,
        //this.afSub3,
        //this.afSub4,
        //this.afSub5
      });

  DeepLinkModel.fromJson(Map<String, dynamic> json) {
    mediaSource = json['media_source'];
    deepLinkSub1 = json['deep_link_sub1'];
    deepLinkValue = json['deep_link_value'];
    isDeferred = json['is_deferred'];
    //matchType = json['match_type'];
    //clickHttpReferrer = json['click_http_referrer'];
    //campaign = json['campaign'];
    //campaignId = json['campaign_id'];
    //afSub1 = json['af_sub1'];
    //afSub2 = json['af_sub2'];
    //afSub3 = json['af_sub3'];
    //afSub4 = json['af_sub4'];
    //afSub5 = json['af_sub5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['media_source'] = this.mediaSource;
    data['deep_link_sub1'] = this.deepLinkSub1;
    data['deep_link_value'] = this.deepLinkValue;
    data['is_deferred'] = this.isDeferred;
    //data['match_type'] = this.matchType;
    //data['click_http_referrer'] = this.clickHttpReferrer;
    //data['campaign'] = this.campaign;
    //data['campaign_id'] = this.campaignId;
    //data['af_sub1'] = this.afSub1;
    //data['af_sub2'] = this.afSub2;
    //data['af_sub3'] = this.afSub3;
    //data['af_sub4'] = this.afSub4;
    //data['af_sub5'] = this.afSub5;
    return data;
  }
}