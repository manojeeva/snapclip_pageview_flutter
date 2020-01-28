import 'package:flutter/material.dart';
import './background_view.dart';
import 'dart:math' as Math;

import './page_ctrl_provider.dart';

/// Take Advantage of background design to make better UI.
/// It is used to draw background design and forground child.
///
/// itemBuilder => PageViewItem
///
/// backgroundBuilder => BackgroundWidget
///
class SnapClipPageView extends StatefulWidget {
  final Decoration backgroundDecoration;
  final int length;
  final int initialIndex;
  final BackgroundWidget Function(BuildContext context, int index)
      backgroundBuilder;
  final PageViewItem Function(BuildContext context, int index) itemBuilder;
  final void Function(int index) onPageChanged;

  /// SnapClipPageView is an advanced version of PageView
  ///
  /// Customize every signle pixel of pageview.
  const SnapClipPageView({
    Key key,
    this.onPageChanged,
    this.initialIndex = 1,
    @required this.backgroundBuilder,
    @required this.itemBuilder,
    @required this.length,
    this.backgroundDecoration = const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.white, Colors.transparent],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: [.35, .8],
      ),
    ),
  }) : super(key: key);

  @override
  _SnapClipPageViewState createState() => _SnapClipPageViewState();
}

class _SnapClipPageViewState extends State<SnapClipPageView> {
  PageController ctrl;

  @override
  void initState() {
    ctrl = PageController(viewportFraction: .75);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.jumpToPage(widget.initialIndex);
    });
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageCtrlProvider(
      pageCtrl: ctrl,
      child: Stack(
        children: <Widget>[
          Stack(
            children: List.generate(
              widget.length,
              (index) => widget.backgroundBuilder(context, index),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: widget.backgroundDecoration,
            ),
          ),
          PageView.builder(
            onPageChanged: widget.onPageChanged,
            controller: ctrl,
            itemCount: widget.length,
            itemBuilder: widget.itemBuilder,
          ),
        ],
      ),
    );
  }
}

/// PageViewItem takes child to build the item.
class PageViewItem extends StatefulWidget {
  final int index;
  final Widget child;
  final AlignmentGeometry alignment;
  final double height;
  final Decoration Function(double animation) buildDecoration;
  final EdgeInsets padding;
  final EdgeInsets margin;

  /// Responsible for increasing the height for selected item and
  /// gives animation value for decoration to customize the view.
  ///
  /// Align each widget as you need.
  const PageViewItem({
    @required this.index,
    @required this.child,
    @required this.height,
    this.alignment = Alignment.bottomCenter,
    this.padding = const EdgeInsets.all(25),
    this.margin = const EdgeInsets.only(
      right: 8,
      left: 8,
    ),
    this.buildDecoration,
    Key key,
  }) : super(key: key);
  @override
  _PageViewItemState createState() => _PageViewItemState();
}

class _PageViewItemState extends State<PageViewItem> {
  double heightScale = 1;
  final maxScalePoint = .1;
  final minScaleSize = 1.0;
  double opacity = .6;
  final double maxOpacityPoint = .4;
  final double minOpacity = .6;

  PageController pageCtrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pageCtrl = PageCtrlProvider.of(context).pageCtrl;
    pageCtrl.addListener(onChangePage);
  }

  @override
  void dispose() {
    pageCtrl.removeListener(onChangePage);
    super.dispose();
  }

  void onChangePage() {
    double page = pageCtrl.page;
    bool shouldSetState = false;
    double currentScale;
    if (page.ceil() == widget.index) {
      currentScale = (page - (widget.index - 1));
      shouldSetState = true;
    } else if (page.floor() == widget.index) {
      currentScale = ((widget.index + 1) - page);
      shouldSetState = true;
    }

    if (shouldSetState) {
      final maxOpacity = currentScale * maxOpacityPoint + minOpacity;
      opacity = Math.max(minOpacity, maxOpacity);

      final maxSize = currentScale * maxScalePoint + minScaleSize;
      heightScale = Math.max(minScaleSize, maxSize);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: Container(
        height: widget.height * heightScale,
        decoration: widget.buildDecoration != null
            ? widget.buildDecoration(opacity)
            : BoxDecoration(
                color: Colors.white.withOpacity(opacity),
                borderRadius: BorderRadius.circular(25),
              ),
        padding: widget.padding,
        margin: widget.margin,
        child: widget.child,
      ),
    );
  }
}
