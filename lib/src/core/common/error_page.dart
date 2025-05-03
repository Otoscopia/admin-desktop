import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorPage extends ConsumerWidget {
  const ErrorPage({super.key, required this.erorrMessage});
  final String erorrMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage(
      content: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text("Something went wrong: $erorrMessage")],
        ),
      ),
    );
  }
}
