#ifndef __MIX_PARSER_MIX_PARSER_AUX_H__
#define __MIX_PARSER_MIX_PARSER_AUX_H__

#include "mix/mix_retcode_t.h"
#include "cutils/robin_hood_hash.h"
#include "cutils/vector.h"
#include "logger/logger.h"

struct mix_parser_aux {
    /* struct strref* => struct mix_scope_id_info* */
    struct robin_hood_hash var_info_hash;
    /* hash of strings in mix_eval_env::strbuf. struct qbuf* => (off, len) */
    struct robin_hood_hash strhash;
    /* struct strref* => struct mix_scope_id_info* */
    struct robin_hood_hash type_info_hash;
    /* struct mix_scope_id_info in [level][idx] */
    struct vector scope_var_list;
    /* struct mix_scope_id_info in [level][idx] */
    struct vector scope_type_list;
};

mix_retcode_t mix_parser_aux_init(struct mix_parser_aux*, struct logger*);
void mix_parser_aux_destroy(struct mix_parser_aux*);

#endif
