class NotificationChatModel {

  String to;
  NotificationModel notification;
  Data data;

  NotificationChatModel({
      this.to, 
      this.notification, 
      this.data,});

  NotificationChatModel.fromJson(dynamic json) {
    to = json['to'];
    notification = json['notification'] != null ? NotificationModel.fromJson(json['notification']) : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['to'] = to;
    if (notification != null) {
      map['notification'] = notification.toJson();
    }
    if (data != null) {
      map['data'] = data.toJson();
    }
    return map;
  }

}

class Data {
  String uid;
  String receiverUid;
  String image;
  String name;
  String click_action="FLUTTER_NOTIFICATION_CLICK";
  String notificationImage;


  Data({
    this.uid,
    this.name,
    this.image,
    this.receiverUid,
    this.notificationImage
  });

  Data.fromJson(dynamic json) {
    uid = json['uid'];
    name=json['name'];
    image = json['image'];
    receiverUid=json['receiverUid'];
    notificationImage=json['notificationImage'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['name'] = name;
    map['image'] = image;
    map['receiverUid'] = receiverUid;
    map['click_action']=click_action;
    map['notificationImage']=notificationImage;
    return map;
  }

}

class NotificationModel {
  NotificationModel({
      this.body,
      this.title,});

  NotificationModel.fromJson(dynamic json) {
    body = json['body'];
    title = json['title'];
  }
  String body;
  String title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['body'] = body;
    map['title'] = title;
    return map;
  }

}