# network_proxy

A plugin project that support get and set status of network proxy.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Mac

```shell
# Http
networksetup -getwebproxy <networkservice>
networksetup -setwebproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
networksetup -setwebproxystate <networkservice> <on off>
# Https
networksetup -getsecurewebproxy <networkservice>
networksetup -setsecurewebproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
networksetup -setsecurewebproxystate <networkservice> <on off>
# Socket
networksetup -getsocksfirewallproxy <networkservice>
networksetup -setsocksfirewallproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
networksetup -setsocksfirewallproxystate <networkservice> <on off>
# AutoProxy
networksetup -getautoproxyurl <networkservice>
networksetup -setautoproxyurl <networkservice> <url>
networksetup -setautoproxystate <networkservice> <on off>
networksetup -getproxyautodiscovery <networkservice>
networksetup -setproxyautodiscovery <networkservice> <on off>
```
## Future

[ ]- Android  
[ ]- iOS  

## Thanks

[system_network_proxy](https://github.com/liudonghua123/system_network_proxy)  
[platform_proxy](https://gitlab.com/yamsergey/platform_proxy)  
