import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/constants/index.dart';

class LogFilter extends ConsumerStatefulWidget {
  const LogFilter({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogFilterState();
}

class _LogFilterState extends ConsumerState<LogFilter> {
  DateTime? selected;
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Start Date"),
                SizedBox(
                  width: 330,
                  child: DatePicker(
                    selected: selected,
                    onChanged: (value) {
                      setState(() {
                        selected = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text("User Role"),
                SizedBox(
                  width: 330,
                  child: ComboBox(
                    items: [
                      ComboBoxItem(value: 'admin', child: Text('admin')),
                      ComboBoxItem(value: 'doctor', child: Text('doctor')),
                      ComboBoxItem(value: 'nurse', child: Text('nurse')),
                      ComboBoxItem(value: 'parent', child: Text('parent')),
                    ],
                    isExpanded: true,
                  ),
                ),
              ],
            ),
          ],
        ),
        gap12,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("End Date"),
                SizedBox(
                  width: 330,
                  child: DatePicker(
                    selected: selected,
                    onChanged: (value) {
                      setState(() {
                        selected = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text("Username"),
                SizedBox(width: 330, child: TextBox()),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
