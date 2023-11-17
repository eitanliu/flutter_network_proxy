//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <network_proxy_linux/network_proxy_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) network_proxy_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "NetworkProxyPlugin");
  network_proxy_plugin_register_with_registrar(network_proxy_linux_registrar);
}
