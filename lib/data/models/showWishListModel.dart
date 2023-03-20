class ShowWishListModel {
  bool? success;
  String? code;
  List<ShowWishListData>? data;

  ShowWishListModel({this.success, this.code, this.data});

  ShowWishListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new ShowWishListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShowWishListData {
  Null id;
  int? productId;
  String? productName;
  String? price;
  double? discount;
  String? productImage;
  List<String>? messageList;
  String? salePrice;

  ShowWishListData({
    this.id,
    this.productId,
    this.productName,
    this.price,
    this.discount,
    this.productImage,
    this.messageList,
    this.salePrice
  });

  ShowWishListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'] ?? 0;
    productName = json['product_name'] ?? "";
    price = json['price'] ?? "";
    discount = json['discount'] ?? 0.0;
    productImage = json['product_image'] ?? "";
    if(json['messageList'] != null){
      messageList = json['messageList'];
    }
    else{
      messageList = [];
    }
    salePrice = json['sale_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['product_image'] = this.productImage;
    if (this.messageList != null) {
      data['messageList'] = this.messageList;
    }
    data['sale_price'] = this.salePrice;
    return data;
  }
}