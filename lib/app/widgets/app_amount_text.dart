import 'package:flutter/material.dart';

enum AppAmountTone {
  normal,
  positive,
  negative,
}

class AppAmountText extends StatelessWidget {
  const AppAmountText({
    super.key,
    required this.text,
    this.tone = AppAmountTone.normal,
    this.style,
  });

  final String text;
  final AppAmountTone tone;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final color = switch (tone) {
      AppAmountTone.normal => colorScheme.onSurface,
      AppAmountTone.positive => const Color(0xFF16A34A),
      AppAmountTone.negative => colorScheme.error,
    };

    return Text(
      text,
      style: (style ?? Theme.of(context).textTheme.titleMedium)?.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
        fontFeatures: const [
          FontFeature.tabularFigures(),
        ],
      ),
    );
  }
}
