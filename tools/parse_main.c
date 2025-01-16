#include "utils.h"
#include "lex.h"
#include "logger/stdout_logger.h"
#include "mix.tab.h"

int main(int argc, char* argv[]) {
    int ret = 0;

    if (argc != 2) {
        fprintf(stderr, "usage: %s file\n", argv[0]);
        return -1;
    }

    struct stdout_logger logger;
    stdout_logger_init(&logger);

    uint32_t file_sz = 0;
    char* buf = read_file_content(argv[1], &file_sz);
    if (!buf) {
        logger_error(&logger.l, "cannot open [%s]\n", argv[1]);
        ret = -1;
        goto end;
    }

    struct mix_lex lex;
    mix_lex_init(&lex, buf, file_sz);

    ret = yyparse(&lex, &logger.l);

    free(buf);
    mix_lex_destroy(&lex);
end:
    stdout_logger_destroy(&logger);

    return ret;
}
