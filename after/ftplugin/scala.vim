" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

runtime! ftplugin/java.vim
runtime! compiler/java.vim

setlocal includeexpr=substitute(v:fname,"\\.","/","g")
setlocal suffixesadd=.scala
setlocal suffixes+=.class
setlocal includeexpr+=tr(v:fname,'.','/')
setlocal comments& comments^=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//%s
setlocal formatoptions-=t formatoptions+=croql
setlocal makeprg=
setlocal dictionary=$MYVIMDIR/dict/scala.dict

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal includeexpr< suffixesadd< suffixes< includeexpr< '
\                   . 'comments< commentstring< formatoptions< makeprg< '
\                   . 'dictionary<'

if executable('scalafmt')
  setlocal equalprg=scalafmt\ --stdin\ --quiet
endif
let b:undo_ftplugin .= ' equalprg<'

let &cpo = s:save_cpo
