import 'package:blogapp/src/core/theme/color_theme.dart';
import 'package:blogapp/src/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter/material.dart';

import '../widgets/auth/auth.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    formKey.currentState?.validate();
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign In.',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            AuthField(hinTex: 'Email', controller: emailController),
            const SizedBox(height: 15),
            AuthField(
              hinTex: 'Password',
              controller: passwordController,
              isObscureText: true,
            ),
            const SizedBox(height: 30),
            const AuthButton(
              buttonText: 'Sign In',
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.push(context, SignUpPage.route()),
              child: RichText(
                text: TextSpan(
                  text: "Already have an account?",
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: ' Sign Up',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
