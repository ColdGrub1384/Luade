//
//  device.m
//  Luade
//
//  Created by Adrian Labbe on 12/5/18.
//  Copyright © 2018 Adrian Labbe. All rights reserved.
//

#include "device.h"
#import <UIKit/UIKit.h>

static int device_name(lua_State *L) {
    lua_pushstring(L, UIDevice.currentDevice.name.UTF8String);
    return 1;
}

static int device_systemName(lua_State *L) {
    lua_pushstring(L, UIDevice.currentDevice.systemName.UTF8String);
    return 1;
}

static int device_systemVersion(lua_State *L) {
    lua_pushstring(L, UIDevice.currentDevice.systemVersion.UTF8String);
    return 1;
}

static int device_model(lua_State *L) {
    lua_pushstring(L, UIDevice.currentDevice.model.UTF8String);
    return 1;
}

static int device_localizedModel(lua_State *L) {
    lua_pushstring(L, UIDevice.currentDevice.localizedModel.UTF8String);
    return 1;
}

static int device_isPortrait(lua_State *L) {
    lua_pushboolean(L, (UIDeviceOrientationIsPortrait(UIDevice.currentDevice.orientation)));
    return 1;
}

static int device_isLandscape(lua_State *L) {
    lua_pushboolean(L, (UIDeviceOrientationIsLandscape(UIDevice.currentDevice.orientation)));
    return 1;
}

static int device_batteryLevel(lua_State *L) {
    [UIDevice.currentDevice setBatteryMonitoringEnabled: YES];
    lua_pushnumber(L, UIDevice.currentDevice.batteryLevel);
    [UIDevice.currentDevice setBatteryMonitoringEnabled: NO];
    return 1;
}

static int device_isCharging(lua_State *L) {
    [UIDevice.currentDevice setBatteryMonitoringEnabled: YES];
    lua_pushboolean(L, (UIDevice.currentDevice.batteryState == UIDeviceBatteryStateFull || UIDevice.currentDevice.batteryState == UIDeviceBatteryStateCharging));
    [UIDevice.currentDevice setBatteryMonitoringEnabled: NO];
    return 1;
}

static const struct luaL_Reg device_functions[] = {
    
    { "name",           device_name           },
    { "systemName",     device_systemName     },
    { "systemVersion",  device_systemVersion  },
    { "model",          device_model          },
    { "localizedModel", device_localizedModel },
    { "isPortrait",     device_isPortrait     },
    { "isLandscape",    device_isLandscape    },
    { "batteryLevel",   device_batteryLevel   },
    { "isCharging",     device_isCharging     },
    { NULL,             NULL                  }
};

int luaopen_device(lua_State *L) {
    /* Create the metatable and put it on the stack. */
    luaL_newmetatable(L, "device");
    /* Duplicate the metatable on the stack (We know have 2). */
    lua_pushvalue(L, -1);
    /* Pop the first metatable off the stack and assign it to __index
     * of the second one. We set the metatable for the table to itself.
     * This is equivalent to the following in lua:
     * metatable = {}
     * metatable.__index = metatable
     */
    lua_setfield(L, -2, "__index");
    
    /* Register the object.func functions into the table that is at the top of the
     * stack. */
    luaL_newlib(L, device_functions);
    lua_setglobal(L, "device");
    
    return 0;
}
