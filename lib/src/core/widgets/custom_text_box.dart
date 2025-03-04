import 'package:fluent_ui/fluent_ui.dart';

class CustomTextBox extends StatefulWidget {
  const CustomTextBox({
    super.key,
    this.label,
    this.placeholder,
    this.suffix,
    this.prefix,
    this.obscureText = false,
    this.size = 330,
    this.controller,
  });
  final String? label;
  final String? placeholder;
  final Widget? suffix;
  final Widget? prefix;
  final bool obscureText;
  final double size;
  final TextEditingController? controller;

  @override
  State<CustomTextBox> createState() => _CustomTextBoxState();
}

class _CustomTextBoxState extends State<CustomTextBox> {
  @override
  Widget build(BuildContext context) {
    final textbox = SizedBox(
      width: widget.size,
      child: TextBox(
        controller: widget.controller,
        placeholder: widget.placeholder,
        suffix: widget.suffix,
        prefix: widget.prefix,
        obscureText: widget.obscureText,
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
