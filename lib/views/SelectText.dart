import 'package:flutter/material.dart';
import 'package:shortvideo/styles/style.dart';

//底部导航栏
class SelectText extends StatelessWidget {
  //是否被选中
  final bool isSelect;
  //标题
  final String title;
  const SelectText({Key key, this.isSelect: true, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      color: Colors.black.withOpacity(0),
      child: Text(title ?? '??',
          textAlign: TextAlign.center,
          style: isSelect
              ? StandardTextStyle.big
              : StandardTextStyle.bigWithOpacity),
    );
  }
}
