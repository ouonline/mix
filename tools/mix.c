#include "mix.tab.h"
#include "logger/stdio_logger.h"

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "usage: %s file\n", argv[0]);
        return -1;
    }

    struct stdio_logger logger;
    stdio_logger_init(&logger);

    mix_lex_init(&g_lex, argv[1]);

    struct mix_lex lex;
    yyparse(&lex);

    mix_lex_destroy(&g_lex);
    stdio_logger_destroy(&logger);

    return 0;
 }
