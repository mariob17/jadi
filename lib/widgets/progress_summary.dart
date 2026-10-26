import 'package:flutter/material.dart';

class ProgressSummary extends StatelessWidget {
  const ProgressSummary({
    required this.completed,
    required this.total,
    super.key,
  });

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: colors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Progres belajar',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text('$completed dari $total selesai'),
              ],
            ),
            const SizedBox(height: 14),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 350),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 9,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
