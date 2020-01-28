import 'package:flutter/material.dart';

/// Provides controller for all the child widgets.
class PageCtrlProvider extends InheritedWidget {
  final Widget child;
  final PageController pageCtrl;

  PageCtrlProvider({
    @required this.child,
    @required this.pageCtrl,
  }) : super(child: child);

  @override
  bool updateShouldNotify(PageCtrlProvider oldWidget) => false;

  static PageCtrlProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PageCtrlProvider>();
  }
}
