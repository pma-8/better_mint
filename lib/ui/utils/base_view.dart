import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T value, Widget child) builder;
  final Function(T) onModelReady;
  final Function(T) onModelDispose;

  BaseView({@required this.builder, this.onModelReady, this.onModelDispose});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>> {
  T model = locator<T>();

  @override
  void initState() {
    super.initState();
    if(widget.onModelReady != null){
      widget.onModelReady(model);
    }
  }

  @override
  void dispose() {
    if(widget.onModelDispose != null){
      widget.onModelDispose(model);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: Consumer<T>(
        builder: widget.builder,
      ),
    );
  }
}
