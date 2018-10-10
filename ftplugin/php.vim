" Vim filetype plugin file
" Language:	php
" Maintainer:	Dan Sharp <dwsharp at users dot sourceforge dot net>
" Last Changed: 20 Jan 2009
" URL:		http://dwsharp.users.sourceforge.net/vim/ftplugin

if exists("b:did_ftplugin") | finish | endif

" Make sure the continuation lines below do not cause problems in
" compatibility mode.
let s:keepcpo= &cpo
set cpo&vim

" Define some defaults in case the included ftplugins don't set them.
let s:undo_ftplugin = ""
let s:browsefilter = "HTML Files (*.html, *.htm)\t*.html;*.htm\n" .
	    \	     "All Files (*.*)\t*.*\n"
let s:match_words = ""

runtime! ftplugin/html.vim ftplugin/html_*.vim ftplugin/html/*.vim
let b:did_ftplugin = 1

" Override our defaults if these were set by an included ftplugin.
if exists("b:undo_ftplugin")
    let s:undo_ftplugin = b:undo_ftplugin
endif
if exists("b:browsefilter")
    let s:browsefilter = b:browsefilter
endif
if exists("b:match_words")
    let s:match_words = b:match_words
endif
if exists("b:match_skip")
    unlet b:match_skip
endif

" Change the :browse e filter to primarily show PHP-related files.
if has("gui_win32")
    let  b:browsefilter="PHP Files (*.php)\t*.php\n" . s:browsefilter
endif

" ###
" Provided by Mikolaj Machowski <mikmach at wp dot pl>
setlocal include=\\\(require\\\|include\\\)\\\(_once\\\)\\\?
" Disabled changing 'iskeyword', it breaks a command such as "*"
" setlocal iskeyword+=$

if exists("loaded_matchit")
    let b:match_words = '<?php:?>,\<switch\>:\<endswitch\>,' .
		      \ '\<if\>:\<elseif\>:\<else\>:\<endif\>,' .
		      \ '\<while\>:\<endwhile\>,' .
		      \ '\<do\>:\<while\>,' .
		      \ '\<for\>:\<endfor\>,' .
		      \ '\<foreach\>:\<endforeach\>,' .
                      \ '(:),[:],{:},' .
		      \ s:match_words
endif
" ###

if exists('&omnifunc')
  setlocal omnifunc=phpcomplete#CompletePHP
endif

" Section jumping: [[ and ]] provided by:
" * Antony Scriven <adscriven at gmail dot com>
" * Takuya Fujiwara <tyru dot exe at gmail dot com>
" Operator-pending mappings are linewise (:help linewise)
nnoremap <buffer><silent> [[  :<C-u>call <SID>searchSection('sbW')<CR>
onoremap <buffer><silent> [[ V:<C-u>call <SID>searchSection('sbW')<CR>
nnoremap <buffer><silent> ]]  :<C-u>call <SID>searchSection('sW')<CR>
onoremap <buffer><silent> ]] V:<C-u>call <SID>searchSection('sW')<CR>
nnoremap <buffer><silent> []  :<C-u>call <SID>searchDeclEnd(1)<CR>
onoremap <buffer><silent> [] V:<C-u>call <SID>searchDeclEnd(1)<CR>
nnoremap <buffer><silent> ][  :<C-u>call <SID>searchDeclEnd(0)<CR>
onoremap <buffer><silent> ][ V:<C-u>call <SID>searchDeclEnd(0)<CR>

let s:function = '\%(abstract\s\+\|final\s\+\|private\s\+\|protected\s\+\|public\s\+\|static\s\+\)*function'
let s:class = '\%(abstract\s\+\|final\s\+\)*class'
let s:interface = 'interface'
let s:section = '\%(.*\%#\)\@!\_^\s*\zs\%('.s:function.'\|'.s:class.'\|'.s:interface.'\)'

function! s:searchSection(flags) abort
  return search(s:section, a:flags)
endfunction

function! s:searchDeclEnd(backward) abort
  let prevpos = getcurpos()
  let ok = 0
  try
    if s:doSearchDeclEnd(a:backward)
      let ok = 1
    endif
  finally
    " Save to jumplist
    let nextpos = s:curpos()
    call setpos('.', prevpos)
    if ok
      call s:move(nextpos)
    endif
  endtry
endfunction

function! s:doSearchDeclEnd(backward) abort
  let curpos = s:curpos()
  let [begin, end] = s:searchBlock('bcW')
  if a:backward
    if s:between(begin, curpos, end)
      return s:searchSection('bW') && s:searchSection('bW') && s:searchEndBlock()
    else
      return 1
    endif
  else
    if s:between(begin, curpos, end) && curpos[0] < end[0]
      return 1
    else
      return s:searchSection('W') && s:searchEndBlock()
    endif
  endif
endfunction

function! s:searchBlock(flags) abort
  if !s:searchSection(a:flags)
    return [0, 0]
  endif
  let begin = s:curpos()
  if !s:searchEndBlock()
    return [0, 0]
  endif
  let end = s:curpos()
  return [begin, end]
endfunction

" NOTE: This function must be called on the declaration line
function! s:searchEndBlock() abort
  let pos = s:curpos()
  " if '{' is after section, jump to matched '}'
  keepjumps normal! f{
  if s:curpos() !=# pos
    keepjumps normal! %
    return 1
  endif
  " Otherwise the next non-blank line should have '{'
  normal! j
  if search('\%' . nextnonblank('.') . 'l^\s*\zs{')
    keepjumps normal! %
    return 1
  endif
  return 0
endfunction

function! s:curpos() abort
  return getcurpos()[1:2]
endfunction

function! s:between(begin, pos, end) abort
  return a:begin[0] <=# a:pos[0] && a:pos[0] <=# a:end[0]
endfunction

" This function also updates jumplist (setpos() and cursor() doesn't update it)
function! s:move(pos) abort
  let [lnum, col] = a:pos
  let offset = line2byte(lnum)
  execute printf('normal! %dgo', offset + col - 1)
endfunction

setlocal commentstring=/*%s*/

" Undo the stuff we changed.
let b:undo_ftplugin = "setlocal commentstring< include< omnifunc<" .
	    \	      " | unlet! b:browsefilter b:match_words | " .
	    \	      s:undo_ftplugin

" Restore the saved compatibility options.
let &cpo = s:keepcpo
unlet s:keepcpo
