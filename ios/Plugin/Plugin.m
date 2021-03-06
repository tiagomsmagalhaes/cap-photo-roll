#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(PhotoRoll, "PhotoRoll",
           CAP_PLUGIN_METHOD(hasLibraryPermission,  CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getPhotos,  CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getLastPhotoTaken,     CAPPluginReturnPromise);
)
