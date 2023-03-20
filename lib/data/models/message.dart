class Message {
  String? msgType;
  String? msgText;
  String? leftAction;
  String? rightAction;

  Message({this.msgType, this.msgText, this.leftAction, this.rightAction});

  Message.fromJson(Map<String, dynamic> json) {
    msgType = json['msg_type'] ?? "";
    msgText = json['msg_text'] ?? "";
    leftAction = json['left_action'].toString();
    rightAction = json['right_action'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg_type'] = this.msgType;
    data['msg_text'] = this.msgText;
    data['left_action'] = this.leftAction;
    data['right_action'] = this.rightAction;
    return data;
  }
}