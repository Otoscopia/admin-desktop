import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';

class UserInformationWidget extends ConsumerStatefulWidget {
  const UserInformationWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserInformationWidgetState();
}

class _UserInformationWidgetState extends ConsumerState<UserInformationWidget> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final workAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: Sizes.p16,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextBox(label: "Full Name", controller: nameController),
            CustomTextBox(label: "Contact Number", controller: phoneController),
            SizedBox(width: 64),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomTextBox(label: "Work Address", controller: workAddress),
            FilledButton(child: Text('Edit Information'), onPressed: () {}),
          ],
        ),
      ],
    );
  }
}
