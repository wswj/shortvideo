import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shortvideo/page/home/home-main.dart';

void main() {
  ///自定义报错页面12345678
  if(kReleaseMode){
    ErrorWidget.builder=(FlutterErrorDetails flutterErrorDetails){
      debugPrint(flutterErrorDetails.toString());
      return Material(child:Center(child: Text("发生了没有处理的错误",textAlign: TextAlign.center,),));
    };
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
        title: 'Flutter Demo',
        
        theme: ThemeData(
          primaryColor: Colors.black,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          
        ),
        home:MyHome());
  }
}

class MyHome extends StatefulWidget {
  MyHome({Key key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin{
  AnimationController _animationController;
  Animation _animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController=AnimationController(vsync: this,duration:Duration(milliseconds:9000));
    _animation=Tween(begin:1.0,end:0.0).animate(_animationController);
    _animation.addStatusListener((status) {if(status==AnimationStatus.completed){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context){return HomeMain();}), (route) => route==null);
    }});
    _animationController.forward();
  }
  @override
  Widget build(BuildContext context) {
    Random random=Random();
    var mainImg="main"+(1+random.nextInt(7)).toString()+".jpg";
    return FadeTransition(opacity: _animation,child: Image.asset("lib/imgs/"+mainImg,fit: BoxFit.cover,),);
  }
}


