//
//  device.h
//  Luade
//
//  Created by Adrian Labbe on 12/5/18.
//  Copyright © 2018 Adrian Labbe. All rights reserved.
//

#include "../lua/lua.h"
#include "../lua/lauxlib.h"

/// Opens the 'device' module.
int luaopen_pasteboard(lua_State *L);
