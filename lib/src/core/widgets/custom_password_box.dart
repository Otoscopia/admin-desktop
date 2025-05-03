import 'package:fluent_ui/fluent_ui.dart';

class CustomPasswordBox extends StatefulWidget {
  const CustomPasswordBox({
    super.key,
    this.label,
    this.placeholder,
    this.size = 330,
    this.controller,
  });
  final String? label;
  final String? placeholder;
  final double size;
  final TextEditingController? controller;

  @override
  State<CustomPasswordBox> createState() => _CustomPasswordBoxState();
}

class _CustomPasswordBoxState extends State<CustomPasswordBox> {
  @override
  Widget build(BuildContext context) {
    final textbox = SizedBox(
      width: widget.size,
      child: PasswordBox(
        controller: widget.controller,
        placeholder: widget.placeholder,
        placeholderStyle: TextStyle(fontSize: 16),
        style: TextStyle(fontSize: 18),
      ),
    );

    if (widget.label != null) {
      return InfoLabel(
        label: widget.label!,
        child: textbox,
      );
    }

    return textbox;
  }
}
