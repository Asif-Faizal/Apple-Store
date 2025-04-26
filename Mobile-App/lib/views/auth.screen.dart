import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.provider.dart';
import 'dart:math' as math;

import 'home.screen.dart';

class SquigglyLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool isReversed;

  SquigglyLinePainter({
    required this.color,
    this.strokeWidth = 0.15,
    this.isReversed = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Create four different wave-like lines
    for (int line = 0; line < 4; line++) {
      final path = Path();
      final startX = 0.0;
      final startY = line * (size.height / 5); // Reduced spacing between lines
      
      path.moveTo(startX, startY);
      
      // Create sine wave pattern
      final random = math.Random(line * 100); // Different seed for each line
      final numPoints = 100; // More points for smoother curve
      final amplitude = (size.height / 5) * 0.15; // Reduced wave height
      final frequency = 2.0 + random.nextDouble() * 2.0; // Varying frequency
      final phase = random.nextDouble() * math.pi * 2; // Random phase
      
      for (int i = 0; i < numPoints; i++) {
        final x = i * (size.width / numPoints);
        // Combine two sine waves with different frequencies
        final y1 = amplitude * math.sin(frequency * (i / numPoints) * math.pi * 2 + phase);
        final y2 = amplitude * 0.5 * math.sin(frequency * 1.5 * (i / numPoints) * math.pi * 2 + phase);
        final y = startY + y1 + y2;
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      // Apply transformations
      final matrix = Matrix4.identity();
      
      if (isReversed) {
        // For bottom-right: mirror and rotate +30 degrees
        matrix
          ..translate(size.width, size.height)
          ..rotateZ(math.pi) // 180 degrees
          ..rotateZ(0.523599) // +30 degrees
          ..translate(-size.width, -size.height);
      } else {
        // For top-left: rotate -30 degrees
        matrix
          ..translate(size.width / 2, size.height / 2)
          ..rotateZ(-0.523599) // -30 degrees
          ..translate(-size.width / 2, -size.height / 2);
      }
      
      final transformedPath = path.transform(matrix.storage);
      canvas.drawPath(transformedPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top-left squiggly lines
          Positioned(
            top: -MediaQuery.of(context).size.height * 0.05,
            left: -MediaQuery.of(context).size.width * 0.15,
            child: CustomPaint(
              size: const Size(400, 250),
              painter: SquigglyLinePainter(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
            ),
          ),
          // Bottom-right squiggly lines
          Positioned(
            bottom: -MediaQuery.of(context).size.height * 0.25,
            right: -MediaQuery.of(context).size.width * 0.25,
            child: CustomPaint(
              size: const Size(400, 300),
              painter: SquigglyLinePainter(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
            ),
          ),
          Center(
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                if (authProvider.isLoading) {
                  return const CircularProgressIndicator();
                }

                if (authProvider.isAuthenticated) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  HomeScreen()));
                  });
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    const Text(
                      'Welcome to Apple Store',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    if (authProvider.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          authProvider.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: ElevatedButton.icon(
                        onPressed: () => authProvider.signInWithGoogle(),
                        icon: Image.asset(
                          'lib/core/assets/google-icon.png',
                          height: 24,
                        ),
                        label: Text('Sign in with Google',style: Theme.of(context).textTheme.labelLarge,),
                      ),
                    ),
                     SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
