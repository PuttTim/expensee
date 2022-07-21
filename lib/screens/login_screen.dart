import 'package:expensee/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../models/app_colours.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final _loginFormKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    void authenticateUser() => {
          if (_loginFormKey.currentState!.saveAndValidate())
            {
              _loginFormKey.currentState!.value.forEach(
                (key, value) => print('$key: $value'),
              )
            }
        };

    void authenticateWithGoogle() => {print('Google Authentication')};

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: FormBuilder(
          key: _loginFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/expensee_logo.svg'),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'email',
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.email(),
                      FormBuilderValidators.required(),
                    ],
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    icon: Icon(Icons.alternate_email, color: AppColours.grandestGrey),
                    labelText: 'Email',
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.grandestGrey)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.grandestGrey)),
                    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.feistyOrange)),
                    hintStyle: TextStyle(color: AppColours.grandestGrey),
                    labelStyle: TextStyle(color: AppColours.grandestGrey),
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
                    isDense: true,
                    icon: Icon(Icons.lock, color: AppColours.grandestGrey),
                    labelText: 'Password',
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.grandestGrey)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.grandestGrey)),
                    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.feistyOrange)),
                    hintStyle: TextStyle(color: AppColours.grandestGrey),
                    labelStyle: TextStyle(color: AppColours.grandestGrey),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ForgotPasswordDialog(),
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
                const SizedBox(height: 8),
                Row(children: const [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 48, right: 16),
                      child: Divider(
                        thickness: 2,
                        height: 20,
                        color: AppColours.grandestGrey,
                      ),
                    ),
                  ),
                  Text(
                    'or',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColours.grandestGrey),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 48),
                      child: Divider(
                        thickness: 2,
                        height: 20,
                        color: AppColours.grandestGrey,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 8),
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
    );
  }
}

class ForgotPasswordDialog extends StatelessWidget {
  ForgotPasswordDialog({
    Key? key,
  }) : super(key: key);

  final _forgotPasswordFieldKey = GlobalKey<FormBuilderFieldState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Forgot Password?'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'forgotPasswordEmail',
                      key: _forgotPasswordFieldKey,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.grandestGrey)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.grandestGrey)),
                        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.feistyOrange)),
                        hintStyle: TextStyle(color: AppColours.grandestGrey),
                        labelStyle: TextStyle(color: AppColours.grandestGrey),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('SUBMIT'),
                  onPressed: () {
                    print(_forgotPasswordFieldKey.currentState!.value);
                  },
                )
              ],
            ),
          );
        },
        child: const Text(
          'Forgot password?',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 16, color: AppColours.moodyPurple),
        ),
      ),
    );
  }
}
