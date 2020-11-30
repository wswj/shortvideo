class APIs {
  static const String apiPrefix = "http://192.168.5.143:8088/api/";
  //获取视频列表接口
  static String videoListUrl = "video/lists/limit/51";
  //登录接口
  static String login = "/login";
  //获取分页数据
  static String getPage = "/getPageArrDic";
  //获取分页分组数据
  static String getGroupPage = "/getGroupPageArrDic";
}

//接口类型
enum APIType { Login, GetPage }
//使用：APITypeValues[APIType.Login]
const APITypeValues = {
  APIType.Login: "/login",
  APIType.GetPage: "/getPageArrDic"
};
