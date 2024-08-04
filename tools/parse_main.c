#include "utils.h"
#include "lex.h"
#include "logger/stdio_logger.h"
#include "mix.tab.h"

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "usage: %s file\n", argv[0]);
        return -1;
    }

    struct stdio_logger logger;
    stdio_logger_init(&logger);

    uint32_t file_sz = 0;
    char* buf = read_file_content(argv[1], &file_sz);
    if (!buf) {
        return -1;
    }

    struct mix_lex lex;
    mix_lex_init(&lex, buf, file_sz);
    yyparse(&lex, &logger.l);
    mix_lex_destroy(&lex);

    return 0;
}
