import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:admin/src/core/index.dart';

class AuthenticationTabPage extends ConsumerStatefulWidget {
  const AuthenticationTabPage(this.uid, {super.key});
  final String uid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthenticationTabPageState();
}

class _AuthenticationTabPageState extends ConsumerState<AuthenticationTabPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      padding: EdgeInsets.zero,
      children: [
        AuthUserInformation(),
      ],
    );
  }
}

class AuthUserInformation extends ConsumerWidget {
  const AuthUserInformation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joinedDate =
        DateFormat('MMM. dd, yyyy, HH:MM').format(DateTime.now());
    final lastActivityDate =
        DateFormat('MMM. dd, yyyy, HH:MM').format(DateTime.now());
    return Padding(
      padding: const EdgeInsets.all(Sizes.p24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.p12),
        child: ColoredBox(
          color: Color(0xFF282828),
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: Sizes.p24,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(9999),
                      child: Image.network(
                        "https://picsum.photos/200",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Laurence Troy Sambaan Valdez').title,
                        StatusPill(Status.deactivated)
                      ],
                    ),
                  ],
                ),
                Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('laurencetroyv@gmail.com'),
                    Text('Joined: $joinedDate'),
                    Text('Last Activity: $lastActivityDate'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
