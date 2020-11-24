import 'package:flutter/cupertino.dart';

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
