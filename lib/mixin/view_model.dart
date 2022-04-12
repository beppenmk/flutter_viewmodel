
import 'package:flutter/material.dart';
import 'package:flutter_vm/vm.dart';

mixin ViewModel<Page extends StatefulWidget, T> on State<Page> {
  late T vm;

  @factory
  T getViewModel();

  @override
  void initState() {
    vm = getViewModel();
    super.initState();
  }

  @override
  void dispose() {
    (vm as BaseViewModel).dispose();
    super.dispose();
  }
}
