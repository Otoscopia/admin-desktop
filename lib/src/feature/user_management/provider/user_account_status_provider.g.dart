// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userAccStatusHash() => r'375d764822ef2c87dfbbd2a55f03d0495b8816b1';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$UserAccStatus
    extends BuildlessAsyncNotifier<AccountStatusEntity> {
  late final String id;

  FutureOr<AccountStatusEntity> build(String id);
}

/// See also [UserAccStatus].
@ProviderFor(UserAccStatus)
const userAccStatusProvider = UserAccStatusFamily();

/// See also [UserAccStatus].
class UserAccStatusFamily extends Family<AsyncValue<AccountStatusEntity>> {
  /// See also [UserAccStatus].
  const UserAccStatusFamily();

  /// See also [UserAccStatus].
  UserAccStatusProvider call(String id) {
    return UserAccStatusProvider(id);
  }

  @override
  UserAccStatusProvider getProviderOverride(
    covariant UserAccStatusProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userAccStatusProvider';
}

/// See also [UserAccStatus].
class UserAccStatusProvider
    extends AsyncNotifierProviderImpl<UserAccStatus, AccountStatusEntity> {
  /// See also [UserAccStatus].
  UserAccStatusProvider(String id)
    : this._internal(
        () => UserAccStatus()..id = id,
        from: userAccStatusProvider,
        name: r'userAccStatusProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$userAccStatusHash,
        dependencies: UserAccStatusFamily._dependencies,
        allTransitiveDependencies:
            UserAccStatusFamily._allTransitiveDependencies,
        id: id,
      );

  UserAccStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  FutureOr<AccountStatusEntity> runNotifierBuild(
    covariant UserAccStatus notifier,
  ) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(UserAccStatus Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserAccStatusProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<UserAccStatus, AccountStatusEntity>
  createElement() {
    return _UserAccStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserAccStatusProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserAccStatusRef on AsyncNotifierProviderRef<AccountStatusEntity> {
  /// The parameter `id` of this provider.
  String get id;
}

class _UserAccStatusProviderElement
    extends AsyncNotifierProviderElement<UserAccStatus, AccountStatusEntity>
    with UserAccStatusRef {
  _UserAccStatusProviderElement(super.provider);

  @override
  String get id => (origin as UserAccStatusProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
