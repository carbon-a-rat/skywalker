import 'package:flutter/material.dart';

class ColoredChipButton extends StatefulWidget {
  ColoredChipButton({
    Key? key,
    required this.name,
    required this.callback,
    this.highlighted = false,
    required this.color,
  }) : super(key: key);

  bool highlighted;
  final Color color;
  final String name;
  final Function callback;
  @override
  State<ColoredChipButton> createState() => _ColoredChipButton();
}

class _ColoredChipButton extends State<ColoredChipButton> {
  @override
  Widget build(BuildContext context) {
    // random color from name
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        side: BorderSide(
          color: widget.color.withAlpha(widget.highlighted ? 200 : 120),
          width: 1,
        ),
        backgroundColor: widget.color.withAlpha(widget.highlighted ? 255 : 20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      onPressed: () => widget.callback(),
      child: Text(
        widget.name,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
