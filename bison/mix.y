%{
#include "lex.h"
#include "logger/logger.h"
#include "mix.tab.h"

/* mix token type => bison token type */
static const int g_m2b_type[] = {
    YYUNDEF,
    YYEOF,

    0, /* MIX_TT_CHAR */
    BISON_LITERAL_STRING,
    BISON_INTEGER,
    BISON_FLOAT,

    BISON_OP_ADD_ASSIGN,
    BISON_OP_SUB_ASSIGN,
    BISON_OP_MUL_ASSIGN,
    BISON_OP_DIV_ASSIGN,
    BISON_OP_MOD_ASSIGN,
    BISON_OP_AND_ASSIGN,
    BISON_OP_OR_ASSIGN,
    BISON_OP_XOR_ASSIGN,
    BISON_OP_LSHIFT_ASSIGN,
    BISON_OP_RSHIFT_ASSIGN,

    BISON_OP_LOGICAL_OR,
    BISON_OP_LOGICAL_AND,
    BISON_OP_EQUAL,
    BISON_OP_NOT_EQUAL,
    BISON_OP_LESS_EQUAL,
    BISON_OP_GREATER_EQUAL,
    BISON_OP_LSHIFT,
    BISON_OP_RSHIFT,

    BISON_SYM_IDENTIFIER,
    BISON_SYM_SCOPE_SPECIFIER,

    BISON_KEYWORD_as,
    BISON_KEYWORD_break,
    BISON_KEYWORD_continue,
    BISON_KEYWORD_do,
    BISON_KEYWORD_else,
    BISON_KEYWORD_export,
    BISON_KEYWORD_for,
    BISON_KEYWORD_func,
    BISON_KEYWORD_if,
    BISON_KEYWORD_import,
    BISON_KEYWORD_in,
    BISON_KEYWORD_return,
    BISON_KEYWORD_var,
    BISON_KEYWORD_while,
};

static int yylex(YYSTYPE* lvalp, struct mix_lex* lex) {
    mix_token_type_t type = mix_lex_get_next_token(lex, &lvalp->token);
    if (type == MIX_TT_EOF) {
        return YYEOF;
    }

    if (type == MIX_TT_CHAR) {
        return lvalp->token.c;
    }

    return g_m2b_type[type];
}

static void yyerror(struct mix_lex* lex, struct logger* l, const char *msg) {
    logger_error(l, "line [%u] column [%u] error: %s\n", lex->linenum, lex->lineoff, msg);
}
%}

// definition of YYSTYPE
%union {
    union mix_token_info token;
}

// reentrant yylex()
%define api.pure full

 // params of yylex()
%lex-param {struct mix_lex* lex}

// params of yyparse(), should include those passed to yylex()
%parse-param {struct mix_lex* lex} {struct logger* l}

// debug settings
%define parse.lac full
%define parse.error detailed
%define parse.trace

%token BISON_LITERAL_STRING
%token BISON_INTEGER
%token BISON_FLOAT

%token BISON_OP_ADD_ASSIGN
%token BISON_OP_SUB_ASSIGN
%token BISON_OP_MUL_ASSIGN
%token BISON_OP_DIV_ASSIGN
%token BISON_OP_MOD_ASSIGN
%token BISON_OP_AND_ASSIGN
%token BISON_OP_OR_ASSIGN
%token BISON_OP_XOR_ASSIGN
%token BISON_OP_LSHIFT_ASSIGN
%token BISON_OP_RSHIFT_ASSIGN

%token BISON_OP_LOGICAL_OR
%token BISON_OP_LOGICAL_AND
%token BISON_OP_EQUAL
%token BISON_OP_NOT_EQUAL
%token BISON_OP_GREATER_EQUAL
%token BISON_OP_LESS_EQUAL
%token BISON_OP_LSHIFT
%token BISON_OP_RSHIFT

%token BISON_SYM_IDENTIFIER
%token BISON_SYM_SCOPE_SPECIFIER

