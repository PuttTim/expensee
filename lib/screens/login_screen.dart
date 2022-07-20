import 'package:expensee/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../models/app_colours.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    void authenticateUser() => {
          if (_formKey.currentState!.saveAndValidate())
            {
              _formKey.currentState!.value.forEach(
                (key, value) => print('$key: $value'),
              )
            }
        };

    void authenticateWithGoogle() => {print('Google Authentication')};

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: FormBuilder(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SvgPicture.asset('assets/expensee_logo.svg'),
                  const SizedBox(height: 40),
                  FormBuilderTextField(
                    name: 'email',
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.email(),
                        FormBuilderValidators.required(),
                      ],
                    ),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email, color: AppColours.moodyPurple),
                      labelText: 'Email',
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.moodyPurple)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.moodyPurple)),
                      errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.feistyOrange)),
                      hintStyle: TextStyle(color: AppColours.moodyPurple),
                      labelStyle: TextStyle(color: AppColours.moodyPurple),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'password',
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.email(),
                        FormBuilderValidators.required(),
                      ],
                    ),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock, color: AppColours.moodyPurple),
                      labelText: 'Password',
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.moodyPurple)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.moodyPurple)),
                      errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.feistyOrange)),
                      hintStyle: TextStyle(color: AppColours.moodyPurple),
                      labelStyle: TextStyle(color: AppColours.moodyPurple),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          authenticateUser();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          primary: AppColours.moodyPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Login', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                  Row(children: const [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 48, right: 16),
                        child: Divider(
                          thickness: 2,
                          height: 20,
                          color: AppColours.blackestBlack,
                        ),
                      ),
                    ),
                    Text(
                      'OR',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, right: 48),
                        child: Divider(
                          thickness: 2,
                          height: 20,
                          color: AppColours.blackestBlack,
                        ),
                      ),
                    ),
                  ]),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          authenticateWithGoogle();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          primary: const Color.fromRGBO(245, 245, 245, 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 16),
                              child: SvgPicture.asset('assets/google_logo.svg'),
                            ),
                            const Text(
                              'Login with Google',
                              style: TextStyle(fontSize: 18, color: Color.fromRGBO(155, 155, 155, 1)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'New to Expensee?',
                        style: TextStyle(fontSize: 16, color: AppColours.moodyPurple),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 16, color: AppColours.moodyPurple, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
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
