import 'package:expensee/models/category.dart';
import 'package:expensee/models/transaction_type_enum.dart';
import 'package:expensee/providers/currencies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';

import '../models/app_colours.dart';
import '../models/transaction_record.dart';
import '../providers/records_provider.dart';
import '../utilities/countrycode_to_emoji.dart';

class TransactionFormScreen extends StatelessWidget {
  TransactionFormScreen({Key? key, this.isEditing = false, this.record, this.index}) : super(key: key);

  bool isEditing;
  TransactionRecord? record;
  int? index;

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isEditing
          ? AppBar(
              title: Text(isEditing ? 'Edit Transaction' : 'New Transaction'),
              actions: [
                IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete, color: AppColours.wittyWhite),
                  onPressed: () => null,
                )
              ],
            )
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.saveAndValidate()) {
            Map<String, dynamic> data = {
              ..._formKey.currentState!.value,
              'amount': _formKey.currentState!.value['isPositive']
                  ? _formKey.currentState!.value['amount']
                  : (-_formKey.currentState!.value['amount']),
            };

            //
            if (isEditing) {
              Provider.of<RecordsProvider>(context, listen: false).updateRecord(
                index: index!,
                record: TransactionRecord.fromJson(data),
              );
            } else {
              Provider.of<RecordsProvider>(context, listen: false).insertRecord(
                TransactionRecord.fromJson(data),
              );
            }
            Navigator.pop(context);
          }
        },
        child: Icon(isEditing ? Icons.save_rounded : Icons.done, color: AppColours.wittyWhite),
      ),
      // SingleChildScrollView allows the Keyboard when opened up, to not overflow the entire screen.
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              Material(
                elevation: 2,
                child: Row(
                  children: [
                    Expanded(
                      flex: 0,
                      child: FormBuilderField(
                        name: 'isPositive',
                        initialValue: isEditing ? record?.isPositive : false,
                        builder: (FormFieldState<dynamic> field) {
                          return GroupButton(
                            controller: GroupButtonController(selectedIndex: field.value ? 1 : 0),
                            onSelected: (_, index, isSelected) {
                              index == 1 ? field.didChange(true) : field.didChange(false);
                              debugPrint(index.toString());
                            },
                            buttons: const ['-', '+'],
                            options: const GroupButtonOptions(
                                direction: Axis.vertical,
                                spacing: 0,
                                buttonHeight: 60,
                                unselectedBorderColor: AppColours.paleMoodyPurple,
                                selectedBorderColor: AppColours.moodyPurple,
                                selectedColor: AppColours.moodyPurple,
                                selectedTextStyle: TextStyle(color: AppColours.wittyWhite, fontSize: 32),
                                unselectedTextStyle: TextStyle(color: AppColours.paleMoodyPurple, fontSize: 32)),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: FormBuilderTextField(
                          name: 'amount',
                          initialValue: isEditing ? record?.amount.abs().toString() : '',
                          keyboardType: TextInputType.number,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(errorText: 'Amount is required'),
                            FormBuilderValidators.min(0, errorText: 'Invalid amount'),
                            FormBuilderValidators.numeric(errorText: 'Invalid amount'),
                          ]),
                          valueTransformer: (value) => double.parse(value!),
                          style: const TextStyle(
                              color: AppColours.forestryGreen, fontSize: 24, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            hintText: '0.00',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            floatingLabelStyle:
                                TextStyle(color: AppColours.forestryGreen, fontSize: 16, fontWeight: FontWeight.bold),
                            hintStyle:
                                TextStyle(color: AppColours.forestryGreen, fontSize: 24, fontWeight: FontWeight.bold),
                            labelStyle:
                                TextStyle(color: AppColours.forestryGreen, fontSize: 16, fontWeight: FontWeight.bold),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: FormBuilderDropdown(
                          name: 'currency',
                          initialValue: isEditing
                              ? record?.currency
                              : Provider.of<CurrenciesProvider>(context, listen: false).primaryCurrency,
                          style:
                              const TextStyle(color: AppColours.moodyPurple, fontSize: 24, fontWeight: FontWeight.w500),
                          items: ['EUR', 'SGD', 'THB', 'USD']
                              .map((currency) => DropdownMenuItem(
                                    value: currency,
                                    child: Text('${countryToEmoji(currency)} $currency'),
                                  ))
                              .toList(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 64, right: 8, left: 8),
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
                      initialValue: isEditing ? record?.type : '',
                      activeColor: AppColours.moodyPurple,
                      focusColor: AppColours.moodyPurple,
                      hoverColor: AppColours.moodyPurple,
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required(errorText: 'Transaction Type is required')]),
                      valueTransformer: (value) => value?.toString().split('.').last,
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
                      initialValue: isEditing ? record?.payee : '',
                      style: const TextStyle(color: AppColours.moodyPurple),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'Payee is required'),
                        FormBuilderValidators.minLength(
                          1,
                          errorText: 'Payee must be at least 1 character long',
                        ),
                        FormBuilderValidators.maxLength(
                          19,
                          errorText: 'Payee must be less than 20 characters',
                        ),
                      ]),
                      decoration: const InputDecoration(
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
                      initialValue: isEditing ? record?.category : Category.food,
                      // No validator is required here as there is an initialValue set to Category.food
                      valueTransformer: (value) => value?.toString().split('.').last,
                      items: categories
                          .map((category) => DropdownMenuItem(
                                value: category['category'],
                                child: Wrap(children: [
                                  Icon(
                                    category['icon'],
                                    color: AppColours.moodyPurple,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    category['name'],
                                    style: const TextStyle(color: AppColours.moodyPurple),
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
                      initialValue: isEditing ? record?.time : DateTime.now(),
                      style: const TextStyle(color: AppColours.moodyPurple),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      valueTransformer: (date) => date?.toIso8601String(),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.calendar_month,
                          color: AppColours.moodyPurple,
                        ),
                        labelText: 'Date and Time',
                        labelStyle: TextStyle(color: AppColours.moodyPurple),
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
                      initialValue: isEditing ? record?.note : '',
                      style: const TextStyle(color: AppColours.moodyPurple),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.maxLength(
                          199,
                          errorText: 'Note must be less than 200 characters',
                        ),
                      ]),
                      decoration: const InputDecoration(
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