%token BISON_KEYWORD_as
%token BISON_KEYWORD_break
%token BISON_KEYWORD_continue
%token BISON_KEYWORD_do
%token BISON_KEYWORD_else
%token BISON_KEYWORD_export
%token BISON_KEYWORD_for
%token BISON_KEYWORD_func
%token BISON_KEYWORD_if
%token BISON_KEYWORD_import
%token BISON_KEYWORD_in
%token BISON_KEYWORD_return
%token BISON_KEYWORD_var
%token BISON_KEYWORD_while

%type <token> BISON_LITERAL_STRING
%type <token> BISON_INTEGER
%type <token> BISON_FLOAT

%type <token> BISON_OP_ADD_ASSIGN
%type <token> BISON_OP_SUB_ASSIGN
%type <token> BISON_OP_MUL_ASSIGN
%type <token> BISON_OP_DIV_ASSIGN
%type <token> BISON_OP_MOD_ASSIGN
%type <token> BISON_OP_AND_ASSIGN
%type <token> BISON_OP_OR_ASSIGN
%type <token> BISON_OP_XOR_ASSIGN
%type <token> BISON_OP_LSHIFT_ASSIGN
%type <token> BISON_OP_RSHIFT_ASSIGN

%type <token> BISON_OP_LOGICAL_OR
%type <token> BISON_OP_LOGICAL_AND
%type <token> BISON_OP_EQUAL
%type <token> BISON_OP_NOT_EQUAL
%type <token> BISON_OP_GREATER_EQUAL
%type <token> BISON_OP_LESS_EQUAL
%type <token> BISON_OP_LSHIFT
%type <token> BISON_OP_RSHIFT

%type <token> BISON_SYM_IDENTIFIER
%type <token> BISON_SYM_SCOPE_SPECIFIER

%type <token> BISON_KEYWORD_as
%type <token> BISON_KEYWORD_break
%type <token> BISON_KEYWORD_continue
%type <token> BISON_KEYWORD_do
%type <token> BISON_KEYWORD_else
%type <token> BISON_KEYWORD_export
%type <token> BISON_KEYWORD_for
%type <token> BISON_KEYWORD_func
%type <token> BISON_KEYWORD_if
%type <token> BISON_KEYWORD_import
%type <token> BISON_KEYWORD_in
%type <token> BISON_KEYWORD_return
%type <token> BISON_KEYWORD_var
%type <token> BISON_KEYWORD_while

%%

block
: optional_statement_list
;

optional_statement_list
: %empty
| optional_statement_list statement
| optional_statement_list export_statement
;

/* --------------------------------------------------------------------------- */

statement
: ';'
| expression ';'
| variable_declaration_statement
| assignment_statement
| selection_statement
| iteration_statement
| jump_statement
| import_statement
| compound_statement
| function_definition
;

variable_declaration_statement
: BISON_KEYWORD_var variable_declaration_list ';'
;

assignment_statement
: variable assignment_operator expression ';'
;

variable
: BISON_SYM_IDENTIFIER
| postfix_expression '[' expression ']'
| postfix_expression '.' BISON_SYM_IDENTIFIER
;

assignment_operator
: '='
| BISON_OP_ADD_ASSIGN
| BISON_OP_SUB_ASSIGN
| BISON_OP_MUL_ASSIGN
| BISON_OP_DIV_ASSIGN
| BISON_OP_MOD_ASSIGN
| BISON_OP_AND_ASSIGN
| BISON_OP_OR_ASSIGN
| BISON_OP_XOR_ASSIGN
| BISON_OP_LSHIFT_ASSIGN
| BISON_OP_RSHIFT_ASSIGN
;

variable_declaration_list
: variable_declaration
| variable_declaration_list ',' variable_declaration
;

variable_declaration
: BISON_SYM_IDENTIFIER
| BISON_SYM_IDENTIFIER '=' expression
;

selection_statement
: BISON_KEYWORD_if expression compound_statement
| BISON_KEYWORD_if expression compound_statement BISON_KEYWORD_else selection_statement
| BISON_KEYWORD_if expression compound_statement BISON_KEYWORD_else compound_statement
;

