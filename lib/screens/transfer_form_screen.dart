import 'package:expensee/models/app_colours.dart';
import 'package:expensee/providers/records_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../models/transfer_record.dart';
import '../models/transfer_type_enum.dart';
import '../providers/accounts_provider.dart';

class TransferFormScreen extends StatelessWidget {
  TransferFormScreen({Key? key, this.isEditing = false, this.record, this.index}) : super(key: key);

  bool isEditing;
  TransferRecord? record;
  int? index;

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.saveAndValidate()) {
              double conversionRate;
              if (_formKey.currentState!.value['fromCurrency'] != _formKey.currentState!.value['toCurrency']) {
                conversionRate = _formKey.currentState!.value['fromAmount'] / _formKey.currentState!.value['toAmount'];
              } else {
                conversionRate = 0.00;
              }
              // debugPrint(conversionRate.toString());

              // debugPrint(_formKey.currentState!.value['conversionRate'].runtimeType.toString());
              // debugPrint(_formKey.currentState!.value['conversionRate']);

              Map<String, dynamic> data = {
                ..._formKey.currentState!.value,
                'conversionRate': _formKey.currentState!.value['conversionRate'] == null ||
                        _formKey.currentState!.value['conversionRate'] == ''
                    ? conversionRate
                    : double.parse(_formKey.currentState!.value['conversionRate']),
              };

              Provider.of<RecordsProvider>(context, listen: false).insertRecord(TransferRecord.fromJson(data));
              Navigator.of(context).pop();
              // data.forEach((key, value) {
              //   debugPrint('$key: $value');
              // });
            }
          },
        ),
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
                          child: FormBuilderDropdown(
                            name: 'fromAccountId',
                            initialValue: Provider.of<AccountsProvider>(context, listen: true).currentAccount.id,
                            onChanged: (value) {
                              // Sets the currency displayed to the current account's primary currency.
                              _formKey.currentState!.fields['fromCurrency']?.didChange(
                                  Provider.of<AccountsProvider>(context, listen: false)
                                      .fetchAccount(value.toString())
                                      .primaryCurrency);
                            },
                            style: const TextStyle(
                                color: AppColours.moodyPurple, fontSize: 16, fontWeight: FontWeight.w500),
                            items: Provider.of<AccountsProvider>(context, listen: false)
                                .accounts
                                .map((account) => DropdownMenuItem(
                                      value: account.id,
                                      child: Text(account.name),
                                    ))
                                .toList(),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(Icons.east, color: AppColours.moodyPurple),
                        ),
                        Expanded(
                          child: FormBuilderDropdown(
                            name: 'toAccountId',
                            initialValue: Provider.of<AccountsProvider>(context, listen: true).currentAccount.id,
                            onChanged: (value) {
                              // Sets the currency displayed to the current account's primary currency.
                              _formKey.currentState!.fields['toCurrency']?.didChange(
                                  Provider.of<AccountsProvider>(context, listen: false)
                                      .fetchAccount(value.toString())
                                      .primaryCurrency);
                            },
                            style: const TextStyle(
                                color: AppColours.moodyPurple, fontSize: 16, fontWeight: FontWeight.w500),
                            items: Provider.of<AccountsProvider>(context, listen: false)
                                .accounts
                                .map(
                                  (account) => DropdownMenuItem(
                                    value: account.id,
                                    child: Text(account.name),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: FormBuilderTextField(
                              name: 'fromAmount',
                              // initialValue: isEditing ? record?.amount.abs().toString() : '',
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
                                  initialValue: Provider.of<AccountsProvider>(context, listen: true)
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
                              // initialValue: isEditing ? record?.amount.abs().toString() : '',
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
                                  initialValue: Provider.of<AccountsProvider>(context, listen: true)
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
                        initialValue: TransferType.transfer,
                        activeColor: AppColours.moodyPurple,
                        focusColor: AppColours.moodyPurple,
                        hoverColor: AppColours.moodyPurple,
                        // No validator needed as we have an initialValue defined.
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
                        initialValue: DateTime.now(),
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
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          // FormBuilderValidators.required(errorText: 'Conversion rate is required'),
                          FormBuilderValidators.min(0, errorText: 'Invalid conversion rate'),
                          FormBuilderValidators.numeric(errorText: 'Invalid conversion rate'),
                        ]),
                        style: const TextStyle(color: AppColours.moodyPurple),
                        decoration: const InputDecoration(
                          labelText: 'Conversion Rate',
                          hintText: '0.00',
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
                        // initialValue: isEditing ? record?.note : '',
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
        ));
  }
}
