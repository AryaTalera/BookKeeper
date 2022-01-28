import 'package:book_keeper/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'components/indicator.dart';

class DonutChart extends StatefulWidget {
  final bool isIncome;
  final int totalIncome;
  final int totalExpense;
  final Map<String, int> pieIncomeData;
  final Map<String, int> pieExpenseData;

  const DonutChart({
    Key? key,
    required this.isIncome,
    required this.totalIncome,
    required this.totalExpense,
    required this.pieIncomeData,
    required this.pieExpenseData,
  }) : super(key: key);

  @override
  _DonutChartState createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  int touchedIndex = -1;

  Widget buildIndicators() {
    List<Widget> column1 = [];
    List<Widget> column2 = [];
    for (var i = 0; i < 6; i++) {
      column1.add(
        Indicator(
          color: kIndicatorColors[i]!,
          text: widget.isIncome
              ? kIncomeCategoryLabels[i]
              : kExpenseCategoryLabels[i],
          isSquare: true,
        ),
      );
    }
    for (var i = 6; i < 12; i++) {
      column2.add(
        Indicator(
          color: kIndicatorColors[i]!,
          text: widget.isIncome
              ? kIncomeCategoryLabels[i]
              : kExpenseCategoryLabels[i],
          isSquare: true,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: column1,
            ),
          ),
          SizedBox(
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: column2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  widget.isIncome
                      ? const Text(
                          'Income By Category',
                          style: kStatisticsHeaderTextStyle,
                        )
                      : const Text(
                          'Expense By Category',
                          style: kStatisticsHeaderTextStyle,
                        ),
                ],
              ),
            ),
            Expanded(
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  }),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 30,
                  sections: showingSections(),
                ),
              ),
            ),
            buildIndicators(),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(12, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 70.0 : 60.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      final List<double> valueList = [];
      final List<String> titleList = [];
      final List badgeList = [];
      final List<PieChartSectionData> pieSectionData = [];
      for (var i = 0; i < 12; i++) {
        valueList.add(
          widget.isIncome
              ? widget.pieIncomeData[kIncomeCategoryLabels[i]]! == 0
                  ? 0.0001
                  : widget.pieIncomeData[kIncomeCategoryLabels[i]]!.toDouble()
              : widget.pieExpenseData[kExpenseCategoryLabels[i]]! == 0
                  ? 0.0001
                  : widget.pieExpenseData[kExpenseCategoryLabels[i]]!
                      .toDouble(),
        );
      }
      for (var i = 0; i < 12; i++) {
        titleList.add(valueList[i] == 0.0001
            ? ''
            : '${((valueList[i] / (widget.isIncome ? widget.totalIncome : widget.totalExpense)) * 100).round()}%');
      }

      for (var i = 0; i < 12; i++) {
        badgeList.add(
          valueList[i] == 0.0001
              ? null
              : _Badge(
                  widget.isIncome
                      ? kIncomeCategoryIcons[i]
                      : kExpenseCategoryIcons[i],
                  size: widgetSize,
                  borderColor: kIndicatorColors[i]!,
                ),
        );
      }
      for (var i = 0; i < 12; i++) {
        pieSectionData.add(
          PieChartSectionData(
            color: kIndicatorColors[i],
            value: valueList[i],
            title: titleList[i],
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            badgeWidget: badgeList[i],
            badgePositionPercentageOffset: 1.1,
          ),
        );
      }

      switch (i) {
        case 0:
          return pieSectionData[0];
        case 1:
          return pieSectionData[1];
        case 2:
          return pieSectionData[2];
        case 3:
          return pieSectionData[3];
        case 4:
          return pieSectionData[4];
        case 5:
          return pieSectionData[5];
        case 6:
          return pieSectionData[6];
        case 7:
          return pieSectionData[7];
        case 8:
          return pieSectionData[8];
        case 9:
          return pieSectionData[9];
        case 10:
          return pieSectionData[10];
        case 11:
          return pieSectionData[11];
        default:
          throw Error();
      }
    });
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color borderColor;

  const _Badge(
    this.icon, {
    Key? key,
    required this.size,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Icon(
        icon,
        size: size * 3 / 5,
        color: ThemeData.dark().cardColor,
      ),
    );
  }
}
