import 'package:book_keeper/db/transactions_database.dart';
import 'package:book_keeper/model/transactions.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:book_keeper/components/reusable_card.dart';
import 'package:book_keeper/constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/services.dart';

SpeedDialChild inputBottomSheet({
  required BuildContext context,
  required bool income,
  required String label,
  required Icon icon,
  required List categoryLabels,
  required List categoryIcons,
  required Function refreshTransactions,
}) {
  int? amountInput;
  String? descriptionInput;
  String? selectedCategory;
  return SpeedDialChild(
    label: label,
    child: icon,
    onTap: () => showBarModalBottomSheet(
      context: context,
      builder: (context) {
        List<Widget> buildRow(int num, Function setModalState) {
          List<Widget> toReturn = [];
          for (var i = 0; i < 3; i++) {
            toReturn.add(
              Expanded(
                child: ReusableCard(
                  category: categoryLabels[(3 * num) + i],
                  selectedCategory: selectedCategory,
                  icon: categoryIcons[(3 * num) + i],
                  onPress: () {
                    setModalState(
                      () {
                        selectedCategory = categoryLabels[(3 * num) + i];
                      },
                    );
                  },
                ),
              ),
            );
          }
          return toReturn;
        }

        List<Widget> buildColumn(Function setModalState) {
          List<Widget> toReturn = [];
          for (var i = 0; i < 4; i++) {
            toReturn.add(
              Expanded(
                child: Row(
                  children: buildRow(i, setModalState),
                ),
              ),
            );
          }
          return toReturn;
        }

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () async {
                  if (selectedCategory == null ||
                      amountInput == null ||
                      amountInput! <= 0) {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.warning,
                      text: 'Please provide valid information!',
                    );
                  } else {
                    final transaction = Transactions(
                      category: selectedCategory!,
                      description: descriptionInput ?? 'Not Specified',
                      amount: amountInput!,
                      createdTime: DateTime.now(),
                      income: income,
                    );

                    await TransactionsDatabase.instance.create(transaction);
                    refreshTransactions(null);
                    Navigator.pop(context);
                  }
                },
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      color: Theme.of(context).secondaryHeaderColor,
                      height: 70,
                      child: Center(
                        child: Text(
                          label,
                          style: kLabelStyle,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0),
                      child: TextField(
                        onChanged: (input) {
                          try {
                            amountInput = int.parse(input);
                          } catch (e) {
                            amountInput = 0;
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          icon: Icon(
                            IconData(
                              0x20B9,
                              fontFamily: 'MaterialIcons',
                            ),
                          ),
                          hintText: 'Enter Amount',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0),
                      child: TextField(
                        onChanged: (input) {
                          if (input == '') {
                            descriptionInput = 'Not Specified';
                          } else {
                            descriptionInput = input;
                          }
                        },
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        maxLength: 20,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.subject,
                          ),
                          hintText: 'Short Description',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 70,
                      child: const Center(
                        child: Text(
                          'Select A Category',
                          style: kLabelStyle,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        bottom: 85.0,
                      ),
                      height: 350,
                      child: Column(
                        children: buildColumn(setModalState),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
