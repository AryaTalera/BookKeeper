import 'package:flutter/material.dart';
import 'package:book_keeper/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FinancialSummaryCard extends StatelessWidget {
  const FinancialSummaryCard({
    Key? key,
    required this.amount,
    required this.label,
    this.color,
  }) : super(key: key);

  final int amount;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 100,
        width: 115,
        child: Column(
          children: [
            Text(
              label,
              style: kLabelStyle,
            ),
            Divider(
              thickness: 1,
              color: Colors.teal[200],
            ),
            Expanded(
              child: AutoSizeText(
                amount.toString(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
