import 'package:book_keeper/donut_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:book_keeper/constants.dart';
import 'package:book_keeper/screens/input_bottom_sheet.dart';
import 'package:book_keeper/db/transactions_database.dart';
import 'package:book_keeper/model/transactions.dart';
import 'package:intl/intl.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:book_keeper/components/financial_summary_card.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Transactions> filteredTransactions = [];
  DateTimeRange? dateRange;
  int totalIncome = 0;
  int totalExpense = 0;
  Map<String, int> pieIncomeData = {};
  Map<String, int> pieExpenseData = {};

  String getFrom() {
    if (dateRange == null) {
      return 'From';
    } else {
      return DateFormat.yMMMd('en_US').format(dateRange!.start);
    }
  }

  String getUntil() {
    if (dateRange == null) {
      return 'Until';
    } else {
      return DateFormat.yMMMd('en_US').format(dateRange!.end);
    }
  }

  void refreshStats() {
    for (var i = 0; i < 12; i++) {
      pieIncomeData[kIncomeCategoryLabels[i]] = 0;
      pieExpenseData[kExpenseCategoryLabels[i]] = 0;
    }
    for (Transactions transaction in filteredTransactions) {
      if (transaction.income) {
        pieIncomeData[transaction.category] =
            pieIncomeData[transaction.category]! + transaction.amount;
      } else {
        pieExpenseData[transaction.category] =
            pieExpenseData[transaction.category]! + transaction.amount;
      }
    }
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime(DateTime.now().year),
      end: DateTime.now(),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2021),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1)
          .subtract(const Duration(days: 1)),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if (newDateRange == null) return;

    dateRange = newDateRange;
    await refreshTransactions(dateRange);
  }

  @override
  void initState() {
    super.initState();
    dateRange;
    refreshTransactions(null);
  }

  @override
  void dispose() {
    TransactionsDatabase.instance.close();

    super.dispose();
  }

  void refreshNumbers() {
    totalIncome = 0;
    totalExpense = 0;
    for (Transactions transaction in filteredTransactions) {
      transaction.income
          ? totalIncome += transaction.amount
          : totalExpense += transaction.amount;
    }
  }

  Future refreshTransactions(
    DateTimeRange? range,
  ) async {
    filteredTransactions = [];
    List<Transactions> transactions =
        await TransactionsDatabase.instance.readAllTransactions();
    if (range != null) {
      range = DateTimeRange(
          start: range.start, end: range.end.add(const Duration(days: 1)));
      for (Transactions transaction in transactions) {
        if (range.start.isBefore(transaction.createdTime) &&
            range.end.isAfter(transaction.createdTime)) {
          filteredTransactions.add(transaction);
        }
      }
    } else {
      filteredTransactions = transactions;
    }

    refreshNumbers();
    refreshStats();
    setState(() {});
  }

  List<Padding> getTransactionTiles() {
    List<Padding> transactionTiles = [];
    for (Transactions transaction in filteredTransactions) {
      transactionTiles.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: GestureDetector(
            onLongPress: () {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.confirm,
                text: 'Do you want to delete this transaction?',
                confirmBtnText: 'Delete',
                cancelBtnText: 'Cancel',
                onConfirmBtnTap: () async {
                  final db = await TransactionsDatabase.instance.database;
                  await db.delete(
                    tableTransactions,
                    where: '${TransactionFields.id} = ?',
                    whereArgs: [transaction.id],
                  );
                  Navigator.pop(context);
                  refreshTransactions(dateRange);
                },
              );
            },
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              tileColor: const Color(0xFF80CBC4),
              leading: Container(
                height: 56.0,
                width: 56.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Icon(
                  transaction.income
                      ? kIncomeCategoryIcons[
                          kIncomeCategoryLabels.indexOf(transaction.category)]
                      : kExpenseCategoryIcons[
                          kExpenseCategoryLabels.indexOf(transaction.category)],
                  size: 30.0,
                  color: ThemeData.dark().cardColor,
                ),
              ),
              title: SizedBox(
                width: 50,
                height: 24,
                child: AutoSizeText(
                  transaction.description,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: ThemeData.dark().cardColor,
                  ),
                ),
              ),
              trailing: Container(
                margin: const EdgeInsets.only(right: 16.0),
                height: 50,
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat.yMMMd('en_US')
                              .format(transaction.createdTime),
                          style: TextStyle(
                            color: ThemeData.dark().cardColor,
                          ),
                        ),
                        Icon(
                          transaction.income
                              ? Icons.south_west
                              : Icons.north_east,
                          color: transaction.income ? Colors.green : Colors.red,
                          size: 16.0,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          const IconData(
                            0x20B9,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: ThemeData.dark().cardColor,
                        ),
                        Expanded(
                          child: AutoSizeText(
                            transaction.amount.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: ThemeData.dark().cardColor,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return transactionTiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.date_range),
        title: Row(
          children: [
            SizedBox(
              width: 267.4,
              child: GestureDetector(
                onTap: () => pickDateRange(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(getFrom()),
                    const Icon(Icons.arrow_right_alt),
                    Text(getUntil()),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  dateRange = null;
                  refreshTransactions(dateRange);
                },
                child: const Icon(Icons.refresh),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        spacing: 5,
        children: [
          inputBottomSheet(
            context: context,
            income: true,
            label: 'Add An Income',
            icon: const Icon(Icons.savings),
            categoryLabels: kIncomeCategoryLabels,
            categoryIcons: kIncomeCategoryIcons,
            refreshTransactions: refreshTransactions,
          ),
          inputBottomSheet(
            context: context,
            income: false,
            label: 'Add An Expense',
            icon: const Icon(Icons.shopping_cart),
            categoryLabels: kExpenseCategoryLabels,
            categoryIcons: kExpenseCategoryIcons,
            refreshTransactions: refreshTransactions,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  FinancialSummaryCard(
                    amount: totalIncome - totalExpense,
                    label: 'Balance',
                    color: Colors.teal[300],
                  ),
                  FinancialSummaryCard(
                    amount: totalIncome,
                    label: 'Income',
                    color: Colors.green[300],
                  ),
                  FinancialSummaryCard(
                    amount: totalExpense,
                    label: 'Expense',
                    color: Colors.red[300],
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ),
            Expanded(
              flex: 4,
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    title: TabBar(
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.attach_money,
                                size: 30.0,
                              ),
                              Text(
                                'Transactions',
                                style: kLabelStyle,
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.analytics,
                                size: 30.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Statistics',
                                style: kLabelStyle,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: getTransactionTiles(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            DonutChart(
                                isIncome: true,
                                totalIncome: totalIncome,
                                totalExpense: totalExpense,
                                pieIncomeData: pieIncomeData,
                                pieExpenseData: pieExpenseData),
                            const SizedBox(
                              height: 12,
                            ),
                            DonutChart(
                                isIncome: false,
                                totalIncome: totalIncome,
                                totalExpense: totalExpense,
                                pieIncomeData: pieIncomeData,
                                pieExpenseData: pieExpenseData),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
