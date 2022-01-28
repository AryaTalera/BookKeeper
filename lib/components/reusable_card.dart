import 'package:flutter/material.dart';
import 'package:book_keeper/constants.dart';
import 'package:book_keeper/components/icon_content.dart';

class ReusableCard extends StatelessWidget {
  final String category;
  final String? selectedCategory;
  final IconData icon;
  final Function() onPress;

  const ReusableCard({
    Key? key,
    required this.category,
    required this.selectedCategory,
    required this.icon,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: IconContent(
          icon: icon,
          label: category,
          style: selectedCategory == category
              ? kActiveLabelTextStyle
              : kInactiveLabelTextStyle,
          iconColor: selectedCategory == category
              ? ThemeData.dark().cardColor
              : Colors.white,
        ),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: selectedCategory == category
              ? kActiveCardColor
              : kInactiveCardColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
