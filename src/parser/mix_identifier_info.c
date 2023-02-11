#include "mix_identifier_info.h"
#include <stdlib.h>

struct mix_identifier_info* mix_identifier_info_new() {
    struct mix_identifier_info* info = malloc(sizeof(struct mix_identifier_info));
    if (info) {
        strref_reset(&info->name);
        vector_init(&info->scope_list, sizeof(struct mix_scope_id_info));
    }
    return info;
}

static void __destroy_id_info(void* item, void* nil) {
    struct mix_scope_id_info* info = item;
    mix_type_release(info->type);
}

void mix_identifier_info_delete(struct mix_identifier_info* info) {
    if (info) {
        vector_destroy(&info->scope_list, NULL, __destroy_id_info);
        free(info);
    }
}
