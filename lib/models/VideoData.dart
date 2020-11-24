import 'VideoUserInfo.dart';

class VideoData {
  int id;
  int uid;
  String content;
  String url;
  String img;
  int zanNum;
  int pingNum;
  int click;
  int fxNum;
  int hide;
  int time;
  String city;
  int tuijian;
  int money;
  VideoUserInfo user;
  int shopId;

  VideoData(
      {this.id,
      this.uid,
      this.content,
      this.url,
      this.img,
      this.zanNum,
      this.pingNum,
      this.click,
      this.fxNum,
      this.hide,
      this.time,
      this.city,
      this.tuijian,
      this.money,
      this.user,
      this.shopId});

  VideoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    content = json['content'];
    url = json['url'];
    img = json['img'];
    zanNum = json['zan_num'];
    pingNum = json['ping_num'];
    click = json['click'];
    fxNum = json['fx_num'];
    hide = json['hide'];
    time = json['time'];
    city = json['city'];
    tuijian = json['tuijian'];
    money = json['money'];
    user =
        json['user'] != null ? new VideoUserInfo.fromJson(json['user']) : null;
    shopId = json['shop_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['content'] = this.content;
    data['url'] = this.url;
    data['img'] = this.img;
    data['zan_num'] = this.zanNum;
    data['ping_num'] = this.pingNum;
    data['click'] = this.click;
    data['fx_num'] = this.fxNum;
    data['hide'] = this.hide;
    data['time'] = this.time;
    data['city'] = this.city;
    data['tuijian'] = this.tuijian;
    data['money'] = this.money;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['shop_id'] = this.shopId;
    return data;
  }
}
