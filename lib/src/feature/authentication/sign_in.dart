import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/config/index.dart';
import 'package:admin/src/core/index.dart';
import 'package:admin/src/feature/admin.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String get email => emailController.text;
  String get password => passwordController.text;

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authenticationProvider);

    return PageContainer(
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            SizedBox.fromSize(
              size: const Size(double.infinity, 230),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ColoredBox(
                  color: AppColors.primary,
                  child: Stack(
                    children: [
                      Transform.rotate(
                        angle:
                            -10 *
                            3.141592653589793 /
                            180, // 10 degrees in radians
                        child: Image.asset(
                          'assets/line.png',
                          width: 1086,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Transform.rotate(
                        angle:
                            169 *
                            3.141592653589793 /
                            180, // 169 degrees in radians
                        child: Image.asset(
                          'assets/line.png',
                          width: 1044,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ColoredBox(
                  color: FluentTheme.of(context).inactiveBackgroundColor,
                  child: SizedBox(
                    width: 520,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 92,
                        vertical: 52,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 24,
                        children: [
                          CustomTextBox(
                            controller: emailController,
                            label: "Email Address",
                            placeholder: "Enter your Email Address",
                          ),
                          CustomPasswordBox(
                            controller: passwordController,
                            label: "Password",
                            placeholder: "Enter your Password",
                          ),
                          if (auth.isLoading)
                            const ProgressRing()
                          else
                            FilledButton(
                              child: const Text("Sign in"),
                              onPressed: () async {
                                try {
                                  await ref
                                      .read(authenticationProvider.notifier)
                                      .signIn(email: email, password: password);

                                  if (context.mounted) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      FluentPageRoute(
                                        builder:
                                            (context) => AppContainer(
                                              onLoaded:
                                                  (context) =>
                                                      const PageContainer(
                                                        content: Admin(),
                                                      ),
                                            ),
                                      ),
                                      (route) => false,
                                    );
                                  }

                                  setState(() {});
                                } catch (error) {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    displayInfoBar(
                                      context,
                                      builder: (context, close) {
                                        return InfoBar(
                                          title: const Text(
                                            "Ohh oh! Something went wrong.",
                                          ),
                                          content: Text(error.toString()),
                                          severity: InfoBarSeverity.error,
                                          isLong: true,
                                        );
                                      },
                                    );
                                  });
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
