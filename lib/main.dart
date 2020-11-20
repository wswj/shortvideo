import 'package:flutter/material.dart';
import 'package:shortvideo/page/home/home-main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SafeArea(
          child: MyHomePage(title: 'Flutter Demo Home Page'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<Tab> tabs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabs = [
      Tab(
        text: "同城",
      ),
      Tab(
        text: "关注",
      ),
      Tab(
        text: "推荐",
      )
    ];
    tabController =
        TabController(length: tabs.length, vsync: this, initialIndex: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TabBar(
      indicator: const BoxDecoration(),
      labelColor: Colors.black12,
      indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
      indicatorSize: TabBarIndicatorSize.label,
      tabs: tabs,
      controller: tabController,
    ));
  }
}
