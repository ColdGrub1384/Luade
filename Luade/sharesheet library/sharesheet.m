//
//  sharesheet.m
//  Luade
//
//  Created by Adrian Labbe on 12/5/18.
//  Copyright © 2018 Adrian Labbe. All rights reserved.
//

#include "sharesheet.h"
#include "lua_extensionContext.h"
#import <Foundation/Foundation.h>

static int sharesheet_string(lua_State *L) {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSExtensionItem *item = lua_extensionContext.inputItems[0];
    NSItemProvider *attachment = item.attachments[0];
    
    [attachment loadItemForTypeIdentifier:@"public.plain-text" options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
        
        NSString * _Nullable str = (NSString *)item;
        if ([str isKindOfClass: NSString.class]) {
            lua_pushstring(L, [str UTF8String]);
        } else {
            lua_pushnil(L);
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    if (lua_extensionContext) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    } else {
        lua_pushnil(L);
    }
    
    return 1;
}

static int sharesheet_url(lua_State *L) {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSExtensionItem *item = lua_extensionContext.inputItems[0];
    NSItemProvider *attachment = item.attachments[0];
    
    [attachment loadItemForTypeIdentifier:@"public.url" options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
        
        NSURL * _Nullable url = (NSURL *)item;
        
        if ([url isKindOfClass: NSURL.class]) {
            lua_pushstring(L, [[url absoluteString] UTF8String]);
        } else {
            lua_pushnil(L);
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    if (lua_extensionContext) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    } else {
        lua_pushnil(L);
    }
    
    return 1;
}

static int sharesheet_filePath(lua_State *L) {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSExtensionItem *item = lua_extensionContext.inputItems[0];
    NSItemProvider *attachment = item.attachments[0];
    
    [attachment loadInPlaceFileRepresentationForTypeIdentifier:@"public.content" completionHandler:^(NSURL * _Nullable url, BOOL isInPlace, NSError * _Nullable error) {
        
        NSString *path = url.path;
        
        [url startAccessingSecurityScopedResource];
        lua_pushstring(L, path.UTF8String);
            
        dispatch_semaphore_signal(semaphore);
    }];
    
    if (lua_extensionContext) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    } else {
        lua_pushnil(L);
    }
    
    return 1;
}

static const struct luaL_Reg sharesheet_functions[] = {
    
    { "string",   sharesheet_string    },
    { "url",      sharesheet_url       },
    { "filePath", sharesheet_filePath  },
    { NULL,       NULL                 }
};

int luaopen_sharesheet(lua_State *L) {
    /* Create the metatable and put it on the stack. */
    luaL_newmetatable(L, "sharesheet");
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
    luaL_newlib(L, sharesheet_functions);
    lua_setglobal(L, "sharesheet");
    
    return 0;
}
