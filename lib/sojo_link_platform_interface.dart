import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sojo_link_method_channel.dart';

abstract class SojoLinkPlatform extends PlatformInterface {
  /// Constructs a SojoLinkPlatform.
  SojoLinkPlatform() : super(token: _token);

  static final Object _token = Object();

  static SojoLinkPlatform _instance = MethodChannelSojoLink();

  /// The default instance of [SojoLinkPlatform] to use.
  ///
  /// Defaults to [MethodChannelSojoLink].
  static SojoLinkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SojoLinkPlatform] when
  /// they register themselves.
  static set instance(SojoLinkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