iteration_statement
: BISON_KEYWORD_while expression compound_statement
| BISON_KEYWORD_do compound_statement BISON_KEYWORD_while expression ';'
| BISON_KEYWORD_for BISON_SYM_IDENTIFIER BISON_KEYWORD_in expression compound_statement
;

compound_statement
: '{' optional_statement_list '}'
;

jump_statement
: BISON_KEYWORD_continue ';'
| BISON_KEYWORD_break ';'
| BISON_KEYWORD_return ';'
| BISON_KEYWORD_return expression ';'
;

/* --------------------------------------------------------------------------- */

export_statement
: BISON_KEYWORD_export identifier_list ';'
;

import_statement
: BISON_KEYWORD_import import_item_list ';'
| BISON_KEYWORD_import import_item BISON_KEYWORD_as BISON_SYM_IDENTIFIER ';'
;

import_item_list
: import_item
| import_item_list ',' import_item
;

import_item
: BISON_SYM_IDENTIFIER
| nested_name_specifier BISON_SYM_IDENTIFIER
;

nested_name_specifier
: BISON_SYM_IDENTIFIER BISON_SYM_SCOPE_SPECIFIER
| nested_name_specifier BISON_SYM_IDENTIFIER BISON_SYM_SCOPE_SPECIFIER
;

/* --------------------------------------------------------------------------- */

expression
: conditional_expression
;

conditional_expression
: logical_or_expression
| logical_or_expression '?' conditional_expression ':' conditional_expression
;

logical_or_expression
: logical_and_expression
| logical_or_expression BISON_OP_LOGICAL_OR logical_and_expression
;

logical_and_expression
: inclusive_or_expression
| logical_and_expression BISON_OP_LOGICAL_AND inclusive_or_expression
;

inclusive_or_expression
: exclusive_or_expression
| inclusive_or_expression '|' exclusive_or_expression
;

exclusive_or_expression
: and_expression
| exclusive_or_expression '^' and_expression
;

and_expression
: equality_expression
| and_expression '&' equality_expression
;

equality_expression
: relational_expression
| equality_expression equality_operator relational_expression
;

equality_operator
: BISON_OP_EQUAL | BISON_OP_NOT_EQUAL
;

relational_expression
: shift_expression
| relational_expression relational_operator shift_expression
;

relational_operator
: '<'
| '>'
| BISON_OP_LESS_EQUAL
| BISON_OP_GREATER_EQUAL
;

shift_expression
: additive_expression
| shift_expression shift_operator additive_expression
;

shift_operator
: BISON_OP_LSHIFT
| BISON_OP_RSHIFT
;

additive_expression
: multiplicative_expression
| additive_expression additive_operator multiplicative_expression
;

additive_operator
: '+' | '-'
;

multiplicative_expression
: unary_expression
| multiplicative_expression multiplicative_operator unary_expression
;

multiplicative_operator
: '*'
| '/'
| '%'
;

unary_expression
: postfix_expression
| constant
| unary_operator unary_expression
;

unary_operator
: arithmetic_unary_operator
| logical_unary_operator
;

arithmetic_unary_operator
: '+'
| '-'
| '~'
;

logical_unary_operator : '!'
;

postfix_expression
: variable
| '(' expression ')'
| lambda
| nested_name_specifier BISON_SYM_IDENTIFIER
| postfix_expression '(' expression_list ')'
| postfix_expression '(' ')'
;

lambda
: function_type compound_statement
;

function_type
: BISON_KEYWORD_func '(' optional_identifier_list ')'
;

expression_list
: expression
| expression_list ',' expression
;

constant
: BISON_INTEGER
| BISON_FLOAT
| BISON_LITERAL_STRING
;

/* --------------------------------------------------------------------------- */

function_definition
: function_declaration compound_statement
;

function_declaration
: BISON_KEYWORD_func BISON_SYM_IDENTIFIER '(' optional_identifier_list ')'
;

/* --------------------------------------------------------------------------- */

optional_identifier_list
: %empty
| identifier_list
;

identifier_list
: BISON_SYM_IDENTIFIER
| identifier_list ',' BISON_SYM_IDENTIFIER
;

%%
