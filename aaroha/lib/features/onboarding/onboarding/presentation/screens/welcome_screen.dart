// lib/features/onboarding/presentation/screens/welcome_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/app_router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF007A5E), Color(0xFF005440), Color(0xFF1A3A4A)],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Row(
                      children: [
                        const Icon(Icons.spa_rounded,
                            color: Colors.white, size: 26),
                        const SizedBox(width: 8),
                        Text('Aaroha',
                            style: AarohaTextStyles.titleLg
                                .copyWith(color: Colors.white)),
                      ],
                    ),
                  ),

                  // Diamond graphic
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 280,
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _diamond(240, 28, 0.08),
                            _diamond(180, 22, 0.10),
                            _diamond(120, 16, 0.12),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Text + CTAs
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('First of all,\ncongrats!',
                            style: AarohaTextStyles.headlineLg
                                .copyWith(color: Colors.white, height: 1.15)),
                        const SizedBox(height: 12),
                        Text(
                          "You've just taken a big step on\nthe path to sobriety.",
                          style: AarohaTextStyles.bodyLg.copyWith(
                              color: Colors.white.withOpacity(0.75)),
                        ),
                        const SizedBox(height: 32),

                        // Get Started
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () =>
                                context.go(Routes.userTypeSelection),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB2F0D8),
                              foregroundColor: const Color(0xFF003D2B),
                              minimumSize: const Size.fromHeight(56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Get Started',
                                    style: AarohaTextStyles.labelLg.copyWith(
                                        color: const Color(0xFF003D2B),
                                        fontSize: 16)),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded,
                                    size: 18),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Sign In
                        Center(
                          child: Column(
                            children: [
                              Text('Returning user with data to restore?',
                                  style: AarohaTextStyles.bodyMd.copyWith(
                                      color:
                                          Colors.white.withOpacity(0.55))),
                              const SizedBox(height: 8),
                              OutlinedButton(
                                onPressed: () => context.go(Routes.signIn),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(160, 48),
                                  side: BorderSide(
                                      color: Colors.white.withOpacity(0.4)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(999),
                                  ),
                                ),
                                child: Text('Sign In',
                                    style: AarohaTextStyles.labelLg
                                        .copyWith(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
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

  Widget _diamond(double size, double radius, double opacity) {
    return Transform.rotate(
      angle: 0.785398,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.white.withOpacity(opacity),
        ),
      ),
    );
  }
}
