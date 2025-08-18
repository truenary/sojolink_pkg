import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sojo_link/src/pending_dynamic_link.dart';
import 'package:sojo_link/src/platform_interface/sojo_link_platform_interface.dart';

/// An implementation of [SojoLinkPlatform] that uses method channels.
class MethodChannelSojoLink extends SojoLinkPlatform {
  /// The [MethodChannel] used to communicate with the native plugin
  static MethodChannel channel = const MethodChannel(
    'sojo_dynamic_links',
  );

  MethodChannelSojoLink() {
    if (_initialized) return;

    channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'SojoDynamicLink#onSuccess':
          Map<String, dynamic> event =
              Map<String, dynamic>.from(call.arguments);
          PendingDynamicLinkData? data =
              _getPendingDynamicLinkDataFromMap(event);

          if (data != null) {
            _onLinkController.add(data);
          }
          break;
        default:
          throw UnimplementedError('${call.method} has not been implemented');
      }
    });
    _initialized = true;
  }

  static bool _initialized = false;

  @override
  SojoLinkPlatform delegateFor() {
    return MethodChannelSojoLink();
  }

  /// Returns a broadcast stream that emits PendingDynamicLinkData objects
  /// whenever a dynamic link is received from the native platform.
  @override
  Stream<PendingDynamicLinkData> get onLink {
    return _onLinkController.stream;
  }

  /// The [StreamController] used to update on the latest dynamic link received.
  static final StreamController<PendingDynamicLinkData> _onLinkController =
      StreamController<PendingDynamicLinkData>.broadcast();

  PendingDynamicLinkData? _getPendingDynamicLinkDataFromMap(
    Map<dynamic, dynamic>? linkData,
  ) {
    if (linkData == null) return null;

    final link = linkData['link'];
    if (link == null) return null;

    return PendingDynamicLinkData(
      link: Uri.parse(link),
      utmParameters: linkData['utmParameters'] == null
          ? {}
          : Map<String, String?>.from(linkData['utmParameters']),
    );
  }
}
