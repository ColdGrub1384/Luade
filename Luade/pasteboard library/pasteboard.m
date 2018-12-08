//
//  device.m
//  Luade
//
//  Created by Adrian Labbe on 12/5/18.
//  Copyright © 2018 Adrian Labbe. All rights reserved.
//

#include "pasteboard.h"
#import <UIKit/UIKit.h>

static int pasteboard_string(lua_State *L) {
    lua_pushstring(L, UIPasteboard.generalPasteboard.string.UTF8String);
    return 1;
}

static int pasteboard_setString(lua_State *L) {
    
    const char* expected = "Expected a string as argument.";
    
    if (lua_gettop(L) != 1) {
        return luaL_error(L, expected);
    } else if (!lua_isstring(L, 1)) {
        return luaL_error(L, expected);
    }
    
    [UIPasteboard.generalPasteboard setString: [NSString stringWithUTF8String:lua_tostring(L, 1)]];
    
    return 0;
}

static int pasteboard_strings(lua_State *L) {
    
    int i;
    
    NSArray<NSString *> *strings = UIPasteboard.generalPasteboard.strings;
    const char* arr[strings.count];
    
    for (i=0; i<strings.count; i++) {
        arr[i] = strings[i].UTF8String;
    }
    
    lua_newtable(L);
    for (i=0; i<strings.count; i++) {
        lua_pushnumber(L, i);
        lua_pushstring(L, arr[i]);
        lua_settable(L, -3);
    }
    return 1;
}

static int pasteboard_setStrings(lua_State *L) {
    
    NSMutableArray<NSString *> *strings = [NSMutableArray array];
    
    int argc = lua_gettop(L);
    for (int i = 1; i <= argc; i++) {
        [strings addObject:[NSString stringWithUTF8String: lua_tostring(L, i)]];
    }
    
    [UIPasteboard.generalPasteboard setStrings:strings];
    
    return 0;
}

static const struct luaL_Reg pasteboard_functions[] = {
    
    { "string",     pasteboard_string     },
    { "setString",  pasteboard_setString  },
    { "strings",    pasteboard_strings    },
    { "setStrings", pasteboard_setStrings },
    { NULL,         NULL                  }
};

int luaopen_pasteboard(lua_State *L) {
    /* Create the metatable and put it on the stack. */
    luaL_newmetatable(L, "pasteboard");
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
    luaL_newlib(L, pasteboard_functions);
    lua_setglobal(L, "pasteboard");
    
    return 0;
}
