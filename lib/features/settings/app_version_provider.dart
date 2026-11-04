import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// The installed app version: `versionName` and `versionCode` of the APK
/// (`version: name+code` in `pubspec.yaml`).
typedef AppVersion = ({String name, String code});

/// The installed app version, read from the platform (ECR-06, CR-030).
/// Override it in tests. Not retried: a failure would not go away.
final appVersionProvider = FutureProvider<AppVersion>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return (name: info.version, code: info.buildNumber);
}, retry: (_, _) => null);
