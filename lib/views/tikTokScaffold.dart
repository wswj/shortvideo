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
  //是否屏蔽下拉刷新
  bool absorbing = false;
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
    screenWidth = MediaQuery.of(context).size.width;
    Widget body = Stack(
      children: <Widget>[
        _LeftPageTransform(
          offsetX: offsetX,
          content: widget.leftPage,
        ),
        _MiddlePage(
          absorbing: absorbing,
          onTopDrag: () {
            setState(() {});
          },
          offsetX: offsetX,
          offsetY: offsetY,
          header: widget.header,
          tabBar: widget.tabBar,
          isStack: !widget.hasBottomPadding,
          page: widget.page,
        ),
        _RightPageTransform(
          offsetX: offsetX,
          offsetY: offsetY,
          content: widget.leftPage,
        )
      ],
    );
    //增加手势控制
    body = GestureDetector(
      ///当垂直滑动时
      onVerticalDragUpdate: caculateOffsetY,

      ///当垂直滑动结束
      onVerticalDragEnd: (_) async {
        if (!widget.enableGesture) return;
        absorbing = false;
        if (offsetY != 0) {
          await animateToTop();
          widget.onPullDownRefresh?.call();
          setState(() {});
        }
      },
      //当水平滑动结束时
      onHorizontalDragEnd: (details) {
        return onHorizontalDragEnd(
          details,
          screenWidth,
        );
      },
      //当水平方向滑动开始时
      onHorizontalDragStart: (_) {
        if (!widget.enableGesture) return;
        //?.  语法糖 A?.B 如果A为null 返回null，如果A不为null返回A.B 如下如果_animationController不为空则调用_animationController.stop()方法
        _animationControllerX?.stop();
        _animationControllerY?.stop();
      },
      onHorizontalDragUpdate: (details) {
        return onHorizontalDragUpdate(
          details,
          screenWidth,
        );
      },
      child: body,
    );

    ///WillPopScope返回true表示退出应用,false不退出
    body = WillPopScope(
        child: Scaffold(
          body: body,
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
        ),
        onWillPop: () async {
          if (!widget.enableGesture) {
            return true;
          }
          if (inMiddle == 0) {
            return true;
          }
          widget.controller.animateToMiddle();
          return false;
        });
    return body;
  }

  ///计算offsetY
  ///手指上滑[absorbing]为false，不阻止事件，事件交给底层pageview处理
  ///处于第一页且是下拉，则拦截滑动组件
  void caculateOffsetY(DragUpdateDetails details) {
    if (!widget.enableGesture) {
      return;
    }
    if (inMiddle != 0) {
      setState(() {
        absorbing = false;
      });
      return;
    }
    //
    final tempY = offsetY + details.delta.dy / 2;
    //如果当前播放的视频序号为0
    if (widget.currentIndex == 0) {
      if (tempY > 0) {
        if (tempY < 40) {
          offsetY = tempY;
        } else if (offsetY != 40) {
          offsetY = 40;
        }
      } else {
        absorbing = false;
      }
      setState(() {});
    } else {
      ///如果当前播放视频序号不为0
      absorbing = false;
      offsetY = 0;
      setState(() {});
    }
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

  ///滑动到顶部
  ///[offsetY] to 0.0
  Future animateToTop() {
    _animationControllerY = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: offsetY.abs() * 1000 ~/ 60));
    final curve = CurvedAnimation(
        parent: _animationControllerY, curve: Curves.easeOutCubic);
    animationY = Tween(begin: offsetY, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {
          offsetY = animationY.value;
        });
      });
    return _animationControllerY.forward();
  }

  ///水平滑动时
  void onHorizontalDragUpdate(details, screenWidth) {
    if (!widget.enableGesture) {
      return;
    }
    if (offsetX + details.delta.dx >= screenWidth) {
      setState(() {
        offsetX = screenWidth;
      });
    } else if (offsetX + details.delta.dx <= -screenWidth) {
      setState(() {
        offsetX = -screenWidth;
      });
    } else {
      setState(() {
        offsetX += details.delta.dx;
      });
    }
  }

  ///水平方向滑动结束
  onHorizontalDragEnd(details, screenWidth) {
    if (!widget.enableGesture) {
      return;
    }
    print('velocity:${details.velocity}');

    ///获取水平滑动的速度
    var vOffset = details.velocity.pixelsPersecond.dx;
    //如果速度很快且页面处于中间页面时
    if (vOffset > scrollSpeed && inMiddle == 0) {
      //去左边页面
      return animateToPage(TikTokPagePositon.left);
    } else if (vOffset < -scrollSpeed && inMiddle == 0) {
      //去右边页面
      return animateToPage(TikTokPagePositon.right);
    } else if (inMiddle > 0 && vOffset < -scrollSpeed) {
      return animateToPage(TikTokPagePositon.middle);
    } else if (inMiddle < 0 && vOffset > scrollSpeed) {
      if (inMiddle < 0 && vOffset > scrollSpeed) {
        return animateToPage(TikTokPagePositon.middle);
      }
    }

    ///当滑动停止时，根据offsetX的偏移量进行动画
    if (offsetX.abs() < screenWidth * 0.5) {
      //去中间页面
      return animateToPage(TikTokPagePositon.middle);
    } else if (offsetX > 0) {
      //去左边页面
      return animateToPage(TikTokPagePositon.left);
    } else {
      //去右边页面
      return animateToPage(TikTokPagePositon.right);
    }
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
