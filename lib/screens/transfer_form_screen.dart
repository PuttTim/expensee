import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensee/models/app_colours.dart';
import 'package:expensee/providers/records_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../models/account.dart';
import '../models/transfer_record.dart';
import '../models/transfer_type_enum.dart';
import '../providers/accounts_provider.dart';
import '../services/firestore_service.dart';
import 'main_screen.dart';

class TransferFormScreen extends StatelessWidget {
  TransferFormScreen({Key? key, this.isEditing = false, this.record, this.index}) : super(key: key);

  bool isEditing;
  TransferRecord? record;
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
                            Provider.of<RecordsProvider>(context, listen: false).deleteRecord(index: index!);
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
            double conversionRate;

            /// Checks if the currency from and to are the same, if they are not the same,
            /// then the conversionRate is calculated by fromAmount divided by toAmount,
            /// Otherwise, the conversionRate is 1.00 (i.e SGD to SGD is 1:1
            if (_formKey.currentState!.value['fromCurrency'] != _formKey.currentState!.value['toCurrency']) {
              conversionRate = _formKey.currentState!.value['fromAmount'] / _formKey.currentState!.value['toAmount'];
            } else {
              conversionRate = 1.00;
            }

            /// Duplicates the form's data into a map and adds in the key 'conversionRate',
            /// which if the original value is null OR empty, it will become the above declared conversionRate
            Map<String, dynamic> data = {
              ..._formKey.currentState!.value,
              'conversionRate': _formKey.currentState!.value['conversionRate'] == null ||
                      _formKey.currentState!.value['conversionRate'] == ''
                  ? conversionRate
                  : double.parse(_formKey.currentState!.value['conversionRate']),
            };

