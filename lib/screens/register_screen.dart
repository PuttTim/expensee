import 'package:expensee/models/app_colours.dart';
import 'package:expensee/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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
      AuthService()
          .registerUser(
        _formKey.currentState!.value['username'] as String,
        _formKey.currentState!.value['email'] as String,
        _formKey.currentState!.value['password'] as String,
      )
          .then((value) {
        if (value == 'Success') {
          Navigator.pop(context);
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(value),
              actions: [
                FlatButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        }
      });
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
                      FormBuilderValidators.required(),
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
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
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
                      FormBuilderValidators.required(),
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
                            builder: (context) => RegisterScreen(),
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
