import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/base_view_model.dart';
import 'package:flutter_goya_app/entity/project_tree_entity.dart';
import 'package:flutter_goya_app/repository/wan_android_repository.dart';
import 'package:rxdart/rxdart.dart';

///WeChat 公众号
class WeChatViewModel extends BaseViewModel{
  //Tab数据
  BehaviorSubject<List<ProjectTreeEntity>> _projectTabObservable = BehaviorSubject();
  Stream<List<ProjectTreeEntity>> get projectTabStream => _projectTabObservable.stream;

  @override
  void dispose() {
    _projectTabObservable.close();
    super.dispose();
  }


  @override
  void doInit(BuildContext context) {
    // TODO: implement doInit
    loadTabData(context);
  }

  ///获取Tab数据
  Future<List<ProjectTreeEntity>> loadTabData(BuildContext context) async{
    return await WanAndroidRepository.fetchWeChatTabs().then((List<ProjectTreeEntity> list){
      _projectTabObservable.add(list);
    }).catchError((error){
      _projectTabObservable.addError(error);
    });
  }
}