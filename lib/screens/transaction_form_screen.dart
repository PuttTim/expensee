import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensee/models/category.dart';
import 'package:expensee/models/transaction_type_enum.dart';
import 'package:expensee/providers/accounts_provider.dart';
import 'package:expensee/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';

import '../models/account.dart';
import '../models/app_colours.dart';
import '../models/transaction_record.dart';
import '../utilities/countrycode_to_emoji.dart';
import 'main_screen.dart';

class TransactionFormScreen extends StatelessWidget {
  TransactionFormScreen({Key? key, this.isEditing = false, this.record, this.index}) : super(key: key);

  bool isEditing;
  TransactionRecord? record;
  int? index;

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Checks if the user is editing a record or creating a new one.
      /// If the user is editing, then they have the option to delete the record.
      appBar: isEditing
          ? AppBar(
              title: const Text('Edit Transaction'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Transaction'),
                      content: const Text('Are you sure you want to delete this transaction?'),
                      actions: [
                        TextButton(
                          child: const Text('CANCEL'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('DELETE'),
                          onPressed: () {
                            FirestoreService().deleteRecord(record);
                            FirestoreService().modifyAccountValueByRecordDelete(record!.accountId, record!.amount);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : null,

      /// The FAB changes Icons depending on whether the user is editing or creating a new record.
      floatingActionButton: FloatingActionButton(
        child: Icon(isEditing ? Icons.save_rounded : Icons.done, color: AppColours.wittyWhite),
        onPressed: () {
          /// Checks if all form states are saved and validated.
          if (_formKey.currentState!.saveAndValidate()) {
            /// Duplicates the form's data into a map and adds in the key 'amount',
            /// which has an appropriate value for whether or not the amount is positive.
            Map<String, dynamic> data = {
              ..._formKey.currentState!.value,
              'amount': _formKey.currentState!.value['isPositive']
                  ? _formKey.currentState!.value['amount']
                  : (-_formKey.currentState!.value['amount']),
              'recordType': 'transaction',
            };

            /// If the user is editing, then the record is updated,
            /// otherwise the record is created and inserted into the records list inside RecordsProvider
            if (isEditing) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Save Transaction'),
                  content: const Text('Are you sure you want to update this transaction?'),
                  actions: [
                    TextButton(
                      child: const Text('CANCEL'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('SAVE'),
                      onPressed: () {
                        FirestoreService().updateRecord(TransactionRecord.fromJson({...data, 'docId': record!.docId}));
                        FirestoreService()
                            .modifyAccountValueByRecordUpdate(record!.accountId, record!.amount, data['amount']);
                        // FirestoreService().modifyAccountValue(data['accountId'], data['amount']);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              FirestoreService().insertRecord(TransactionRecord.fromJson(data));

              FirestoreService().modifyAccountValue(data['accountId'], data['amount']);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
                (route) => false,
              );
            }
          }
        },
      ),

      /// SingleChildScrollView allows the Keyboard when opened up, to not overflow the entire screen.
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
                        child: StreamBuilder(
                            stream: FirestoreService().fetchAccountsStream(),
                            builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
                              List<Account>? accounts = snapshot.data;

                              if (snapshot.hasError) {
                                return const Text('Something went wrong, please connect to the internet');
                              }
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text("Loading");
                              }

                              return FormBuilderDropdown(
                                name: 'currency',
                                enabled: false,
                                initialValue: isEditing
                                    ? record?.currency
                                    : accounts?.where((account) => account.isCurrentAccount).first.primaryCurrency,
                                style: const TextStyle(
                                    color: AppColours.moodyPurple, fontSize: 24, fontWeight: FontWeight.w500),
                                items: ['EUR', 'SGD', 'THB', 'USD']
                                    .map((currency) => DropdownMenuItem(
                                          value: currency,
                                          child: Text('${countryToEmoji(currency)} $currency'),
                                        ))
                                    .toList(),
                              );
                            }),
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
                        'Account',
                        style: TextStyle(
                          color: AppColours.forestryGreen,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    StreamBuilder(
                        stream: FirestoreService().fetchAccountsStream(),
                        builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
                          List<Account>? accounts = snapshot.data;

                          if (snapshot.hasError) {
                            return const Text('Something went wrong, please connect to the internet');
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text("Loading");
                          }

                          return FormBuilderDropdown(
                            name: 'accountId',
                            initialValue: isEditing
                                ? record?.accountId
                                : accounts!.where((account) => account.isCurrentAccount).first.id,
                            onChanged: (value) {
                              /// Sets the currency displayed to the current account's primary currency.
                              _formKey.currentState!.fields['currency']
                                  ?.didChange(accounts!.where((account) => account.id == value).first.primaryCurrency);
                            },
                            style: const TextStyle(
                                color: AppColours.moodyPurple, fontSize: 16, fontWeight: FontWeight.w500),
                            items: accounts!
                                .map((account) => DropdownMenuItem(
                                      value: account.id,
                                      child: Text(account.name),
                                    ))
                                .toList(),
                          );
                        }),
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

                      /// No validator is required here as there is an initialValue set to Category.food
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
                      valueTransformer: (date) => Timestamp.fromDate(date!),
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
