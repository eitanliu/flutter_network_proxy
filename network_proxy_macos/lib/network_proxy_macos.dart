import 'dart:io';

import 'package:network_proxy_interface/list_extension.dart';
import 'package:network_proxy_interface/network_proxy_method_channel.dart';
import 'package:network_proxy_interface/network_proxy_platform_interface.dart';

/// An implementation of the NetworkProxyPlatform of the NetworkProxy plugin.
/// ```shell
/// # Http
/// networksetup -getwebproxy <networkservice>
/// networksetup -setwebproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
/// networksetup -setwebproxystate <networkservice> <on off>
/// # Https
/// networksetup -getsecurewebproxy <networkservice>
/// networksetup -setsecurewebproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
/// networksetup -setsecurewebproxystate <networkservice> <on off>
/// # Socket
/// networksetup -getsocksfirewallproxy <networkservice>
/// networksetup -setsocksfirewallproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
/// networksetup -setsocksfirewallproxystate <networkservice> <on off>
/// # AutoProxy
/// networksetup -getautoproxyurl <networkservice>
/// networksetup -setautoproxyurl <networkservice> <url>
/// networksetup -setautoproxystate <networkservice> <on off>
/// networksetup -getproxyautodiscovery <networkservice>
/// networksetup -setproxyautodiscovery <networkservice> <on off>
/// ```
class NetworkProxyMacos extends MethodChannelNetworkProxy {
  @override
  Future<bool> getProxyEnable({NetworkProxyType? type}) {
    return getServiceList().asyncEvery((service) {
      return getServiceProxy(service, type: type).asyncAny((conf) async {
        return conf.enable;
      });
    });
  }

  @override
  Future<bool> setProxyEnable(bool enable, {NetworkProxyType? type}) {
    return getServiceList().asyncEvery((service) {
      return setServiceProxyEnable(service, enable);
    });
  }

  @override
  Future<List<NetworkProxyConf>> getProxy({
    NetworkProxyType? type,
  }) {
    return getServiceList().asyncFlatMap((service) {
      return getServiceProxy(service, type: type);
    });
  }

  @override
  Future<bool> setProxy(NetworkProxyConf conf) {
    final type = conf.type;
    final enable = conf.enable;
    return getServiceList().asyncEvery((service) async {
      return await setServiceProxy(service, conf) &&
          await setServiceProxyEnable(service, enable, type: type);
    });
  }

  Future<List<NetworkProxyConf>> getServiceProxy(
    String service, {
    NetworkProxyType? type,
  }) async {
    try {
      switch (type) {
        case NetworkProxyType.http:
          final result = await Process.run(
            '/usr/sbin/networksetup',
            ['-getwebproxy', service],
          );
          final maps = getProxyResult(result.stdout.toString());
          final enable = maps['Enable'] == 'Yes';
          final host = maps['Server'] ?? '';
          final port = int.parse(maps['Port'] ?? '-1');
          return [NetworkProxyConf(type!, enable, host, port)];
        case NetworkProxyType.https:
          final result = await Process.run(
            '/usr/sbin/networksetup',
            ['-getsecurewebproxy', service],
          );
          final maps = getProxyResult(result.stdout.toString());
          final enable = maps['Enable'] == 'Yes';
          final host = maps['Server'] ?? '';
          final port = int.parse(maps['Port'] ?? '-1');
          return [NetworkProxyConf(type!, enable, host, port)];
        case NetworkProxyType.socks:
          final result = await Process.run(
            '/usr/sbin/networksetup',
            ['-getsocksfirewallproxy', service],
          );
          final maps = getProxyResult(result.stdout.toString());
          final enable = maps['Enable'] == 'Yes';
          final host = maps['Server'] ?? '';
          final port = int.parse(maps['Port'] ?? '-1');
          return [NetworkProxyConf(type!, enable, host, port)];
        case NetworkProxyType.auto:
          final result = await Process.run(
            '/usr/sbin/networksetup',
            ['-getautoproxyurl', service],
          );
          final maps = getProxyResult(result.stdout.toString());
          final enable = maps['Enable'] == 'Yes';
          final host = maps['URL'] ?? '';
          return [NetworkProxyConf(type!, enable, host, -1)];
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

  Map<String, String> getProxyResult(String result) {
    final lines = result.split('\n');
    final entryList = lines.map((line) {
      final keySplit = line.indexOf(':');
      final key = line.substring(0, keySplit).trim();
      final value = line.substring(keySplit + 1).trim();
      return MapEntry(key, value);
    });
    return Map.fromEntries(entryList);
  }

  Future<bool> setServiceProxyEnable(
    String service,
    bool enable, {
    NetworkProxyType? type,
  }) async {
    switch (type) {
      case NetworkProxyType.http:
        final result = await Process.run(
          '/usr/sbin/networksetup',
          ['-setwebproxystate', service, enable ? 'on' : 'off'],
        );
        return result.exitCode == 0;
      case NetworkProxyType.https:
        final result = await Process.run(
          '/usr/sbin/networksetup',
          ['-setsecurewebproxystate', service, enable ? 'on' : 'off'],
        );
        return result.exitCode == 0;
      case NetworkProxyType.socks:
        final result = await Process.run(
          '/usr/sbin/networksetup',
          ['-setsocksfirewallproxystate', service, enable ? 'on' : 'off'],
        );
        return result.exitCode == 0;
      case NetworkProxyType.auto:
        final result = await Process.run(
          '/usr/sbin/networksetup',
          ['-setautoproxystate', service, enable ? 'on' : 'off'],
        );
        return result.exitCode == 0;
      default:
        return NetworkProxyType.values.asyncAny((element) async {
          return await setServiceProxyEnable(service, enable, type: element);
        });
    }
  }

  Future<bool> setServiceProxy(
    String service,
    NetworkProxyConf conf,
  ) async {
    switch (conf.type) {
      case NetworkProxyType.http:
        final result = await Process.run(
          '/usr/sbin/networksetup',
          ['-setwebproxy', service, conf.host, '${conf.port}'],
        );
        return result.exitCode == 0;
      case NetworkProxyType.https:
        final result = await Process.run(
          '/usr/sbin/networksetup',
          ['-setsecurewebproxy', service, conf.host, '${conf.port}'],
        );
        return result.exitCode == 0;
      case NetworkProxyType.socks:
        final result = await Process.run(
          '/usr/sbin/networksetup',
          ['-setsocksfirewallproxystate', service, conf.host, '${conf.port}'],
        );
        return result.exitCode == 0;
      case NetworkProxyType.auto:
        final result = await Process.run(
          '/usr/sbin/networksetup',
          ['-setautoproxyurl', service, conf.host],
        );
        return result.exitCode == 0;
      default:
        return NetworkProxyType.values.asyncAny((element) async {
          return await setServiceProxy(service, conf);
        });
    }
  }

  Future<List<String>> getServiceList() async {
    final resp = await Process.run(
      "/usr/sbin/networksetup",
      ["-listallnetworkservices"],
    );
    final lines = resp.stdout.toString().split("\n");
    lines.removeWhere((element) => element.contains("*"));
    return lines;
  }
}
