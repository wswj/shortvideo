import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shortvideo/styles/style.dart';
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

class _TikTokScaffoldState extends State<TikTokScaffold>
    with TickerProviderStateMixin {
  AnimationController _animationControllerX;
  AnimationController _animationControllerY;
  Animation<double> animationX;
  Animation<double> animationY;
  double offsetX;
  double offsetY;
  double inMiddle = 0;
  double screenWidth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller._onAnimateToPage = animateToPage;
  }

  Future animateToPage(p) async {
    if (screenWidth == null) {
      return null;
    }
    switch (p) {
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
    widget.controller.value = p;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(""),
    );
  }

  Future animateTo([double end = 0.0]) {
    final curve = curvedAnimation();
    animationX = Tween(begin: offsetX, end: end).animate(curve)
      ..addListener(() {
        setState(() {
          offsetX = animationX.value;
        });
      });
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

///中间页面
class _MiddlePage extends StatelessWidget {
  final bool absorbing;
  final bool isStack;
  final Widget page;

  final double offsetX;
  final double offsetY;
  final Function onTopDrag;

  final Widget header;
  final Widget tabBar;

  const _MiddlePage({
    Key key,
    this.absorbing,
    this.onTopDrag,
    this.offsetX,
    this.offsetY,
    this.isStack: false,
    @required this.header,
    @required this.tabBar,
    this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget tabBarContainer = tabBar ??
        Container(
          height: 44,
          child: Placeholder(
            color: Colors.red,
          ),
        );
    Widget mainVideoList = Container(
      color: ColorPlate.back1,
      padding: EdgeInsets.only(
          bottom: isStack ? 0 : 44 + MediaQuery.of(context).padding.bottom),
      child: page,
    );
    //刷新标志
    Widget _headerContain;
    if (offsetY >= 20) {
      _headerContain = Opacity(
        opacity: (offsetY - 20) / 20,
        child: Transform.translate(
          offset: Offset(0, offsetY),
          child: Container(
            height: 44,
            child: Center(
              child: const Text(
                "下拉刷新内容",
                style: TextStyle(color: Colors.white, fontSize: SysSize.normal),
              ),
            ),
          ),
        ),
      );
    } else {
      _headerContain = Opacity(
        opacity: max(0, 1 - offsetY / 20),
        child: Transform.translate(
          offset: Offset(0, offsetY),
          child: SafeArea(
              child: Container(
            height: 44,
            child: header ??
                Placeholder(
                  color: Colors.green,
                ),
          )),
        ),
      );
    }
    Widget middle = Transform.translate(
      offset: Offset(offsetX > 0 ? offsetX : offsetX / 5, 0),
      child: Stack(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[mainVideoList, tabBarContainer],
            ),
          ),
          _headerContain
        ],
      ),
    );

    ///判断传入的页面类型是不是pageview 如果是返回中间页
    if (page is! PageView) {
      return middle;
    }

    ///AbsorbPointer是一种禁止用户输入的控件，比如按钮的点击、输入框的输入、ListView的滚动等，你可能说将按钮的onPressed设置为null，一样也可以实现，是的，但AbsorbPointer可以提供多组件的统一控制，而不需要你单独为每一个组件设置。
    ///参考https://www.cnblogs.com/mengqd/p/12675641.html
    return AbsorbPointer(
      absorbing: absorbing,
      child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return;
          },
          child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (notification.direction == ScrollDirection.idle &&
                    notification.metrics.pixels == 0.0) {
                  onTopDrag?.call();
                  return false;
                }
                return null;
              },
              child: middle)),
    );
  }
}

/// 左侧Widget
///
/// 通过 [Transform.scale] 进行根据 [offsetX] 缩放
/// 最小 0.88 最大为 1
class _LeftPageTransform extends StatelessWidget {
  final double offsetX;
  final Widget content;

  const _LeftPageTransform({Key key, this.offsetX, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Transform.scale(
        scale: 0.88 + 0.12 * offsetX / screenWidth < 0.88
            ? 0.88
            : 0.88 + 0.12 * offsetX / screenWidth,
        child: content ?? Placeholder(color: Colors.pink));
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
