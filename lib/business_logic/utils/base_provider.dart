import 'package:bettermint/enums/view_state_enum.dart';
import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  ViewState _state = ViewState.IDLE;

  ViewState get state => _state;

  void setState(ViewState viewState){
    _state = viewState;
    notifyListeners();
  }
}