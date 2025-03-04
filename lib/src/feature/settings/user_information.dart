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
    return ScaffoldPage(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: Sizes.p16,
        children: [
          Row(
            children: [
              CustomTextBox(
                label: "Full Name",
                controller: nameController,
              ),
              CustomTextBox(
                label: "Contact Number",
                controller: phoneController,
              ),
            ],
          ),
          CustomTextBox(
            label: "Work Address",
            controller: workAddress,
          ),
        ],
      ),
    );
  }
}
