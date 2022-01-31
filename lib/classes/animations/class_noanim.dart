import 'package:flutter/material.dart';

class NoAnim extends PageRouteBuilder {
  final Widget page;
  @override
  final RouteSettings settings;

  NoAnim({required this.page, required this.settings})
      : super(pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return page;
        });
}
