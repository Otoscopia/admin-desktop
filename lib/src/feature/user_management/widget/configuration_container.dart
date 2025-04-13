import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigurationContainer extends ConsumerWidget {
  const ConfigurationContainer(
    this.title, {
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final String title;
  final List<ComboBoxItem> items;
  final Function(String value) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        SizedBox(
          width: 330,
          child: ComboBox(
            value: value,
            items: items,
            onChanged: (value) => onChanged(value),
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}
