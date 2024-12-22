import 'package:flutter/material.dart';

class OrientationLayout extends StatelessWidget {
  final Widget Function(BuildContext) portraitLayout;
  final Widget Function(BuildContext) landscapeLayout;

  const OrientationLayout({
    Key? key,
    required this.portraitLayout,
    required this.landscapeLayout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? portraitLayout(context)
            : landscapeLayout(context);
      },
    );
  }
}
