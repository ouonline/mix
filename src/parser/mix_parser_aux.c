#include "mix_parser_aux.h"
#include "mix_identifier_info.h"

static const void* id_info_getkey_func(const void* value) {
    const struct mix_identifier_info* info = value;
    return &info->name;
}

static int id_info_equal_func(const void* a, const void* b) {
    const struct strref *ra = a, *rb = b;
    return (ra->off == rb->off && ra->len == rb->len) ? 0 : 1;
}

static unsigned long id_info_hash_func(const void* key) {
    const struct strref* r = key;
    return (r->off + r->len);
}

static const struct robin_hood_hash_operations g_id_info_hash_ops = {
    .getkey = id_info_getkey_func,
    .equal = id_info_equal_func,
    .hash = id_info_hash_func,
};

mix_retcode_t mix_parser_aux_init(struct mix_parser_aux* p, struct logger* logger) {
    int err = robin_hood_hash_init(&p->var_info_hash, 20,
                                   ROBIN_HOOD_HASH_DEFAULT_MAX_LOAD_FACTOR,
                                   &g_id_info_hash_ops);
    if (err) {
        logger_error(logger, "init var info hash failed.");
        goto err1;
    }

    err = robin_hood_hash_init(&p->type_info_hash, 20,
                               ROBIN_HOOD_HASH_DEFAULT_MAX_LOAD_FACTOR,
                               &g_id_info_hash_ops);
    if (err) {
        logger_error(logger, "init type info hash failed.");
        goto err2;
    }

    vector_init(&p->scope_var_list, sizeof(struct mix_scope_id_info*));
    vector_init(&p->scope_type_list, sizeof(struct mix_scope_id_info*));

    return MIX_RC_OK;

err2:
    robin_hood_hash_destroy(&p->var_info_hash, NULL, NULL);
err1:
    return MIX_RC_INTERNAL_ERROR;
}

void mix_parser_aux_destroy(struct mix_parser_aux* p) {
    /* TODO */
}
