import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:network_proxy/network_proxy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _networkProxyPlugin = NetworkProxy();
  final _hostInput = TextEditingController(text: '127.0.0.1');
  final _portInput = TextEditingController(text: '10808');
  NetworkProxyType _type = NetworkProxyType.socks;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _networkProxyPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              DropdownButton<NetworkProxyType>(
                value: _type,
                items: NetworkProxyType.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  _type = value;
                },
              ),
              TextField(
                controller: _hostInput,
              ),
              TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'\d+'))
                ],
                controller: _portInput,
              ),
              Row(
                children: [
                  TextButton(
                    child: const Text('Get Proxy'),
                    onPressed: () async {
                      final proxy = NetworkProxy();
                      final confList = await proxy.getProxy();
                      confList.removeWhere((element) => !element.enable);
                      for (final e in confList) {
                        print("item $e");
                      }
                      print("getProxy $confList");
                    },
                  ),
                  TextButton(
                    child: const Text('Set Proxy'),
                    onPressed: () async {
                      final proxy = NetworkProxy();
                      final result = await proxy.setProxy(
                        NetworkProxyConf(
                          true,
                          NetworkProxyType.http,
                          _hostInput.text,
                          int.parse(_portInput.text),
                          name: 'iPhone USB',
                        ),
                      );
                      print("setProxy $result");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
