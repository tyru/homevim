" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal noexpandtab shiftwidth=0 tabstop=4

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal expandtab< shiftwidth< tabstop<'

let &cpo = s:save_cpo
