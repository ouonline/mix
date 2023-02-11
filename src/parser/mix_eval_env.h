#ifndef __MIX_PARSER_MIX_EVAL_ENV_H__
#define __MIX_PARSER_MIX_EVAL_ENV_H__

#include "mix/mix_retcode_t.h"
#include "runtime/mix_context.h"
#include "cutils/qbuf.h"

struct mix_eval_env {
    struct mix_context* ctx;
    struct qbuf strbuf;
};

mix_retcode_t mix_eval_env_init(struct mix_eval_env*, struct mix_context*);
mix_retcode_t mix_eval_env_parse(struct mix_eval_env*, const char* buf, uint32_t sz);
void mix_eval_env_destroy(struct mix_eval_env*);

#endif
