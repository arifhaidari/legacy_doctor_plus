
class OneSignalNotificationModel {
  String googleDeliveredPriority;
  int googleSentTime;
  int googleTtl;
  String googleOriginalPriority;
  String othChnl;
  String pri;
  String vis;
  String from;
  String alert;
  String title;
  String grpMsg;
  String googleMessageId;
  String googleCSenderId;

  OneSignalNotificationModel(
      {this.googleDeliveredPriority,
        this.googleSentTime,
        this.googleTtl,
        this.googleOriginalPriority,
        this.othChnl,
        this.pri,
        this.vis,
        this.from,
        this.alert,
        this.title,
        this.grpMsg,
        this.googleMessageId,
        this.googleCSenderId});

  OneSignalNotificationModel.fromJson(Map<String, dynamic> json) {
    googleDeliveredPriority = json['google.delivered_priority'];
    googleSentTime = json['google.sent_time'];
    googleTtl = json['google.ttl'];
    googleOriginalPriority = json['google.original_priority'];
    othChnl = json['oth_chnl'];
    pri = json['pri'];
    vis = json['vis'];
    from = json['from'];
    alert = json['alert'];
    title = json['title'];
    grpMsg = json['grp_msg'];
    googleMessageId = json['google.message_id'];
    googleCSenderId = json['google.c.sender.id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['google.delivered_priority'] = this.googleDeliveredPriority;
    data['google.sent_time'] = this.googleSentTime;
    data['google.ttl'] = this.googleTtl;
    data['google.original_priority'] = this.googleOriginalPriority;
    data['oth_chnl'] = this.othChnl;
    data['pri'] = this.pri;
    data['vis'] = this.vis;
    data['from'] = this.from;
    data['alert'] = this.alert;
    data['title'] = this.title;
    data['grp_msg'] = this.grpMsg;
    data['google.message_id'] = this.googleMessageId;
    data['google.c.sender.id'] = this.googleCSenderId;
    return data;
  }
}