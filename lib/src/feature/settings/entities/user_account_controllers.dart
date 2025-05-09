import 'package:fluent_ui/fluent_ui.dart';

class UserAccountControllers {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  String get name => nameController.text;
  String get email => emailController.text;
  String get phone => phoneController.text;
  String get address => addressController.text;

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }

  void clear() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
  }

  void update({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) {
    nameController.text = name ?? '';
    emailController.text = email ?? '';
    phoneController.text = phone ?? '';
    addressController.text = address ?? '';
  }
}
