import 'dart:io';

import 'package:network_proxy_interface/network_proxy_method_channel.dart';
import 'package:network_proxy_interface/network_proxy_platform_interface.dart';

/// An implementation of the NetworkProxyPlatform of the NetworkProxy plugin.
/// ```cmd
/// reg query 'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings' /v ProxyEnable
/// reg query 'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings' /v ProxyServer
/// reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings' /v ProxyEnable /t REG_DWORD /f /d 0
/// reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings' /v ProxyEnable /t REG_DWORD /f /d 1
/// reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings' /v ProxyServer /f /d <http://proxy.host:port>
/// ```
class NetworkProxyWindows extends MethodChannelNetworkProxy {
  @override
  Future<bool> getProxyEnable({NetworkProxyType? type}) async {
    try {
      var result = await Process.run('reg', [
        'query',
        'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings',
        '/v',
        'ProxyEnable',
      ]);
      var enableLine = getProxyLines(result.stdout.toString())
          .where((item) => item.contains('ProxyEnable'))
          .first;
      return enableLine.substring(enableLine.length - 1) == '1';
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> setProxyEnable(bool enable, {NetworkProxyType? type}) async {
    try {
      var result = await Process.run('reg', [
        'add',
        'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings',
        '/v',
        'ProxyEnable',
        '/t',
        'REG_DWORD',
        '/f',
        '/d',
        enable ? '1' : '0',
      ]);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<NetworkProxyConf>> getProxy({
    NetworkProxyType? type,
  }) async {
    try {
      final enable = await getProxyEnable();
      final result = await Process.run('reg', [
        'query',
        'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings',
        '/v',
        'ProxyServer',
      ]);
      final serverLine = getProxyLines(result.stdout.toString())
          .where((item) => item.contains('ProxyServer'))
          .first;
      final serverGroup = serverLine.split(RegExp(r"\s+"));
      // TODO: parse server
      print('serverLine $serverLine');
      final type = NetworkProxyType.http;
      final host = '127.0.0.1';
      final port = 8080;
      return [NetworkProxyConf(enable, type, host, port)];
    } catch (e) {
      return List.empty();
    }
  }

  @override
  Future<bool> setProxy(NetworkProxyConf conf) async {
    final enable = conf.enable;

    return await setInternetProxy(conf) && await setProxyEnable(enable);
  }

  Future<bool> setInternetProxy(
    NetworkProxyConf conf,
  ) async {
    try {
      final server = '${conf.name}://${conf.host}:${conf.port}';
      var result = await Process.run('reg', [
        'add',
        'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings',
        '/v',
        'ProxyServer',
        '/f',
        '/d',
        server,
      ]);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  Iterable<String> getProxyLines(String result) {
    final lines = result.split('\r\n').where(
      (element) {
        return element.trim().isNotEmpty;
      },
    );
    return lines;
  }
}
