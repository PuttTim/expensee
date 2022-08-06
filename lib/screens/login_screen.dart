import 'package:expensee/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../models/app_colours.dart';
import '../models/response.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormBuilderState>();

  bool showPassword = false;

  void authenticateUser() {
    if (_loginFormKey.currentState!.saveAndValidate()) {
      Map<String, dynamic> data = _loginFormKey.currentState!.value;
      AuthService().loginUser(email: data['email'], password: data['password']).then((res) {
        if (res.status == Status.success) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                const Icon(Icons.done, color: AppColours.emeraldGreen),
                const SizedBox(width: 16),
                Text('Welcome back, ${FirebaseAuth.instance.currentUser!.displayName}!'),
              ],
            ),
          ));
        } else if (res.status == Status.error) {
          switch (res.message) {
            case 'invalid-email':
              _loginFormKey.currentState!.invalidateField(name: 'email', errorText: 'Invalid email address');
              break;
            case 'wrong-password':
            case 'user-not-found':
              _loginFormKey.currentState!.invalidateField(name: 'password', errorText: 'Wrong username or password');
              break;
            case 'user-disabled':
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
                  children: const [
                    Icon(Icons.error, color: AppColours.feistyOrange),
                    SizedBox(width: 16),
                    Text('Your account has been disabled.'),
                  ],
                ),
              ));
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
                  children: const [
                    Icon(Icons.error, color: AppColours.feistyOrange),
                    SizedBox(width: 16),
                    Text('Something went wrong, please try again.'),
                  ],
                ),
              ));
          }
          debugPrint(res.message);
        }
      });
    }
  }

  void authenticateWithGoogle() => {print('Google Authentication')};

  void toggleShowPassword() => {setState(() => showPassword = !showPassword)};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: FormBuilder(
          key: _loginFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SvgPicture.asset('assets/expensee_logo.svg'),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'email',
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.email(errorText: 'Invalid email address'),
                      FormBuilderValidators.required(errorText: 'Email address is required'),
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
                const SizedBox(height: 8),
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
                            builder: (context) => RegisterScreen(),
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
    void resetPassword() {
      if (_forgotPasswordFieldKey.currentState!.validate()) {
        debugPrint('Password reset email: ${_forgotPasswordFieldKey.currentState!.value}');
        AuthService().resetPassword(email: _forgotPasswordFieldKey.currentState!.value).then(
          (res) {
            if (res.status == Status.success) {
              debugPrint('Password reset email sent');
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
                  children: const [
                    Icon(Icons.done, color: AppColours.emeraldGreen),
                    SizedBox(width: 16),
                    Text('Password reset sent, check your email'),
                  ],
                ),
              ));
            } else if (res.status == Status.error) {
              if (res.message == 'user-not-found') {
                _forgotPasswordFieldKey.currentState!.invalidate('Email address not found');
              } else {
                _forgotPasswordFieldKey.currentState!.invalidate('Something went wrong, please try again');
              }
            }
          },
        );
      }
    }

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
                    Text("We'll send a password reset email to your account."),
                    FormBuilderTextField(
                      name: 'forgotPasswordEmail',
                      key: _forgotPasswordFieldKey,
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(errorText: 'Email address is required'),
                          FormBuilderValidators.email(errorText: 'Email address is invalid'),
                        ],
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.grandestGrey)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.grandestGrey)),
                        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColours.feistyOrange)),
                        focusedErrorBorder:
                            UnderlineInputBorder(borderSide: BorderSide(color: AppColours.feistyOrange)),
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
                    resetPassword();
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
