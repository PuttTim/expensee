import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../models/account.dart';
import '../models/app_colours.dart';
import '../providers/accounts_provider.dart';
import '../utilities/countrycode_to_emoji.dart';

class AccountDialogForm extends StatelessWidget {
  AccountDialogForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Create an account',
        style: TextStyle(color: AppColours.forestryGreen),
      ),
      actions: [
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('CREATE'),
          onPressed: () {
            if (_formKey.currentState!.saveAndValidate()) {
              Map<String, dynamic> data = {
                ..._formKey.currentState!.value,
                'id': (Provider.of<AccountsProvider>(context, listen: false).accounts.length + 1).toString(),
              };

              Provider.of<AccountsProvider>(context, listen: false).addAccount(
                Account.fromJson(data),
              );
              Navigator.pop(context);
            }
            // Navigator.pop(context);
          },
        ),
      ],
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        // height: MediaQuery.of(context).size.height * 0.6,
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: const Text(
                    'Account Name',
                    style: TextStyle(
                      color: AppColours.forestryGreen,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                FormBuilderTextField(
                  name: 'name',
                  // initialValue: isEditing ? record?.payee : '',
                  style: const TextStyle(color: AppColours.moodyPurple),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Account name is required'),
                    FormBuilderValidators.minLength(
                      1,
                      errorText: 'Account name must be at least 1 character long',
                    ),
                    FormBuilderValidators.maxLength(
                      19,
                      errorText: 'Account name must be less than 20 characters',
                    ),
                  ]),
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Account name...',
                    labelStyle: TextStyle(color: AppColours.moodyPurple),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: const Text(
                    'Current Value',
                    style: TextStyle(
                      color: AppColours.forestryGreen,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                FormBuilderTextField(
                  name: 'value',
                  keyboardType: TextInputType.number,
                  valueTransformer: (value) => double.parse(value!),

                  // initialValue: isEditing ? record?.payee : '',
                  style: const TextStyle(color: AppColours.moodyPurple),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Amount is required'),
                    FormBuilderValidators.min(0, errorText: 'Invalid amount'),
                    FormBuilderValidators.numeric(errorText: 'Invalid amount'),
                  ]),
                  decoration: const InputDecoration(
                    labelText: 'Value',
                    hintText: 'Current value...',
                    labelStyle: TextStyle(color: AppColours.moodyPurple),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: const Text(
                    'Primary Currency',
                    style: TextStyle(
                      color: AppColours.forestryGreen,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                FormBuilderDropdown(
                  name: 'primaryCurrency',
                  // initialValue: isEditing
                  //     ? record?.currency
                  //     : Provider.of<CurrenciesProvider>(context, listen: false).primaryCurrency,
                  style: const TextStyle(color: AppColours.moodyPurple, fontSize: 24, fontWeight: FontWeight.w500),
                  items: ['EUR', 'SGD', 'THB', 'USD']
                      .map((currency) => DropdownMenuItem(
                            value: currency,
                            child: Text('${countryToEmoji(currency)} $currency'),
                          ))
                      .toList(),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: const Text(
                    'Budget Limit',
                    style: TextStyle(
                      color: AppColours.forestryGreen,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                FormBuilderTextField(
                  name: 'budgetLimit',
                  keyboardType: TextInputType.number,
                  valueTransformer: (value) => double.parse(value!),
                  // initialValue: isEditing ? record?.payee : '',
                  style: const TextStyle(color: AppColours.moodyPurple),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Amount is required'),
                    FormBuilderValidators.min(0, errorText: 'Invalid amount'),
                    FormBuilderValidators.numeric(errorText: 'Invalid amount'),
                  ]),
                  decoration: const InputDecoration(
                    labelText: 'Budget Limit',
                    hintText: 'Budget limit...',
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
