import 'package:blogapp/src/core/theme/color_theme.dart';
import 'package:blogapp/src/features/auth/presentation/pages/pages.dart';
import 'package:flutter/material.dart';

import '../widgets/auth/auth.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    formKey.currentState?.validate();
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up.',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                AuthField(hinTex: 'Username', controller: usernameController),
                const SizedBox(height: 15),
                AuthField(hinTex: 'Email', controller: emailController),
                const SizedBox(height: 15),
                AuthField(
                  hinTex: 'Password',
                  controller: passwordController,
                  isObscureText: true,
                ),
                const SizedBox(height: 30),
                const AuthButton(
                  buttonText: 'Sign Up',
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacement(context, LoginPage.route()),
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account?",
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                          text: ' Sign In',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: ColorTheme.gradient2,
                                  ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
