
let g:prolog_highlighting_no_keyword = 1

source $VIMRUNTIME/syntax/prolog.vim

unlet g:prolog_highlighting_no_keyword

syn keyword  prologKeyword module meta_predicate multifile dynamic
syn keyword  prologKeyword asserta assertz repeat halt op at_end_of_stream unify_with_occurs_check true fail false initialization consult use_module
