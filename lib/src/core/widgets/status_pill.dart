import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/config/index.dart';
import 'package:admin/src/core/index.dart';

class StatusPill extends ConsumerWidget {
  const StatusPill(this.status, {super.key});
  final Status status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = AppColors.status[status.name]!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: ColoredBox(
        color: statusColor['background']!,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 6,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: ColoredBox(
                    color: statusColor['circle']!,
                    child: SizedBox(
                      width: 8,
                      height: 8,
                    ),
                  ),
                ),
              ),
              Text(
                status.name.uppercaseFirst(),
                style: TextStyle(
                  color: statusColor['text']!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
