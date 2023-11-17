#include "include/network_proxy/network_proxy_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "network_proxy_plugin.h"

void NetworkProxyPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  network_proxy::NetworkProxyPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
