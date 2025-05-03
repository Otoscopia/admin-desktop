// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_user_access_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchRoleHash() => r'aa4bfc6f886b5f442f330700465ca457c9919c97';

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

/// See also [fetchRole].
@ProviderFor(fetchRole)
const fetchRoleProvider = FetchRoleFamily();

/// See also [fetchRole].
class FetchRoleFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [fetchRole].
  const FetchRoleFamily();

  /// See also [fetchRole].
  FetchRoleProvider call(String id) {
    return FetchRoleProvider(id);
  }

  @override
  FetchRoleProvider getProviderOverride(covariant FetchRoleProvider provider) {
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
  String? get name => r'fetchRoleProvider';
}

/// See also [fetchRole].
class FetchRoleProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [fetchRole].
  FetchRoleProvider(String id)
    : this._internal(
        (ref) => fetchRole(ref as FetchRoleRef, id),
        from: fetchRoleProvider,
        name: r'fetchRoleProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fetchRoleHash,
        dependencies: FetchRoleFamily._dependencies,
        allTransitiveDependencies: FetchRoleFamily._allTransitiveDependencies,
        id: id,
      );

  FetchRoleProvider._internal(
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
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(FetchRoleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchRoleProvider._internal(
        (ref) => create(ref as FetchRoleRef),
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
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _FetchRoleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchRoleProvider && other.id == id;
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
mixin FetchRoleRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `id` of this provider.
  String get id;
}

class _FetchRoleProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with FetchRoleRef {
  _FetchRoleProviderElement(super.provider);

  @override
  String get id => (origin as FetchRoleProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
