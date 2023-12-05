import 'dart:io';

import 'package:network_proxy_interface/network_proxy_method_channel.dart';
import 'package:network_proxy_interface/network_proxy_platform_interface.dart';

/// An implementation of the NetworkProxyPlatform of the NetworkProxy plugin.
/// ```shell
/// # Enable
/// gsettings get org.gnome.system.proxy mode
/// gsettings set org.gnome.system.proxy mode manual
/// gsettings set org.gnome.system.proxy use-same-proxy true
/// # Http
/// gsettings get org.gnome.system.proxy.http enabled
/// gsettings get org.gnome.system.proxy.http host
/// gsettings get org.gnome.system.proxy.http port
/// gsettings set org.gnome.system.proxy.http enabled true
/// gsettings set org.gnome.system.proxy.http host <host>
/// gsettings set org.gnome.system.proxy.http port <port>
/// ```
class NetworkProxyLinux extends MethodChannelNetworkProxy {
  @override
  Future<bool> getProxyEnable({NetworkProxyType? type}) async {
    switch (type) {
      case NetworkProxyType.http:
      case NetworkProxyType.https:
      case NetworkProxyType.socks:
      case NetworkProxyType.auto:
        final result = await Process.run(
          'gsettings',
          [
            'get',
            'org.gnome.system.proxy.${type!.name}',
            'enabled',
          ],
        );
        final lines = getProxyLines(result.stdout.toString());
        final enabled = lines.first != 'false';
        return enabled && await getSystemProxyEnable();
      default:
        return getSystemProxyEnable();
    }
  }

  @override
  Future<bool> setProxyEnable(bool enable, {NetworkProxyType? type}) async {
    switch (type) {
      case NetworkProxyType.http:
      case NetworkProxyType.https:
      case NetworkProxyType.socks:
        final result = await Process.run(
          'gsettings',
          [
            'set',
            'org.gnome.system.proxy.${type!.name}',
            'enabled',
            enable ? 'true' : 'false'
          ],
        );
        return result.exitCode == 0 && await setSystemProxyEnable(enable);
      case NetworkProxyType.auto:
        // TODO: Auto Proxy
        throw UnimplementedError('Auto Proxy has not been implemented.');
      default:
        return setSystemProxyEnable(enable);
    }
  }

  Future<bool> getSystemProxyEnable() async {
    final result = await Process.run(
      'gsettings',
      ['get', 'org.gnome.system.proxy', 'mode'],
    );
    final lines = getProxyLines(result.stdout.toString());
    return lines.first != 'none';
  }

  Future<bool> setSystemProxyEnable(bool enable) async {
    final result = await Process.run(
      'gsettings',
      ['set', 'org.gnome.system.proxy', 'mode', enable ? 'manual' : 'none'],
    );
    return result.exitCode == 0;
  }

  @override
  Future<List<NetworkProxyConf>> getProxy({
    NetworkProxyType? type,
  }) async {
    try {
      switch (type) {
        case NetworkProxyType.http:
        case NetworkProxyType.https:
        case NetworkProxyType.socks:
          final enable = await () async {
            final result = await Process.run(
              'gsettings',
              ['get', 'org.gnome.system.proxy.${type!.name}', 'enabled'],
            );
            final lines = getProxyLines(result.stdout.toString());
            return lines.first != 'false';
          }();
          final host = await () async {
            final result = await Process.run(
              'gsettings',
              ['get', 'org.gnome.system.proxy.${type!.name}', 'host'],
            );
            final lines = getProxyLines(result.stdout.toString());
            return lines.first;
          }();
          final port = await () async {
            final result = await Process.run(
              'gsettings',
              ['get', 'org.gnome.system.proxy.${type!.name}', 'host'],
            );
            final lines = getProxyLines(result.stdout.toString());
            return int.parse(lines.first ?? '0');
          }();
          return [NetworkProxyConf(enable, type!, host, port)];
        case NetworkProxyType.auto:
          // TODO: Auto Proxy
          throw UnimplementedError('Auto Proxy has not been implemented.');
        default:
          final list = List<NetworkProxyConf>.empty(growable: true);
          for (final e in NetworkProxyType.values) {
            list.addAll(await getProxy(type: e));
          }
          return list;
      }
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  @override
  Future<bool> setProxy(NetworkProxyConf conf) async {
    final enable = conf.enable;

    return await setProxyType(conf) && await setProxyEnable(enable);
  }

  Future<bool> setProxyType(
    NetworkProxyConf conf,
  ) async {
    final type = conf.type;
    switch (type) {
      case NetworkProxyType.http:
      case NetworkProxyType.https:
      case NetworkProxyType.socks:
        final enable = await setProxyEnable(conf.enable, type: type);
        final host = await () async {
          final result = await Process.run(
            'gsettings',
            ['set', 'org.gnome.system.proxy.${type.name}', 'host', conf.host],
          );
          return result.exitCode == 0;
        }();
        final port = await () async {
          final result = await Process.run(
            'gsettings',
            [
              'set',
              'org.gnome.system.proxy.${type.name}',
              'port',
              conf.port.toString(),
            ],
          );
          return result.exitCode == 0;
        }();
        return enable && host && port;
      case NetworkProxyType.auto:
        // TODO: Auto Proxy
        throw UnimplementedError('Auto Proxy has not been implemented.');
    }
  }

  Iterable<String> getProxyLines(String result) {
    final lines = result.split('\n').where(
      (element) {
        return element.trim().isNotEmpty;
      },
    );
    return lines;
  }
}
