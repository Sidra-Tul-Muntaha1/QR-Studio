import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Color purple = Color(0xFF6546E8);
  static const Color lightPurple = Color(0xFF8D70FF);

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 4), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF5940E5),
              Color(0xFF714EEB),
              Color(0xFF8062F4),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background circles
            Positioned(
              top: -55,
              left: -45,
              child: _bubble(180, const Color(0xFF8A71FF).withOpacity(0.15)),
            ),
            Positioned(
              top: 45,
              right: -65,
              child: _bubble(150, const Color(0xFFB5A3FF).withOpacity(0.12)),
            ),
            Positioned(
              bottom: 30,
              left: -45,
              child: _bubble(180, const Color(0xFFB5A3FF).withOpacity(0.12)),
            ),
            Positioned(
              bottom: -80,
              right: -25,
              child: _bubble(200, const Color(0xFF9A83FF).withOpacity(0.14)),
            ),

            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 135),

                            // QR Studio app icon
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(19),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.10),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.qr_code_2_rounded,
                                color: Color(0xFF6546E8),
                                size: 49,
                              ),
                            ),

                            const SizedBox(height: 12),

                            const Text(
                              'QR Studio',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 29,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.6,
                              ),
                            ),

                            const SizedBox(height: 4),

                            const Text(
                              'Turn anything into a QR code',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFF0ECFF),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Feature: Generate
                            const _FeatureRow(
                              icon: Icons.qr_code_2_rounded,
                              title: 'Generate',
                              subtitle: 'From text or URLs',
                            ),

                            const SizedBox(height: 17),

                            // Feature: Save
                            const _FeatureRow(
                              icon: Icons.save_alt_rounded,
                              title: 'Save',
                              subtitle: 'To your gallery',
                            ),

                            const SizedBox(height: 17),

                            // Feature: Share
                            const _FeatureRow(
                              icon: Icons.share_rounded,
                              title: 'Share',
                              subtitle: 'With anyone, anywhere',
                            ),

                            const SizedBox(height: 28),

                            // Bottom illustration
                            SizedBox(
                              height: 145,
                              width: double.infinity,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 0,
                                    bottom: 7,
                                    child: Transform.rotate(
                                      angle: -0.24,
                                      child: Container(
                                        width: 112,
                                        height: 112,
                                        padding: const EdgeInsets.all(9),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFC4B3FF),
                                          borderRadius:
                                              BorderRadius.circular(17),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF39218C)
                                                  .withOpacity(0.25),
                                              blurRadius: 16,
                                              offset: const Offset(0, 9),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(11),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.qr_code_2_rounded,
                                              color: Color(0xFF6546E8),
                                              size: 73,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Sparkles
                                  const Positioned(
                                    left: 76,
                                    top: 4,
                                    child: Icon(
                                      Icons.auto_awesome,
                                      color: Color(0xFFFFE17D),
                                      size: 25,
                                    ),
                                  ),

                                  const Positioned(
                                    left: 100,
                                    top: 0,
                                    child: Icon(
                                      Icons.flash_on_rounded,
                                      color: Color(0xFFFFE17D),
                                      size: 20,
                                    ),
                                  ),

                                  const Positioned(
                                    right: 1,
                                    top: 24,
                                    child: SizedBox(
                                      width: 124,
                                      child: Text(
                                        'Small code.\nBig possibilities!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          height: 1.3,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    right: 49,
                                    top: 66,
                                    child: Transform.rotate(
                                      angle: -0.25,
                                      child: const Icon(
                                        Icons.subdirectory_arrow_left_rounded,
                                        color: Color(0xFFBDAAFF),
                                        size: 31,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bubble(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.28),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFFE0D8FF),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}