%{
#include "mix/lex.h"
#include <stdio.h>
#include <stdlib.h> // exit()

#define YYSTYPE union mix_token_info
#include "mix.tab.h"

    static struct mix_lex g_lex;

    /* mix token type => bison token type */
    static const int g_m2b_type[] = {
        YYUNDEF,
        0,

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

        BISON_KEYWORD_var,
        BISON_KEYWORD_let,
        BISON_KEYWORD_if,
        BISON_KEYWORD_else,
        BISON_KEYWORD_while,
        BISON_KEYWORD_do,
        BISON_KEYWORD_for,
        BISON_KEYWORD_in,
        BISON_KEYWORD_continue,
        BISON_KEYWORD_break,
        BISON_KEYWORD_return,
        BISON_KEYWORD_export,
        BISON_KEYWORD_import,
        BISON_KEYWORD_as,
        BISON_KEYWORD_func,
        BISON_KEYWORD_enum,
        BISON_KEYWORD_struct,
    };

    static int yylex() {
        mix_token_type_t type = mix_lex_get_next_token(&g_lex, &yylval);
        if (type == MIX_TT_CHAR) {
            if (yylval.c == EOF) {
                return YYEOF;
            }
            return yylval.c;
        }
        return g_m2b_type[type];
    }

    static void yyerror(const char *msg) {
        printf("error: %s\n", msg);
        exit(-1);
    }
        %}

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

%token BISON_KEYWORD_var
%token BISON_KEYWORD_let
%token BISON_KEYWORD_if
%token BISON_KEYWORD_else
%token BISON_KEYWORD_while
%token BISON_KEYWORD_do
%token BISON_KEYWORD_for
%token BISON_KEYWORD_in
%token BISON_KEYWORD_continue
%token BISON_KEYWORD_break
%token BISON_KEYWORD_return
%token BISON_KEYWORD_export
%token BISON_KEYWORD_import
%token BISON_KEYWORD_as
%token BISON_KEYWORD_func
%token BISON_KEYWORD_enum
%token BISON_KEYWORD_struct

%%

block : optional_statement_list

optional_statement_list : %empty
| optional_statement_list statement
| optional_statement_list export_statement

 /* --------------------------------------------------------------------------- */

statement : ";"
| expression ";"
| identifier_declaration_statement
| assignment_statement
| selection_statement
| iteration_statement
| jump_statement
| import_statement
| compound_statement
| enum_declaration
| struct_definition

identifier_declaration_statement : BISON_KEYWORD_var variable_declaration_list ";"
| BISON_KEYWORD_let variable_declaration_list ";"

assignment_statement : variable "=" expression ";"
| variable "=" braced_initializer ";"
| variable assignment_operator expression ";"

variable : BISON_SYM_IDENTIFIER
| postfix_expression "[" expression "]"
| postfix_expression "." BISON_SYM_IDENTIFIER

assignment_operator : BISON_OP_ADD_ASSIGN
| BISON_OP_SUB_ASSIGN
| BISON_OP_MUL_ASSIGN
| BISON_OP_DIV_ASSIGN
| BISON_OP_MOD_ASSIGN
| BISON_OP_AND_ASSIGN
| BISON_OP_OR_ASSIGN
| BISON_OP_XOR_ASSIGN
| BISON_OP_LSHIFT_ASSIGN
| BISON_OP_RSHIFT_ASSIGN

variable_declaration_list : variable_declaration
| variable_declaration_list "," variable_declaration

initializer_clause : BISON_SYM_IDENTIFIER "=" expression
| BISON_SYM_IDENTIFIER "=" braced_initializer

variable_declaration : BISON_SYM_IDENTIFIER
| initializer_clause

braced_initializer : "{" "}"
| "{" initializer_clause_list "}"
| "{" initializer_clause_list "," "}"

initializer_clause_list : initializer_clause
| initializer_clause_list "," initializer_clause

selection_statement : BISON_KEYWORD_if expression compound_statement
| BISON_KEYWORD_if expression compound_statement BISON_KEYWORD_else selection_statement
| BISON_KEYWORD_if expression compound_statement BISON_KEYWORD_else compound_statement

iteration_statement : BISON_KEYWORD_while expression compound_statement
| BISON_KEYWORD_do compound_statement BISON_KEYWORD_while expression ";"
| BISON_KEYWORD_for BISON_SYM_IDENTIFIER BISON_KEYWORD_in expression compound_statement

compound_statement : "{" optional_statement_list "}"

