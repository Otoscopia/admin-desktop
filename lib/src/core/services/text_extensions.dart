import 'package:fluent_ui/fluent_ui.dart';

extension TextExtension on Text {
  Text get title => Text(
        data!,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );
  Text get titleSmall => Text(
        data!,
        style: const TextStyle(fontSize: 16),
      );
  Text get caption => Text(
        data!,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      );
}
