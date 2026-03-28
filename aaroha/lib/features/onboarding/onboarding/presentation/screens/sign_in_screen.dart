// lib/features/onboarding/presentation/screens/sign_in_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/app_router.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _loading = false);
    context.go(Routes.tracker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AarohaColors.background,
      appBar: AppBar(
        backgroundColor: AarohaColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AarohaColors.onSurface),
          onPressed: () => context.go(Routes.welcome),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 16),
            Text('Welcome back',
                style: AarohaTextStyles.headlineSm
                    .copyWith(color: AarohaColors.onSurface)),
            const SizedBox(height: 8),
            Text('Sign in to restore your data',
                style: AarohaTextStyles.bodyLg
                    .copyWith(color: AarohaColors.onSurfaceVariant)),
            const SizedBox(height: 40),

            // Email
            _label('Email'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style: AarohaTextStyles.bodyLg
                  .copyWith(color: AarohaColors.onSurface),
              validator: (v) => (v == null || !v.contains('@'))
                  ? 'Enter a valid email'
                  : null,
              decoration: const InputDecoration(
                hintText: 'you@example.com',
                prefixIcon: Icon(Icons.mail_outline_rounded,
                    color: AarohaColors.outline, size: 20),
              ),
            ),
            const SizedBox(height: 20),

            // Password
            _label('Password'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordCtrl,
              obscureText: _obscure,
              style: AarohaTextStyles.bodyLg
                  .copyWith(color: AarohaColors.onSurface),
              validator: (v) =>
                  (v == null || v.length < 6) ? 'Minimum 6 characters' : null,
              decoration: InputDecoration(
                hintText: 'Your password',
                prefixIcon: const Icon(Icons.lock_outline_rounded,
                    color: AarohaColors.outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AarohaColors.outline,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _loading ? null : _signIn,
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation(AarohaColors.onPrimary),
                      ),
                    )
                  : const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: AarohaTextStyles.labelMd
          .copyWith(color: AarohaColors.onSurfaceVariant));
}
