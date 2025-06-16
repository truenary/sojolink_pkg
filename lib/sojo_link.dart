import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sojo_link/src/pending_dynamic_link.dart';
import 'package:sojo_link/src/platform_interface/sojo_link_platform_interface.dart';

class SojoLink extends PlatformInterface {
  //Initialize SojoLink
  static final Object _token = Object();
  SojoLink._() : super(token: _token);

  /// Returns the single instance of SojoLink.
  static SojoLink get instance {
    return SojoLink._();
  }

  SojoLinkPlatform? _delegatePackingProperty;

  SojoLinkPlatform get _delegate {
    return _delegatePackingProperty ??= SojoLinkPlatform
        .instanceFor(); // Ensure the delegate instance is properly initialized
  }

  /// Stream of dynamic link events.
  ///
  /// This stream emits events whenever the application receives a dynamic link,
  /// either when opened from a link or when a link is received while the app is running.
  ///
  /// Returns a Stream that emits PendingDynamicLinkData objects containing information
  /// about received dynamic links.
  Stream<PendingDynamicLinkData> get onLink {
    return _delegate.onLink;
  }
}
