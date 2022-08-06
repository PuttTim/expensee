import 'dart:async';

import 'package:expensee/models/app_colours.dart';
import 'package:expensee/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../models/response.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool showPassword = false;

  void registerUser() {
    if (_formKey.currentState!.saveAndValidate()) {
      Map<String, dynamic> data = _formKey.currentState!.value;
      AuthService()
          .registerUser(username: data['username'], email: data['email'], password: data['password'])
          .then((res) {
        if (res.status == Status.success) {
          debugPrint('success');

          AuthService().verifyEmail(email: data['email']);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: const [
                Icon(Icons.done, color: AppColours.emeraldGreen),
                SizedBox(width: 16),
                Text('Please check your email to verify your account.'),
              ],
            ),
          ));

          FocusScope.of(context).requestFocus(FocusNode());

          Timer(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          });
        } else if (res.status == Status.error) {
          debugPrint("error msg: ${res.message}");
          switch (res.message) {
            case 'email-already-in-use':
              _formKey.currentState!.invalidateField(name: 'email', errorText: 'Email already in use');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Invalid email'),
              ));
              break;
            case 'invalid-email':
              _formKey.currentState!.invalidateField(name: 'email', errorText: 'Invalid email');
              break;
            case 'weak-password':
              _formKey.currentState!.invalidateField(name: 'password', errorText: 'Password is too weak');
              break;
            default:
              debugPrint('Unknown error');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
                  children: const [
                    Icon(Icons.error, color: AppColours.feistyOrange),
                    SizedBox(width: 16),
                    Text('Something went wrong, please try again.'),
                  ],
                ),
              ));
              FocusScope.of(context).requestFocus(FocusNode());
          }
          // _formKey.currentState!.invalidateField(name: 'email', errorText: 'Email already exists');
        }
      });
      // _formKey.currentState!.value.forEach((key, value) {
      //   print('${value} ${value.runtimeType}');
      // });
    }
  }

  void toggleShowPassword() => {setState(() => showPassword = !showPassword)};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SvgPicture.asset('assets/expensee_logo.svg'),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'username',
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(errorText: 'Username is required'),
                    ],
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    icon: Icon(Icons.badge, color: AppColours.grandestGrey),
                    labelText: 'Username',
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.grandestGrey)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.grandestGrey)),
                    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.feistyOrange)),
                    focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.feistyOrange)),
                    hintStyle: TextStyle(color: AppColours.grandestGrey),
                    labelStyle: TextStyle(color: AppColours.grandestGrey),
                  ),
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'email',
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(errorText: 'Email address is required'),
                      FormBuilderValidators.email(errorText: 'Invalid email address'),
                    ],
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    icon: Icon(Icons.alternate_email, color: AppColours.grandestGrey),
                    labelText: 'Email',
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.grandestGrey)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.grandestGrey)),
                    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.feistyOrange)),
                    focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.feistyOrange)),
                    hintStyle: TextStyle(color: AppColours.grandestGrey),
                    labelStyle: TextStyle(color: AppColours.grandestGrey),
                  ),
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'password',
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(errorText: 'Password is required'),
                    ],
                  ),
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    isDense: true,
                    icon: const Icon(Icons.lock, color: AppColours.grandestGrey),
                    suffixIcon: IconButton(
                        onPressed: () {
                          toggleShowPassword();
                        },
                        // All icon buttons should show what clicking the button will do
                        // (i.e clicking on an eye open will show the password)
                        icon: showPassword
                            ? const Icon(Icons.visibility_off, color: AppColours.grandestGrey)
                            : const Icon(Icons.remove_red_eye, color: AppColours.grandestGrey)),
                    labelText: 'Password',
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColours.grandestGrey)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColours.grandestGrey)),
                    errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColours.feistyOrange)),
                    focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.feistyOrange)),
                    hintStyle: const TextStyle(color: AppColours.grandestGrey),
                    labelStyle: const TextStyle(color: AppColours.grandestGrey),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        registerUser();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        primary: AppColours.moodyPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Register', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 16, color: AppColours.moodyPurple),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login here!',
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
