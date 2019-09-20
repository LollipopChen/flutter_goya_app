import 'package:flutter/material.dart';
import 'package:flutter_goya_app/widget/state_layout.dart';

class WidgetNotFound extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('页面不存在'),
        centerTitle: true,
      ),
      body: StateLayout(
        type: StateType.noExist,
        hintText: "页面不存在",
      ),
    );
  }

}