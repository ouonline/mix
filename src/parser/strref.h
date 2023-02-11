#ifndef __MIX_PARSER_STRREF_H__
#define __MIX_PARSER_STRREF_H__

#include <stdint.h>

struct strref {
    uint32_t off;
    uint32_t len;
};

static inline void strref_reset(struct strref* r) {
    r->off = 0;
    r->len = 0;
}

#endif
