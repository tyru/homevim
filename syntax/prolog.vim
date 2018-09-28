
let g:prolog_highlighting_no_keyword = 1

source $VIMRUNTIME/syntax/prolog.vim

unlet g:prolog_highlighting_no_keyword

syn keyword prologKeyword asserta
syn keyword prologKeyword assertz
syn keyword prologKeyword at_end_of_stream
syn keyword prologKeyword consult
syn keyword prologKeyword discontiguous
syn keyword prologKeyword dynamic
syn keyword prologKeyword fail
syn keyword prologKeyword false
syn keyword prologKeyword halt
syn keyword prologKeyword initialization
syn keyword prologKeyword meta_predicate
syn keyword prologKeyword module
syn keyword prologKeyword multifile
syn keyword prologKeyword op
syn keyword prologKeyword repeat
syn keyword prologKeyword true
syn keyword prologKeyword unify_with_occurs_check
syn keyword prologKeyword use_module
