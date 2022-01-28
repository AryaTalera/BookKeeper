import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final kInactiveCardColor = ThemeData.dark().cardColor;
const kActiveCardColor = Color(0xFF80CBC4);

const TextStyle kLabelStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
);

const TextStyle kStatisticsHeaderTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 24,
);

final kActiveLabelTextStyle = TextStyle(
  fontSize: 14.0,
  color: ThemeData.dark().cardColor,
  fontWeight: FontWeight.bold,
);

const kInactiveLabelTextStyle = TextStyle(
  fontSize: 14.0,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

const List<String> kIncomeCategoryLabels = [
  'Salary',
  'Interest',
  'Business',
  'Credit',
  'A/C Transfer',
  'Refund',
  'Investment',
  'Reimbursement',
  'Loan',
  'Bank Deposit',
  'Rewards',
  'Other',
];

const List<String> kExpenseCategoryLabels = [
  'Bills',
  'EMI',
  'Entertainment',
  'Food & Drinks',
  'Fuel',
  'Groceries',
  'Health',
  'Investment',
  'Shopping',
  'Transfer',
  'Travel',
  'Other',
];

const List<IconData> kIncomeCategoryIcons = [
  Icons.work_rounded,
  Icons.attach_money_rounded,
  Icons.store_rounded,
  Icons.credit_card_rounded,
  FontAwesomeIcons.commentDollar,
  Icons.replay_rounded,
  Icons.trending_up_rounded,
  Icons.gavel_rounded,
  FontAwesomeIcons.handHoldingUsd,
  Icons.account_balance_rounded,
  Icons.card_giftcard_rounded,
  Icons.pending_rounded,
];

const List<IconData> kExpenseCategoryIcons = [
  Icons.receipt_long_rounded,
  Icons.signal_cellular_alt_rounded,
  Icons.theater_comedy_rounded,
  Icons.restaurant_rounded,
  Icons.local_gas_station_rounded,
  Icons.shopping_bag_rounded,
  Icons.local_hospital_rounded,
  Icons.trending_up_rounded,
  Icons.shopping_cart_rounded,
  Icons.swap_horiz_rounded,
  Icons.flight_takeoff_rounded,
  Icons.pending_rounded,
];

List<Color?> kIndicatorColors = [
  Colors.green[400],
  Colors.teal[400],
  Colors.blue[400],
  Colors.pink[400],
  Colors.red[400],
  Colors.blue[400],
  Colors.purple[400],
  Colors.yellow[400],
  Colors.orange[400],
  Colors.grey,
  Colors.brown,
  Colors.lime[400],
];
