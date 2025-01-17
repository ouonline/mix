#ifndef __MIX_TOKEN_TYPE_H__
#define __MIX_TOKEN_TYPE_H__

enum {
    MIX_TT_INVALID = 0,
    MIX_TT_EOF,

    MIX_TT_CHAR,
    MIX_TT_LITERAL_STRING,
    MIX_TT_INTEGER,
    MIX_TT_FLOAT,

    MIX_TT_OP_ADD_ASSIGN,           /* += */
    MIX_TT_OP_SUB_ASSIGN,           /* -= */
    MIX_TT_OP_MUL_ASSIGN,           /* *= */
    MIX_TT_OP_DIV_ASSIGN,           /* /= */
    MIX_TT_OP_MOD_ASSIGN,           /* %= */
    MIX_TT_OP_AND_ASSIGN,           /* &= */
    MIX_TT_OP_OR_ASSIGN,            /* |= */
    MIX_TT_OP_XOR_ASSIGN,           /* ^= */
    MIX_TT_OP_LSHIFT_ASSIGN,        /* <<= */
    MIX_TT_OP_RSHIFT_ASSIGN,        /* >>= */

    MIX_TT_OP_LOGICAL_OR,           /* || */
    MIX_TT_OP_LOGICAL_AND,          /* && */
    MIX_TT_OP_EQUAL,                /* == */
    MIX_TT_OP_NOT_EQUAL,            /* != */
    MIX_TT_OP_LESS_EQUAL,           /* <= */
    MIX_TT_OP_GREATER_EQUAL,        /* >= */
    MIX_TT_OP_LSHIFT,               /* << */
    MIX_TT_OP_RSHIFT,               /* >> */

    MIX_TT_SYM_IDENTIFIER,          /* */
    MIX_TT_SYM_SCOPE_SPECIFIER,     /* :: */

    MIX_TT_KEYWORD_as,
    MIX_TT_KEYWORD_break,
    MIX_TT_KEYWORD_continue,
    MIX_TT_KEYWORD_do,
    MIX_TT_KEYWORD_else,
    MIX_TT_KEYWORD_export,
    MIX_TT_KEYWORD_for,
    MIX_TT_KEYWORD_func,
    MIX_TT_KEYWORD_if,
    MIX_TT_KEYWORD_import,
    MIX_TT_KEYWORD_in,
    MIX_TT_KEYWORD_return,
    MIX_TT_KEYWORD_var,
    MIX_TT_KEYWORD_while,
};

typedef unsigned int mix_token_type_t;

#endif
