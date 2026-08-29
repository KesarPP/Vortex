import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/vortex_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;
  final String? semanticLabel;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: VortexTheme.surface.withValues(alpha: 0.4),
            borderRadius: borderRadius ?? BorderRadius.circular(16.0),
            border: Border.all(
              color: VortexTheme.neonCyan.withValues(alpha: 0.2),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              )
            ],
          ),
          child: child,
        ),
      ),
    );

    if (semanticLabel != null) {
      return Semantics(
        label: semanticLabel,
        container: true,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
