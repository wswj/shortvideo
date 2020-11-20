import 'package:flutter/material.dart';

class HomeMain extends StatelessWidget {
  const HomeMain({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView(
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
