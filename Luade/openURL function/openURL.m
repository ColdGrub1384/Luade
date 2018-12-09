//
//  openURL.m
//  Luade
//
//  Created by Adrian Labbe on 12/9/18.
//  Copyright © 2018 Adrian Labbe. All rights reserved.
//

#include "openURL.h"
#import <UIKit/UIKit.h>

int openURL(lua_State *L) {
    if (lua_gettop(L) != 1 || !lua_isstring(L, 1)) {
        return luaL_error(L, "Expected a string as parameter.");
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithUTF8String:lua_tostring(L, 1)]];
    
    if (!url) {
        return luaL_error(L, "Invalid URL.");
    }
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication.sharedApplication openURL:url options:[NSDictionary dictionary] completionHandler:^(BOOL success) {
            
            dispatch_semaphore_signal(semaphore);
            lua_pushboolean(L, success);
        }];
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return 1;
}

void luaopen_openURL(lua_State *L) {
    lua_register(L, "openURL", openURL);
}
