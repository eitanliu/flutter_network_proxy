
import 'network_proxy_platform_interface.dart';

class NetworkProxy {
  Future<String?> getPlatformVersion() {
    return NetworkProxyPlatform.instance.getPlatformVersion();
  }
}
