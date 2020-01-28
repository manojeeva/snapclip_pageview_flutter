import 'package:flutter/material.dart';
import './page_ctrl_provider.dart';

/// Used in Background Builder Callback.
/// This Widget is responsible for clipping background based on pageview.
class BackgroundWidget extends StatefulWidget {
  final int index;
  final Widget child;

  /// Use Child to build your own background view.
  const BackgroundWidget({
    Key key,
    @required this.child,
    @required this.index,
  }) : super(key: key);

  @override
  _BackgroundWidgetState createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  double page = 0;
  PageController pageCtrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pageCtrl = PageCtrlProvider.of(context).pageCtrl;
    pageCtrl.addListener(onChangeListner);
  }

  @override
  void dispose() {
    pageCtrl.removeListener(onChangeListner);
    super.dispose();
  }

  void onChangeListner() {
    final cp = pageCtrl.page;
    if (cp.ceil() == widget.index)
      setState(() {
        page = cp;
      });
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.child;
    return Positioned.fill(
      child: widget.index == 0
          ? child
          : ClipPath(
              child: child,
              clipper: _BackgroundClipper(
                page,
                widget.index,
              ),
            ),
    );
  }
}

/// Responsible for Clipping background view based on pageview position.
class _BackgroundClipper extends CustomClipper<Path> {
  final double clipValue;
  final int index;

  _BackgroundClipper(this.clipValue, this.index);

  @override
  Path getClip(Size size) {
    var width = size.width * (clipValue - (index - 1));
    Path path = Path()
      ..lineTo(width, 0)
      ..lineTo(width, size.height)
      ..lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(_BackgroundClipper oldClipper) {
    return clipValue.ceil() == index;
  }
}
