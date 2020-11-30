import 'package:flutter/material.dart';
import 'package:shortvideo/models/VideoData.dart';
import 'package:shortvideo/views/tikTokScaffold.dart';
import 'package:shortvideo/views/tikTokVideoPlayer.dart';
import 'package:shortvideo/views/tiktokTabBar.dart';

class HomeMain extends StatefulWidget {
  HomeMain({Key key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> with WidgetsBindingObserver {
  TikTokPageTag tabBarType = TikTokPageTag.home;
  TikTokScaffoldController tkController = TikTokScaffoldController();
  PageController _pageController = PageController();
  VideoListController _videoListController = VideoListController();

  ///记录点赞
  Map<int, bool> favoriteMap = {};
  List<VideoData> videoDataList = [];

  ///fluter生命周期
  ///参考https://zhuanlan.zhihu.com/p/83603371
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    //如果应用不处于活动中,暂停播放
    if (state != AppLifecycleState.resumed) {
      _videoListController.currentPlayer.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _videoListController.currentPlayer.pause();
    super.dispose();
  }

  @override
  void initState() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Center(child: Text("data1")),
          Center(
            child: Text("data2"),
          )
        ],
      ),
    );
  }
}
