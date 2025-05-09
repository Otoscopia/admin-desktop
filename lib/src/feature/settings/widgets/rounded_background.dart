import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoundedBackground extends ConsumerWidget {
  const RoundedBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        color: FluentTheme.of(context).scaffoldBackgroundColor,
        child: child,
      ),
    );
  }
}
