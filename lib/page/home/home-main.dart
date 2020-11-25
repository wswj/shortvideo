import 'package:flutter/material.dart';
import 'package:shortvideo/views/tikTokScaffold.dart';
import 'package:shortvideo/views/tiktokTabBar.dart';

class HomeMain extends StatefulWidget {
  HomeMain({Key key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  TikTokPageTag tabBarType = TikTokPageTag.home;
  TikTokScaffoldController tkController = TikTokScaffoldController();
  PageController _pageController = PageController();

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
