import 'proxy_platform_default.dart'
    if (dart.library.io) 'proxy_platform_system.dart';

abstract class ProxyPlatform {
  factory ProxyPlatform() => ProxyPlatformImpl();

  void init();
}
