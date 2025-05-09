import 'package:flutter_riverpod/flutter_riverpod.dart';

class MultiFactorAuthenticationNotifier extends StateNotifier<void> {
  MultiFactorAuthenticationNotifier() : super(null);

  // static final _source = MultiFactorAuthenticationDataSource();
  // final MultiFactorAuthenticationRepository _repository =
  //     MultiFactorAuthenticationRepositoryImpl(_source);

  Future<List<String>> getRecoveryCodes() async {
    try {
      return [];
      // return _repository.getRecoveryCodes();
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<List> enableAuthenticatorApp() async {
    try {
      return [];
      // return _repository.enableAuthenticatorApp();
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> disableAuthenticatorApp(String otp) async {
    try {
      // return _repository.disableAuthenticatorApp(otp);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> verifyAuthenticatorApp(String otp) async {
    try {
      // return _repository.verifyAuthenticatorApp(otp);
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}

final multiFactorAuthenticationProvider =
    StateNotifierProvider<MultiFactorAuthenticationNotifier, void>((ref) {
      return MultiFactorAuthenticationNotifier();
    });
