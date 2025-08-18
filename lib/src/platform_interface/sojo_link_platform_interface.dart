import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sojo_link/src/method_channel/sojo_link_method_channel.dart';
import 'package:sojo_link/src/pending_dynamic_link.dart';

abstract class SojoLinkPlatform extends PlatformInterface {
  /// Create an instance
  SojoLinkPlatform() : super(token: _token);

  static final Object _token = Object();

  static SojoLinkPlatform? _instance;

  /// The default instance of [SojoLinkPlatform] to use.
  ///
  /// Defaults to [MethodChannelSojoLink].
  static SojoLinkPlatform get instance {
    return _instance ??= MethodChannelSojoLink();
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SojoLinkPlatform] when
  /// they register themselves.
  static set instance(SojoLinkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  factory SojoLinkPlatform.instanceFor() {
    return SojoLinkPlatform.instance.delegateFor();
  }

  /// Enables delegates to create new instances of themselves if a none default
  SojoLinkPlatform delegateFor() {
    throw UnimplementedError('delegateFor() is not implemented');
  }

  /// Creates a stream for listening whenever a dynamic link becomes available
  Stream<PendingDynamicLinkData> get onLink {
    throw UnimplementedError('onLink is not implemented');
  }
}
