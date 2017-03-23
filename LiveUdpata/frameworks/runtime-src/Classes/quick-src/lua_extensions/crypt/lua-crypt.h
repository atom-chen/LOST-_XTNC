
#ifndef __LUA_CRYPT_H_
#define __LUA_CRYPT_H_

#if __cplusplus
extern "C" {
#endif

#include "lauxlib.h"
#include "lua.h"

LUALIB_API int luaopen_crypt(lua_State *L);

#if __cplusplus
}
#endif

#endif // __LUA_CRYPT_H_
