#include "mix_eval_env.h"
#include "misc/qbuf_ref_hash_utils.h"

/* -------------------------------------------------------------------------- */

static const void* str_hash_getkey_func(const void* value) {
    return value;
}

static const struct robin_hood_hash_operations g_env_ops = {
    .equal = qbuf_ref_equal_func,
    .hash = qbuf_ref_hash_func,
    .getkey = str_hash_getkey_func,
};

mix_retcode_t mix_eval_env_init(struct mix_eval_env* env, struct mix_context* ctx) {
    env->ctx = ctx;
    qbuf_init(&env->strbuf);
    return MIX_RC_OK;
}

void mix_eval_env_destroy(struct mix_eval_env* env) {
    if (env) {
        qbuf_destroy(&env->strbuf);
    }
}

/* -------------------------------------------------------------------------- */

#include "lex/mix_lex.h"
#include "parser/mix_parser_aux.h"
#include "mix.tab.h"

mix_retcode_t mix_eval_env_parse(struct mix_eval_env* env, const char* buf, uint32_t sz) {
    struct mix_parser_aux parser;
    mix_retcode_t rc = mix_parser_aux_init(&parser, env->ctx->logger);
    if (rc != MIX_RC_OK) {
        logger_error(env->ctx->logger, "init parser aux failed: %s.", mix_get_retcode_str(rc));
        return rc;
    }

    struct mix_lex lex;
    mix_lex_init(&lex, buf, sz);

    int ret = yyparse(env, &lex, &parser, buf, sz, env->ctx->logger);

    mix_lex_destroy(&lex);
    mix_parser_aux_destroy(&parser);

    if (ret == YYerror) {
        logger_error(env->ctx->logger, "parse failed.");
        return MIX_RC_INTERNAL_ERROR;
    }

    return MIX_RC_OK;
}
