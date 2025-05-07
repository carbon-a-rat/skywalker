import 'package:flutter/material.dart';

const mobileDesktopBreakpoint = 800;

bool isDesktopLayout(BuildContext context) {
  return MediaQuery.of(context).size.width >= mobileDesktopBreakpoint;
}
