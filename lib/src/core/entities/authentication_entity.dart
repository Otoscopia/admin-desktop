import 'package:admin/src/core/index.dart';

class AuthenticationEntity {
  final bool isLoading;
  final UserEntity? user;

  AuthenticationEntity({
    this.isLoading = false,
    this.user,
  });

  AuthenticationEntity copyWith({
    bool? isLoading,
    UserEntity? user,
  }) {
    return AuthenticationEntity(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }
}
