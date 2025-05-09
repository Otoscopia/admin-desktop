import 'package:flutter/services.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_provider.g.dart';

@riverpod
class SettingsAccount extends _$SettingsAccount {
  @override
  void build() {
    return;
  }

  Future<void> changePassword(String password, String oldPassword) async {
    try {
      // return await _repository.changePassword(password, oldPassword);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> deleteAccount(String id) async {
    try {
      // return await _repository.deleteAccount(id);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> updateAddress(String address) async {
    try {
      // return await _repository.updateAddress(address);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> updateContact(String contact, String password) async {
    try {
      // return await _repository.updateContact(contact, password);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> updateName(String name) async {
    try {
      // return await _repository.updateName(name);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> updateProfilePicture({String? path, Uint8List? cache}) async {
    try {
      // return await _repository.updateProfilePicture(path: path, cache: cache);
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
