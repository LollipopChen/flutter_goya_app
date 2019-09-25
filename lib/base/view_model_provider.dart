import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/base.dart';

///提供viewModel的widget
class ViewModelProvider<T extends BaseViewModel> extends StatefulWidget {
  final T viewModel;
  final Widget child;

  ///将Model和View绑定
  ViewModelProvider({@required this.viewModel, @required this.child});

  static T of<T extends BaseViewModel> (BuildContext context){
    final type = _typeOf<ViewModelProvider<T>>();
    ViewModelProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.viewModel;
  }

  @override
  ViewModelProviderState createState() => ViewModelProviderState();

  static Type _typeOf<T>() => T;
}

class ViewModelProviderState extends State<ViewModelProvider> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return widget.child;
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }
}
