import 'package:blogapp/src/core/common/widgets/loader.dart';
import 'package:blogapp/src/core/theme/color_theme.dart';
import 'package:blogapp/src/core/utils/show_snackbar.dart';
import 'package:blogapp/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogapp/src/features/auth/presentation/pages/signup_page.dart';
import 'package:blogapp/src/features/blog/presentation/page/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/auth/auth.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showSnackBar(context, state.message);
              } else if (state is AuthSuccess) {
                Navigator.pushAndRemoveUntil(
                    context, BlogListPage.route(), (route) => false);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const Center(child: Loader()),
                );
              }
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: Transform.scale(
                              scale: _scaleAnimation.value,
                              child: child,
                            ),
                          );
                        },
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Bienvenido a',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Blog App',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      AuthField(
                        hinTex: 'Correo electrónico',
                        controller: emailController,
                        isEmail: true,
                      ),
                      const SizedBox(height: 15),
                      AuthField(
                        hinTex: 'Contraseña',
                        controller: passwordController,
                        isObscureText: true,
                        isPassword: true,
                      ),
                      const SizedBox(height: 30),
                      AuthButton(
                        buttonText: 'Iniciar sesión',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthLogin(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ));
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () =>
                            Navigator.push(context, SignUpPage.route()),
                        child: RichText(
                          text: TextSpan(
                            text: "¿No tienes una cuenta?",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: ' Registrate',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
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
              );
            },
          ),
        ),
      ),
    );
  }
}
