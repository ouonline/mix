#ifndef __MIX_PARSER_MIX_IDENTIFIER_INFO_H__
#define __MIX_PARSER_MIX_IDENTIFIER_INFO_H__

#include "common/mix_type.h"
#include "strref.h"
#include <stdint.h>

struct mix_scope_id_info {
    struct mix_type* type;
    uint32_t level;
    uint32_t idx;
};

struct mix_identifier_info {
    struct strref name; /* reference to mix_eval_env::strbuf */

    /*
      list of struct mix_scope_id_info
      levels are in ascending order and start from 0
    */
    struct vector scope_list;
};

struct mix_identifier_info* mix_identifier_info_new();
void mix_identifier_info_delete(struct mix_identifier_info*);

#endif
