import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sojo_link_platform_interface.dart';

/// An implementation of [SojoLinkPlatform] that uses method channels.
class MethodChannelSojoLink extends SojoLinkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sojo_link');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
