import 'package:flutter/material.dart';

// set sizing to prose (65ch)

// https://baymard.com/blog/line-length-readability
// the best length for readability is 65 characters

class WidgetProse extends StatelessWidget {
  const WidgetProse({super.key, required this.child, this.style});

  final Widget child;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    TextStyle? sstyle = style;

    sstyle ??= DefaultTextStyle.of(context).style;
    final textPainter = TextPainter(
      text: TextSpan(text: '0', style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    final double charWidth = textPainter.size.width;
    final double maxWidth = 65 * charWidth;
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    );
  }
}

Widget maxWProse(Widget child) {
  return WidgetProse(child: child);
}

Widget maxWProseCentered(Widget child) {
  return Center(child: WidgetProse(child: child));
}
