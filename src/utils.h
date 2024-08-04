#ifndef __MIX_UTILS_H__
#define __MIX_UTILS_H__

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

static inline unsigned long get_file_size(FILE* fp) {
    unsigned long pos = ftell(fp);
    fseek(fp, 0, SEEK_END);
    unsigned long bytes = ftell(fp);
    fseek(fp, pos, SEEK_SET);
    return bytes;
}

static inline char* read_file_content(const char* fpath, uint32_t* len) {
    FILE* fp = fopen(fpath, "r");
    if (!fp) {
        return NULL;
    }

    uint32_t sz = get_file_size(fp);
    char* mem = malloc(sz);
    if (!mem) {
        goto end;
    }

    fread(mem, 1, sz, fp);
    *len = sz;

end:
    fclose(fp);
    return mem;
}

#endif