            /// If the user is editing, then the record is updated,
            /// otherwise the record is created and inserted into the records list inside RecordsProvider
            if (isEditing) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit Transaction'),
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
                        Provider.of<RecordsProvider>(context, listen: false).updateRecord(
                          index: index!,
                          record: TransferRecord.fromJson(data),
                        );
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
              Provider.of<RecordsProvider>(context, listen: false).insertRecord(TransferRecord.fromJson(data));
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
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 64),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'From',
                          style: TextStyle(
                            color: AppColours.forestryGreen,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'To',
                          style: TextStyle(
                            color: AppColours.forestryGreen,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(
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
                                name: 'fromAccountId',
                                initialValue: isEditing
                                    ? record?.fromAccountId
                                    : accounts!.where((account) => account.isCurrentAccount).first.id,
                                onChanged: (value) {
                                  /// Sets the currency displayed to the current account's primary currency.
                                  _formKey.currentState!.fields['currency']?.didChange(
                                      accounts!.where((account) => account.id == value).first.primaryCurrency);
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
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(Icons.east, color: AppColours.moodyPurple),
                      ),
                      Expanded(
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
                                name: 'toAccountId',
                                initialValue: isEditing
                                    ? record?.toAccountId
                                    : accounts!.where((account) => account.isCurrentAccount).first.id,
                                onChanged: (value) {
                                  /// Sets the currency displayed to the current account's primary currency.
                                  _formKey.currentState!.fields['currency']?.didChange(
                                      accounts!.where((account) => account.id == value).first.primaryCurrency);
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
                      ),
                    ]),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: FormBuilderTextField(
                            name: 'fromAmount',
                            initialValue: isEditing ? record?.fromAmount.abs().toString() : '',
                            keyboardType: TextInputType.number,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(errorText: 'Amount is required'),
                              FormBuilderValidators.min(0, errorText: 'Invalid amount'),
                              FormBuilderValidators.numeric(errorText: 'Invalid amount'),
                            ]),
                            valueTransformer: (value) => double.parse(value!),
                            style: const TextStyle(color: AppColours.moodyPurple),
                            decoration: const InputDecoration(
                              labelText: 'From Amount',
                              hintText: '0.00',
                              hintStyle: TextStyle(color: AppColours.moodyPurple),
                              labelStyle: TextStyle(color: AppColours.moodyPurple),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColours.moodyPurple, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FormBuilderTextField(
                                enabled: false,
                                name: 'fromCurrency',
                                initialValue: isEditing
                                    ? record?.fromCurrency
                                    : Provider.of<AccountsProvider>(context, listen: true)
                                        .currentAccount
                                        .primaryCurrency,
                                style: const TextStyle(color: AppColours.moodyPurple, fontSize: 24),
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              )),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: FormBuilderTextField(
                            name: 'toAmount',
                            initialValue: isEditing ? record?.toAmount.abs().toString() : '',
                            keyboardType: TextInputType.number,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(errorText: 'Amount is required'),
                              FormBuilderValidators.min(0, errorText: 'Invalid amount'),
                              FormBuilderValidators.numeric(errorText: 'Invalid amount'),
                            ]),
                            valueTransformer: (value) => double.parse(value!),
                            style: const TextStyle(color: AppColours.moodyPurple),
                            decoration: const InputDecoration(
                              labelText: 'To Amount',
                              hintText: '0.00',
                              hintStyle: TextStyle(color: AppColours.moodyPurple),
                              labelStyle: TextStyle(color: AppColours.moodyPurple),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColours.moodyPurple, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FormBuilderTextField(
                                enabled: false,
                                name: 'toCurrency',
                                initialValue: isEditing
                                    ? record?.toCurrency
                                    : Provider.of<AccountsProvider>(context, listen: true)
                                        .currentAccount
                                        .primaryCurrency,
                                style: const TextStyle(color: AppColours.moodyPurple, fontSize: 24),
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              )),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(bottom: 0),
                      child: const Text(
                        'Transfer Type',
                        style: TextStyle(
                          color: AppColours.forestryGreen,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FormBuilderRadioGroup(
                      name: 'type',

                      /// No validator needed as we have an initialValue defined.
                      initialValue: isEditing ? record?.type : TransferType.transfer,
                      activeColor: AppColours.moodyPurple,
                      focusColor: AppColours.moodyPurple,
                      hoverColor: AppColours.moodyPurple,
                      valueTransformer: (value) => value?.toString().split('.').last,
                      options: const [
                        FormBuilderFieldOption(
                          value: TransferType.transfer,
                          child: Text(
                            'Transfer',
                            style: TextStyle(color: AppColours.moodyPurple),
                          ),
                        ),
                        FormBuilderFieldOption(
                          value: TransferType.withdraw,
                          child: Text(
                            'Withdraw',
                            style: TextStyle(color: AppColours.moodyPurple),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(bottom: 0),
                      child: const Text(
                        'Transfer Date',
                        style: TextStyle(
                          color: AppColours.forestryGreen,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(bottom: 0),
                      child: const Text(
                        'Conversion Rates',
                        style: TextStyle(
                          color: AppColours.forestryGreen,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FormBuilderTextField(
                      name: 'conversionRate',
                      initialValue: isEditing ? record?.conversionRate.toString() : '',
                      keyboardType: TextInputType.number,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.min(0, errorText: 'Invalid conversion rate'),
                        FormBuilderValidators.numeric(errorText: 'Invalid conversion rate'),
                      ]),
                      style: const TextStyle(color: AppColours.moodyPurple),
                      decoration: const InputDecoration(
                        labelText: 'Conversion Rate',
                        hintText: '1.00',
                        hintStyle: TextStyle(color: AppColours.moodyPurple),
                        labelStyle: TextStyle(color: AppColours.moodyPurple),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(bottom: 0),
                      child: const Text(
                        'Notes',
                        style: TextStyle(
                          color: AppColours.forestryGreen,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                        labelText: 'Transfer Note',
                        labelStyle: TextStyle(color: AppColours.moodyPurple),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
