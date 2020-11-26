import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shortvideo/views/tiktokTabBar.dart';

const double scrollSpeed = 300;

enum TikTokPagePositon {
  left,
  right,
  middle,
}

class TikTokScaffoldController extends ValueNotifier<TikTokPagePositon> {
  TikTokScaffoldController([
    TikTokPagePositon value = TikTokPagePositon.middle,
  ]) : super(value);

  Future animateToPage(TikTokPagePositon pagePositon) {
    return _onAnimateToPage?.call(pagePositon);
  }

  Future animateToLeft() {
    return _onAnimateToPage?.call(TikTokPagePositon.left);
  }

  Future animateToRight() {
    return _onAnimateToPage?.call(TikTokPagePositon.right);
  }

  Future animateToMiddle() {
    return _onAnimateToPage?.call(TikTokPagePositon.middle);
  }

  Future Function(TikTokPagePositon pagePositon) _onAnimateToPage;
}

class TikTokScaffold extends StatefulWidget {
  final TikTokScaffoldController controller;

  /// 首页的顶部
  final Widget header;

  /// 底部导航
  final Widget tabBar;

  /// 左滑页面
  final Widget leftPage;

  /// 右滑页面
  final Widget rightPage;

  /// 视频序号
  final int currentIndex;

  final bool hasBottomPadding;
  final bool enableGesture;

  final Widget page;

  ///下拉刷新回调
  final Function() onPullDownRefresh;

  const TikTokScaffold({
    Key key,
    this.header,
    this.tabBar,
    this.leftPage,
    this.rightPage,
    this.hasBottomPadding: false,
    this.page,
    this.currentIndex: 0,
    this.enableGesture,
    this.onPullDownRefresh,
    this.controller,
  }) : super(key: key);
  @override
  _TikTokScaffoldState createState() => _TikTokScaffoldState();
}

class _TikTokScaffoldState extends State<TikTokScaffold> with TickerProviderStateMixin{
  AnimationController _animationControllerX;
  AnimationController _animationControllerY;
  Animation<double> animationX;
  Animation<double> animationY;
  double offsetX;
  double offsetY;
  double inMiddle=0;
  double screenWidth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller._onAnimateToPage=animateToPage;

  }
  Future animateToPage(p) async{
    if(screenWidth==null){
      return null;
    }
    switch(p){
      case TikTokPagePositon.left:
      await animateTo(screenWidth);
      break;
      case TikTokPagePositon.middle:
        await animateTo();
        break;
      case TikTokPagePositon.right:
        await animateTo(-screenWidth);
        break;

    }
    widget.controller.value=p;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child: child,
    );
  }
  Future animateTo([double end=0.0]){
    final curve=curvedAnimation();
    animationX=Tween(begin:offsetX,end:end).animate(curve)..addListener(() {setState((){offsetX=animationX.value;});});
     inMiddle = end;
    return _animationControllerX.animateTo(1);
  }
   CurvedAnimation curvedAnimation() {
    _animationControllerX = AnimationController(
        duration: Duration(milliseconds: max(offsetX.abs(), 60) * 1000 ~/ 500),
        vsync: this);
    return CurvedAnimation(
        parent: _animationControllerX, curve: Curves.easeOutCubic);
  }
}

/// 左侧Widget
///
/// 通过 [Transform.scale] 进行根据 [offsetX] 缩放
/// 最小 0.88 最大为 1
class _LeftPageTransform extends StatelessWidget {
  final double offsetX;
  final Widget content;

  const _LeftPageTransform({Key key, this.offsetX, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth=MediaQuery.of(context).size.width;
    return Transform.scale(scale: 0.88 + 0.12 * offsetX / screenWidth < 0.88
          ? 0.88
          : 0.88 + 0.12 * offsetX / screenWidth,child:content ?? Placeholder(color:Colors.pink));
  }
}
///右侧页面
class _RightPageTransform extends StatelessWidget {
  final double offsetX;
  final double offsetY;

  final Widget content;

  const _RightPageTransform({
    Key key,
    this.offsetX,
    this.offsetY,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Transform.translate(
        offset: Offset(max(0, offsetX + screenWidth), 0),
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: Colors.transparent,
          child: content ?? Placeholder(fallbackWidth: screenWidth),
        ));
  }
}
