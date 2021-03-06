import 'package:flutter/cupertino.dart';
import 'package:flutter_goya_app/res/styles.dart';
import 'package:flutter_goya_app/res/text_styles.dart';
import 'package:flutter_goya_app/utils/utils.dart';

///状态UILayout
class StateLayout extends StatefulWidget {
  
  const StateLayout({
    Key key,
    @required this.type,
    this.hintText
  }):super(key: key);
  
  final StateType type;
  final String hintText;
  
  @override
  StateLayoutState createState() => StateLayoutState();
}

class StateLayoutState extends State<StateLayout> {
  
  String _img;
  String _hintText;
  
  @override
  Widget build(BuildContext context) {
    switch (widget.type){
      case StateType.noExist:
        _img = "ic_no_data";
        _hintText = "页面不存在";
        break;
      case StateType.noData:
        _img = "ic_no_data";
        _hintText = "暂无数据,点击刷新";
        break;
      case StateType.network:
        _img = "ic_no_net";
        _hintText = "无网络连接";
        break;
      case StateType.loading:
        _img = "";
        _hintText = "加载中...";
        break;
      case StateType.empty:
        _img = "";
        _hintText = "";
        break;
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.type == StateType.loading ? CupertinoActivityIndicator(radius: 16.0) :
          (widget.type == StateType.empty ? SizedBox() :
          Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Utils.getStateImagePath(_img)),
              ),
            ),
          )),
          Gaps.vGap16,
          Text(
            widget.hintText ?? _hintText,
            style: TextStyles.textGray16,
          ),
          Gaps.vGap50,
        ],
      ),
    );
  }
}

enum StateType {
  /// 页面不存在
  noExist,
  /// 无网络
  network,
  /// 无数据
  noData,
  /// 加载中
  loading,
  /// 空
  empty
}