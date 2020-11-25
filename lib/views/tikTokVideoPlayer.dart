import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:shortvideo/models/VideoData.dart';

class VideoListController {
  /// 目前的视频序号
  ValueNotifier<int> index = ValueNotifier<int>(0);

  ///构造方法
  VideoListController();
  void setPageController(PageController pageController) {
    pageController.addListener(() {
      var p = pageController.page;
      if (p % 1 == 0) {
        ///~/取整
        int target = p ~/ 1;
        if (index.value == target) return;
        //播放当前的,暂停其他的
        var oldIndex = index.value;
        var newIndex = target;
        playerOfIndex(oldIndex).seekTo(0);
        playerOfIndex(oldIndex).pause();
        playerOfIndex(newIndex).start();
        //完成更新index
        index.value = target;
      }
    });
  }

  /// 视频列表
  List<FijkPlayer> playerList = [];

  /// 获取指定index的player
  FijkPlayer playerOfIndex(int index) => playerList[index];

  /// 视频总数目
  int get videoCount => playerList.length;

  /// 在当前的list后面继续增加视频，并预加载封面
  addVideo(List<VideoData> list) {
    for (var info in list) {
      playerList.add(FijkPlayer()
        ..setDataSource(info.url, autoPlay: true, showCover: true)
        ..setLoop(0));
    }
  }

  ///初始化
  init(PageController pageController, List<VideoData> initialList) {
    addVideo(initialList);
    setPageController(pageController);
  }

  FijkPlayer get currentPlayer => playerList[index.value];

  bool get isPlaying => currentPlayer.state == FijkState.started;

  /// 销毁全部
  void dispose() {
    // 销毁全部
    for (var player in playerList) {
      player.dispose();
    }
    playerList = [];
  }
}
