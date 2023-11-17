#ifndef FLUTTER_PLUGIN_NETWORK_PROXY_PLUGIN_H_
#define FLUTTER_PLUGIN_NETWORK_PROXY_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace network_proxy {

class NetworkProxyPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  NetworkProxyPlugin();

  virtual ~NetworkProxyPlugin();

  // Disallow copy and assign.
  NetworkProxyPlugin(const NetworkProxyPlugin&) = delete;
  NetworkProxyPlugin& operator=(const NetworkProxyPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace network_proxy

#endif  // FLUTTER_PLUGIN_NETWORK_PROXY_PLUGIN_H_
