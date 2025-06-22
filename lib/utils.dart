import 'dart:convert';

import 'package:flutter/material.dart';

const mobileDesktopBreakpoint = 800;

bool isDesktopLayout(BuildContext context) {
  return MediaQuery.of(context).size.width >= mobileDesktopBreakpoint;
}

void prettyPrintJson(Map<String, dynamic> json) {
  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  String prettyprint = encoder.convert(json);
  print(prettyprint);
}
