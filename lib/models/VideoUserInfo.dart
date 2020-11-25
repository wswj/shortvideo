class VideoUserInfo {
  int id;
  String nickname;
  Null mobile;
  String img;
  String qianming;
  int age;
  Null province;
  Null city;
  Null area;
  int birthday;
  int haoma;
  int vipTime;
  String username;
  int huozan;
  int guanzhu;
  int fensi;
  int zuopinNum;
  int xihuanNum;
  int shiming;
  bool vip;
  int vipD;
  Null xiaodian;

  VideoUserInfo(
      {this.id,
      this.nickname,
      this.mobile,
      this.img,
      this.qianming,
      this.age,
      this.province,
      this.city,
      this.area,
      this.birthday,
      this.haoma,
      this.vipTime,
      this.username,
      this.huozan,
      this.guanzhu,
      this.fensi,
      this.zuopinNum,
      this.xihuanNum,
      this.shiming,
      this.vip,
      this.vipD,
      this.xiaodian});

  VideoUserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    mobile = json['mobile'];
    img = json['img'];
    qianming = json['qianming'];
    age = json['age'];
    province = json['province'];
    city = json['city'];
    area = json['area'];
    birthday = json['birthday'];
    haoma = json['haoma'];
    vipTime = json['vip_time'];
    username = json['username'];
    huozan = json['huozan'];
    guanzhu = json['guanzhu'];
    fensi = json['fensi'];
    zuopinNum = json['zuopin_num'];
    xihuanNum = json['xihuan_num'];
    shiming = json['shiming'];
    vip = json['vip'];
    vipD = json['vip_d'];
    xiaodian = json['xiaodian'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nickname'] = this.nickname;
    data['mobile'] = this.mobile;
    data['img'] = this.img;
    data['qianming'] = this.qianming;
    data['age'] = this.age;
    data['province'] = this.province;
    data['city'] = this.city;
    data['area'] = this.area;
    data['birthday'] = this.birthday;
    data['haoma'] = this.haoma;
    data['vip_time'] = this.vipTime;
    data['username'] = this.username;
    data['huozan'] = this.huozan;
    data['guanzhu'] = this.guanzhu;
    data['fensi'] = this.fensi;
    data['zuopin_num'] = this.zuopinNum;
    data['xihuan_num'] = this.xihuanNum;
    data['shiming'] = this.shiming;
    data['vip'] = this.vip;
    data['vip_d'] = this.vipD;
    data['xiaodian'] = this.xiaodian;
    return data;
  }
}
