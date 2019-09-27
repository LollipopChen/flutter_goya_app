import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/base_view_model.dart';

class TapToTopModel extends BaseViewModel {
  ScrollController _scrollController;

  double _height;

  bool _showTopBtn = false;

  ScrollController get scrollController => _scrollController;

  bool get showTopBtn => _showTopBtn;

  TapToTopModel(this._scrollController, {double height: 200}) {
    _height = height;
  }

  scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOutCubic);
  }

  @override
  void doInit(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.offset > _height && !_showTopBtn) {
        _showTopBtn = true;
        notifyListeners();
      } else if (_scrollController.offset < _height && _showTopBtn) {
        _showTopBtn = false;
        notifyListeners();
      }
    });
  }
}
