
import 'sojo_link_platform_interface.dart';

class SojoLink {
  Future<String?> getPlatformVersion() {
    return SojoLinkPlatform.instance.getPlatformVersion();
  }
}
