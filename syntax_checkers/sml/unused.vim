" Syntastic checker for unused variables
"
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 20 Mar 2017
" License: MIT License
"

if exists('g:loaded_syntastic_sml_unused_checker')
    finish
endif
let g:loaded_syntastic_sml_mlton_unused_checker = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:sml_show_all_unused_warnings')
  let g:sml_show_all_unused_warnings = 0
endif

if !exists('g:sml_show_all_unused_warnings')
  let g:sml_show_all_unused_warnings = 0
endif

if !exists('g:sml_hide_cmlib_unused_warnings')
  let g:sml_hide_cmlib_unused_warnings = 0
endif

function! BetterSMLFilterUnused(err_lines) abort
  let result = a:err_lines
  if !g:sml_show_all_unused_warnings
    let currentFile = resolve(expand('%:p'))
    let result = filter(l:result, 'v:val =~? l:currentFile')
  endif

  if g:sml_hide_cmlib_unused_warnings
    let result = filter(l:result, 'v:val !~? "cmlib"')
  endif

  return l:result
endfunction

function! SyntaxCheckers_sml_unused_IsAvailable() dict abort
  return executable(self.getExec())
        \ && filereadable(bettersml#util#LoadDefUse())
endfunction

function! SyntaxCheckers_sml_unused_GetLocList() dict abort

  let duf = bettersml#util#LoadDefUse()

  let makeprg = self.makeprgBuild({
        \ 'args': 'unused ' . syntastic#util#shescape(l:duf),
        \ 'fname': '' })

  let errorformat  = '%tarning: %f %l\.%c %m'

  return SyntasticMake({
        \ 'Preprocess': 'BetterSMLFilterUnused',
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat })

endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
      \ 'filetype': 'sml',
      \ 'name': 'unused',
      \ 'exec': bettersml#util#GetVbsUtil() })

let &cpo = s:save_cpo
unlet s:save_cpo