jump_statement : BISON_KEYWORD_continue ";"
| BISON_KEYWORD_break ";"
| BISON_KEYWORD_return ";"
| BISON_KEYWORD_return expression ";"

 /* --------------------------------------------------------------------------- */

export_statement : BISON_KEYWORD_export identifier_list ";"

identifier_list : BISON_SYM_IDENTIFIER
| identifier_list "," BISON_SYM_IDENTIFIER

import_statement : BISON_KEYWORD_import import_item_list ";"
| BISON_KEYWORD_import import_item BISON_KEYWORD_as BISON_SYM_IDENTIFIER ";"

import_item_list : import_item
| import_item_list "," import_item

import_item : BISON_SYM_IDENTIFIER
| nested_name_specifier BISON_SYM_IDENTIFIER

nested_name_specifier : BISON_SYM_IDENTIFIER BISON_SYM_SCOPE_SPECIFIER
| nested_name_specifier BISON_SYM_IDENTIFIER BISON_SYM_SCOPE_SPECIFIER

 /* --------------------------------------------------------------------------- */

expression : conditional_expression

conditional_expression : logical_or_expression
| logical_or_expression "?" conditional_expression ":" conditional_expression

logical_or_expression : logical_and_expression
| logical_or_expression BISON_OP_LOGICAL_OR logical_and_expression

logical_and_expression : inclusive_or_expression
| logical_and_expression BISON_OP_LOGICAL_AND inclusive_or_expression

inclusive_or_expression : exclusive_or_expression
| inclusive_or_expression "|" exclusive_or_expression

exclusive_or_expression : and_expression
| exclusive_or_expression "^" and_expression

and_expression : equality_expression
| and_expression "&" equality_expression

equality_expression : relational_expression
| equality_expression equality_operator relational_expression

equality_operator : BISON_OP_EQUAL | BISON_OP_NOT_EQUAL

relational_expression : shift_expression
| relational_expression relational_operator shift_expression

relational_operator : "<" | ">" | BISON_OP_LESS_EQUAL | BISON_OP_GREATER_EQUAL

shift_expression : additive_expression
| shift_expression shift_operator additive_expression

shift_operator : BISON_OP_LSHIFT | BISON_OP_RSHIFT

additive_expression : multiplicative_expression
| additive_expression additive_operator multiplicative_expression

additive_operator : "+" | "-"

multiplicative_expression : unary_expression
| multiplicative_expression multiplicative_operator unary_expression

multiplicative_operator : "*" | "/" | "%"

unary_expression : postfix_expression
| constant
| unary_operator unary_expression

unary_operator : arithmetic_unary_operator
| logical_unary_operator

arithmetic_unary_operator : '+' | '-' | '~'

logical_unary_operator : '!'

postfix_expression : variable
| "(" expression ")"
| lambda
| nested_name_specifier BISON_SYM_IDENTIFIER
| postfix_expression "(" expression_or_braced_initializer_list ")"
| postfix_expression "(" ")"

lambda : function_declaration compound_statement

function_declaration : BISON_KEYWORD_func "(" function_declaration_parameter_list ")"

function_declaration_parameter_list : %empty
| identifier_list

expression_or_braced_initializer_list : expression
| braced_initializer
| expression_or_braced_initializer_list "," expression
| expression_or_braced_initializer_list "," braced_initializer

constant : BISON_INTEGER
| BISON_FLOAT
| BISON_LITERAL_STRING

 /* --------------------------------------------------------------------------- */

enum_declaration : BISON_KEYWORD_enum "{" optional_enum_member_list "}"

optional_enum_member_list : %empty
| enum_member_list
| enum_member_list ','

enum_member_list : BISON_SYM_IDENTIFIER
| BISON_SYM_IDENTIFIER '=' BISON_INTEGER
| enum_member_list "," BISON_SYM_IDENTIFIER
| enum_member_list "," BISON_SYM_IDENTIFIER "=" BISON_INTEGER

 /* --------------------------------------------------------------------------- */

struct_definition : BISON_KEYWORD_struct BISON_SYM_IDENTIFIER "{" optional_struct_member_list "}"

optional_struct_member_list : %empty
| optional_struct_member_list identifier_declaration_statement

%%

#include "logger/stdio_logger.h"

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "usage: %s file\n", argv[0]);
        return -1;
    }

    struct stdio_logger logger;
    stdio_logger_init(&logger);
    mix_lex_init(&g_lex, argv[1], &logger.l);
    yyparse();
    mix_lex_destroy(&g_lex);
    stdio_logger_destroy(&logger);
    return 0;
 }
