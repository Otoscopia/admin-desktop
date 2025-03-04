import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: "SENTRY_DSN", obfuscate: true)
  static final String sentryDsn = _Env.sentryDsn;

  @EnviedField(varName: "APPWRITE_CLIENT", obfuscate: true)
  static final String appwriteClient = _Env.appwriteClient;

  @EnviedField(varName: "APPWRITE_PROJECT", obfuscate: true)
  static final String appwriteProject = _Env.appwriteProject;

  @EnviedField(varName: "DATABASE", obfuscate: true)
  static final String database = _Env.database;

  @EnviedField(varName: "USER_COLLECTION", obfuscate: true)
  static final String userCollection = _Env.userCollection;

  // Storage
  @EnviedField(varName: "PRESCRIPTIONS_BUCKET", obfuscate: true)
  static final String prescriptionBucket = _Env.prescriptionBucket;

  @EnviedField(varName: "SCREENINGS_BUCKET", obfuscate: true)
  static final String screeningBucket = _Env.screeningBucket;

  @EnviedField(varName: "AVATARS_BUCKET", obfuscate: true)
  static final String avatarBucket = _Env.avatarBucket;
}
