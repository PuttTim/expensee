import 'package:expensee/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:group_button/group_button.dart';

import '../models/app_colours.dart';
import '../models/transaction_type_enum.dart';

class CreateTransactionScreen extends StatelessWidget {
  CreateTransactionScreen({Key? key}) : super(key: key);

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
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              Material(
                elevation: 8,
                child: Row(
                  children: [
                    FormBuilderField(
                      name: 'isPositive',
                      initialValue: true,
                      builder: (FormFieldState<dynamic> field) {
                        return GroupButton(
                          controller: GroupButtonController(selectedIndex: 0),
                          onSelected: (_, index, isSelected) {
                            print('${index}');
                            print('${index == 0 ? true : false}');
                            index == 0
                                ? field.didChange(true)
                                : field.didChange(false);
                          },
                          buttons: const ['+', '-'],
                          options: const GroupButtonOptions(
                              direction: Axis.vertical,
                              spacing: 0,
                              buttonHeight: 50,
                              unselectedBorderColor: AppColours.paleMoodyPurple,
                              selectedBorderColor: AppColours.moodyPurple,
                              selectedColor: AppColours.moodyPurple,
                              selectedTextStyle: TextStyle(
                                  color: AppColours.wittyWhite, fontSize: 32),
                              unselectedTextStyle: TextStyle(
                                  color: AppColours.paleMoodyPurple,
                                  fontSize: 32)),
                        );
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 256, right: 8, left: 8),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
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
                      name: 'type',
                      activeColor: AppColours.moodyPurple,
                      focusColor: AppColours.moodyPurple,
                      hoverColor: AppColours.moodyPurple,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Transaction Type is required')
                      ]),
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
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
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
                      style: const TextStyle(color: AppColours.moodyPurple),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Payee is required'),
                        FormBuilderValidators.minLength(
                          1,
                          errorText: 'Payee must be at least 1 character long',
                        ),
                        FormBuilderValidators.maxLength(
                          19,
                          errorText: 'Payee must be less than 20 characters',
                        ),
                      ]),
                      decoration: InputDecoration(
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
                      // No validator is required here as there is an initialValue set to Category.food
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
                      style: const TextStyle(color: AppColours.moodyPurple),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.calendar_month,
                          color: AppColours.moodyPurple,
                        ),
                        labelText: 'Date and Time',
                        labelStyle:
                            const TextStyle(color: AppColours.moodyPurple),
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
                      style: const TextStyle(color: AppColours.moodyPurple),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.maxLength(
                          199,
                          errorText: 'Note must be less than 200 characters',
                        ),
                      ]),
                      decoration: InputDecoration(
                        counterText: '/200',
                        labelText: 'Transaction Note',
                        labelStyle: TextStyle(color: AppColours.moodyPurple),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
