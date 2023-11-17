#ifndef FLUTTER_PLUGIN_NETWORK_PROXY_PLUGIN_H_
#define FLUTTER_PLUGIN_NETWORK_PROXY_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

typedef struct _NetworkProxyPlugin NetworkProxyPlugin;
typedef struct {
  GObjectClass parent_class;
} NetworkProxyPluginClass;

FLUTTER_PLUGIN_EXPORT GType network_proxy_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void network_proxy_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_NETWORK_PROXY_PLUGIN_H_
