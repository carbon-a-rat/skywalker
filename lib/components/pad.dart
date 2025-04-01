import 'package:flutter/material.dart';

const pad_big_val = 24.0;
const pad_small_val = 6.0;
const pad_medium_val = 12.0;

Widget padbig(Widget child) {
  return Padding(padding: const EdgeInsets.all(pad_big_val), child: child);
}

Widget pad(Widget child) {
  return Padding(padding: const EdgeInsets.all(pad_medium_val), child: child);
}

Widget padsmall(Widget child) {
  return Padding(padding: const EdgeInsets.all(pad_small_val), child: child);
}

Widget padybig(Widget child) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: pad_big_val),
    child: child,
  );
}

Widget pady(Widget child) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: pad_medium_val),
    child: child,
  );
}

Widget padysmall(Widget child) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: pad_small_val),
    child: child,
  );
}

Widget padxbig(Widget child) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: pad_big_val),
    child: child,
  );
}

Widget padx(Widget child) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: pad_medium_val),
    child: child,
  );
}

Widget padxsmall(Widget child) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: pad_small_val),
    child: child,
  );
}
