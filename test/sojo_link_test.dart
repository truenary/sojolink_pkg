import 'package:flutter_test/flutter_test.dart';
import 'package:sojo_link/sojo_link.dart';
import 'package:sojo_link/sojo_link_platform_interface.dart';
import 'package:sojo_link/sojo_link_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSojoLinkPlatform
    with MockPlatformInterfaceMixin
    implements SojoLinkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SojoLinkPlatform initialPlatform = SojoLinkPlatform.instance;

  test('$MethodChannelSojoLink is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSojoLink>());
  });

  test('getPlatformVersion', () async {
    SojoLink sojoLinkPlugin = SojoLink();
    MockSojoLinkPlatform fakePlatform = MockSojoLinkPlatform();
    SojoLinkPlatform.instance = fakePlatform;

    expect(await sojoLinkPlugin.getPlatformVersion(), '42');
  });
}
