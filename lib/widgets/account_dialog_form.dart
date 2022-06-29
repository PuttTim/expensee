import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../models/app_colours.dart';
import '../utilities/countrycode_to_emoji.dart';

class AccountDialogForm extends StatelessWidget {
  AccountDialogForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColours.moodyPurple,
          title: const Text(
            'Create Account',
            style: TextStyle(color: AppColours.wittyWhite, fontSize: 20),
          ),
          leadingWidth: 90,
          leading: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColours.wittyWhite, fontSize: 20),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // if (_formKey.currentState!.isValid) {
                //   _formKey.currentState!.value.forEach((key, value) {
                //     debugPrint('$key: $value');
                //   });
                //   debugPrint();
                //   Navigator.pop(context);
                // }
              },
              child: const Text(
                'Create',
                style: TextStyle(color: AppColours.wittyWhite, fontSize: 20),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 64, right: 8, left: 8),
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
                    name: 'currency',
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
                    // initialValue: isEditing ? record?.payee : '',
                    style: const TextStyle(color: AppColours.moodyPurple),
                    validator: FormBuilderValidators.compose([
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
      ),
    );
  }
}
