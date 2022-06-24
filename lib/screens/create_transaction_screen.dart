import 'package:expensee/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../models/app_colours.dart';
import '../models/transaction_type_enum.dart';

class CreateTransactionScreen extends StatelessWidget {
  CreateTransactionScreen({Key? key}) : super(key: key);

  OutlineInputBorder borderTheme = const OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColours.moodyPurple,
      width: 2,
    ),
  );

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.saveAndValidate()) {
            print(_formKey.currentState!.value);
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.done, color: AppColours.wittyWhite),
      ),
      // SingleChildScrollView allows the Keyboard when opened up, to not overflow the entire screen.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, right: 8, left: 8),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Transaction Type',
                    style: TextStyle(
                      color: AppColours.forestryGreen,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                FormBuilderRadioGroup(
                  activeColor: AppColours.moodyPurple,
                  focusColor: AppColours.moodyPurple,
                  decoration: InputDecoration(border: InputBorder.none),
                  name: 'type',
                  options: const [
                    FormBuilderFieldOption(
                      value: TransactionType.cash,
                      child: Text(
                        'Cash',
                        style: TextStyle(color: AppColours.moodyPurple),
                      ),
                    ),
                    FormBuilderFieldOption(
                      value: TransactionType.cashless,
                      child: Text(
                        'Cashless',
                        style: TextStyle(color: AppColours.moodyPurple),
                      ),
                    ),
                    FormBuilderFieldOption(
                        value: TransactionType.online,
                        child: Text(
                          'Online',
                          style: TextStyle(color: AppColours.moodyPurple),
                        )),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Payee',
                    style: TextStyle(
                      color: AppColours.forestryGreen,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                FormBuilderTextField(
                  name: 'payee',
                  decoration: InputDecoration(
                    enabledBorder: borderTheme,
                    focusedBorder: borderTheme,
                    labelText: 'Name',
                    labelStyle: TextStyle(color: AppColours.moodyPurple),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: const Text(
                    'Category',
                    style: TextStyle(
                      color: AppColours.forestryGreen,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                FormBuilderDropdown(
                  name: 'category',
                  decoration: InputDecoration(
                      enabledBorder: borderTheme, focusedBorder: borderTheme),
                  initialValue: Category.food,
                  items: categories
                      .map((category) => DropdownMenuItem(
                            value: category['category'],
                            child: Wrap(children: [
                              Icon(
                                category['icon'],
                                color: AppColours.moodyPurple,
                              ),
                              SizedBox(width: 16),
                              Text(
                                category['name'],
                                style: const TextStyle(
                                    color: AppColours.moodyPurple),
                              )
                            ]),
                          ))
                      .toList(),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: const Text(
                    'Time of Transaction',
                    style: TextStyle(
                      color: AppColours.forestryGreen,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                FormBuilderDateTimePicker(
                  name: 'time',
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.calendar_month,
                      color: AppColours.moodyPurple,
                    ),
                    labelText: 'Date and Time',
                    labelStyle: const TextStyle(color: AppColours.moodyPurple),
                    enabledBorder: borderTheme,
                    focusedBorder: borderTheme,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: const Text(
                    'Note',
                    style: TextStyle(
                      color: AppColours.forestryGreen,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                FormBuilderTextField(
                  name: 'note',
                  decoration: InputDecoration(
                    enabledBorder: borderTheme,
                    focusedBorder: borderTheme,
                    labelText: 'Transaction Note',
                    labelStyle: TextStyle(color: AppColours.moodyPurple),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
