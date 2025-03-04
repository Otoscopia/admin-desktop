import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/config/index.dart';
import 'package:admin/src/core/index.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  String role = 'nurse';
  final roles = ['nurse', 'doctor', 'admin', 'parent'];

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      content: Row(
        children: [
          Expanded(child: ColoredBox(color: AppColors.primary)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 330,
                    child: TextBox(
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 330,
                    child: TextBox(
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 330,
                    child: TextBox(
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 330,
                    child: TextBox(
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 330,
                    child: TextBox(
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 330,
                    child: TextBox(
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 330,
                    child: ComboBox(
                      isExpanded: true,
                      value: role,
                      items: roles.map((role) {
                        return ComboBoxItem(
                          value: role,
                          child: Text(role.uppercaseFirst()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            role = value;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 330,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Already have an account?"),
                        HyperlinkButton(
                          child: Text("Sign in"),
                          onPressed: () => context.pop(),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: FilledButton(
                      onPressed: () {},
                      child: Text("Sign Up"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
