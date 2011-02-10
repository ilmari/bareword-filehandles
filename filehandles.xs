#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "hook_op_check.h"

#ifndef PERL_UNUSED_ARG
# define PERL_UNUSED_ARG(x) PERL_UNUSED_VAR(x)
#endif /* !PERL_UNUSED_ARG */

#ifndef hv_fetchs
# define hv_fetchs(hv, key, lval) hv_fetch(hv, key, strlen(key), lval)
#endif /* !hv_fetchs */

STATIC OP *bareword_filehandles_unary_check_op (pTHX_ OP *op, void *user_data) {
    SV **hint = hv_fetchs(GvHV(PL_hintgv), "bareword::filehandles", 0);
    const OP *first;

    PERL_UNUSED_ARG(user_data);

    if (!hint || !SvOK(*hint))
        return op;

    /* what, no kids? */
    if (!(op->op_flags & OPf_KIDS))
	return op;

    first = cUNOPx(op)->op_first;
    if (first && first->op_type == OP_GV)
        croak("Use of bareword filehandle in %s", OP_DESC(op));

    return op;
}

STATIC OP *bareword_filehandles_stat_check_op (pTHX_ OP *op, void *user_data) {
    SV **hint = hv_fetchs(GvHV(PL_hintgv), "bareword::filehandles", 0);

    PERL_UNUSED_ARG(user_data);

    if (!hint || !SvOK(*hint))
        return op;

    if (op->op_flags & OPf_REF && cGVOPx_gv(op) != PL_defgv)
	croak("Use of bareword filehandle in %s", OP_DESC(op));

    return op;
}

STATIC OP *bareword_filehandles_list_check_op (pTHX_ OP *op, void *user_data) {
    SV **hint = hv_fetchs(GvHV(PL_hintgv), "bareword::filehandles", 0);
    const OP *first, *next;

    PERL_UNUSED_ARG(user_data);

    if (!hint || !SvOK(*hint))
        return op;

    first = cLISTOPx(op)->op_first;
    next = first->op_sibling;
    if (first && (first->op_type == OP_PUSHMARK || first->op_type == OP_NULL)
        && next && next->op_type == OP_GV
    ) {
        croak("Use of bareword filehandle in %s", OP_DESC(op));
    }

    return op;
}

MODULE = bareword::filehandles PACKAGE = bareword::filehandles

PROTOTYPES: ENABLE

#define bareword_check(type, op) \
    hook_op_check(op, bareword_filehandles_##type##_check_op, NULL);

BOOT:
    bareword_check(unary, OP_CLOSE);
    bareword_check(unary, OP_CLOSEDIR);
    bareword_check(unary, OP_ENTERWRITE);
    bareword_check(unary, OP_EOF);
    bareword_check(unary, OP_FILENO);
    bareword_check(unary, OP_GETC);
    bareword_check(unary, OP_GETPEERNAME);
    bareword_check(unary, OP_GETSOCKNAME);
    bareword_check(unary, OP_READDIR);
    bareword_check(unary, OP_READLINE);
    bareword_check(unary, OP_REWINDDIR);
    bareword_check(unary, OP_TELL);
    bareword_check(unary, OP_TELLDIR);

    bareword_check(list, OP_ACCEPT);
    bareword_check(list, OP_BIND);
    bareword_check(list, OP_BINMODE);
    bareword_check(list, OP_CONNECT);
    bareword_check(list, OP_FCNTL);
    bareword_check(list, OP_FLOCK);
    bareword_check(list, OP_GSOCKOPT);
    bareword_check(list, OP_IOCTL);
    bareword_check(list, OP_LISTEN);
    bareword_check(list, OP_OPEN);
    bareword_check(list, OP_OPEN_DIR);
    bareword_check(list, OP_READ);
    bareword_check(list, OP_RECV);
    bareword_check(list, OP_SEEK);
    bareword_check(list, OP_SEEKDIR);
    bareword_check(list, OP_SELECT);
    bareword_check(list, OP_SEND);
    bareword_check(list, OP_SHUTDOWN);
    bareword_check(list, OP_SOCKET);
    bareword_check(list, OP_SOCKPAIR);
    bareword_check(list, OP_SSOCKOPT);
    bareword_check(list, OP_SYSREAD);
    bareword_check(list, OP_SYSSEEK);
    bareword_check(list, OP_SYSWRITE);

    bareword_check(stat, OP_STAT);
    bareword_check(stat, OP_LSTAT);
    bareword_check(stat, OP_FTRREAD);
    bareword_check(stat, OP_FTRWRITE);
    bareword_check(stat, OP_FTREXEC);
    bareword_check(stat, OP_FTEREAD);
    bareword_check(stat, OP_FTEWRITE);
    bareword_check(stat, OP_FTEEXEC);
    bareword_check(stat, OP_FTIS);
    bareword_check(stat, OP_FTSIZE);
    bareword_check(stat, OP_FTMTIME);
    bareword_check(stat, OP_FTATIME);
    bareword_check(stat, OP_FTCTIME);
    bareword_check(stat, OP_FTROWNED);
    bareword_check(stat, OP_FTEOWNED);
    bareword_check(stat, OP_FTZERO);
    bareword_check(stat, OP_FTSOCK);
    bareword_check(stat, OP_FTCHR);
    bareword_check(stat, OP_FTBLK);
    bareword_check(stat, OP_FTFILE);
    bareword_check(stat, OP_FTDIR);
    bareword_check(stat, OP_FTPIPE);
    bareword_check(stat, OP_FTSUID);
    bareword_check(stat, OP_FTSGID);
    bareword_check(stat, OP_FTSVTX);
    bareword_check(stat, OP_FTLINK);
    bareword_check(stat, OP_FTTTY);
    bareword_check(stat, OP_FTTEXT);
    bareword_check(stat, OP_FTBINARY);
