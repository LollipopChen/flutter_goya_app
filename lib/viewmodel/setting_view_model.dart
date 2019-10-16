import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/base_view_model.dart';
import 'package:flutter_goya_app/config/storage_manager.dart';

/// 使用原生WebView
const String kUseWebViewPlugin = 'kUseWebViewPlugin';

///设置
class SettingViewModel extends BaseViewModel{
  @override
  void doInit(BuildContext context) {
    // TODO: implement doInit
  }

  get value =>
      StorageManager.sharedPreferences.getBool(kUseWebViewPlugin) ?? false;

  switchValue(){
    StorageManager.sharedPreferences
        .setBool(kUseWebViewPlugin, !value);
    notifyListeners();
  }
}