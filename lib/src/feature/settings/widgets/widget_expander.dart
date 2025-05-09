import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WidgetExpander extends ConsumerWidget {
  const WidgetExpander({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget content;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final header =
        subtitle == null
            ? Text(title)
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text(
                  subtitle!,
                  style: FluentTheme.of(context).typography.caption,
                ),
              ],
            );
    return Expander(
      leading: Icon(icon),
      header: header,
      content: content,
      trailing: trailing,
    );
  }
}
