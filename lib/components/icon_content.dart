import 'package:flutter/material.dart';

class IconContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextStyle style;
  final Color iconColor;

  const IconContent({
    Key? key,
    required this.icon,
    required this.label,
    required this.style,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 40.0,
          color: iconColor,
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 5.0,
            right: 5.0,
            top: 2.0,
          ),
          child: Text(
            label,
            style: style,
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
          ),
        ),
      ],
    );
  }
}
