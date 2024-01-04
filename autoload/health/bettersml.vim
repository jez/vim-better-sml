" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 20 Aug 2018
" License: MIT License
"
" Health checks to determine if the plugin and environment are configured
" properly.
"
" On Neovim, uses Neovim's :checkhealth functionality.
" On Vim, approximates the feature.

function! s:ReportStart(name) abort
  if exists('*v:lua.vim.health.start()')
    call v:lua.vim.health.start(a:name)
  else
    echom '## '.a:name
  endif
endfunction

function! s:ReportOk(msg) abort
  if exists('*v:lua.vim.health.ok()')
    call v:lua.vim.health.ok(a:msg)
  else
    echom '  - ok: '.a:msg
  endif
endfunction

function! s:ReportWarn(msg, suggestions) abort
  if exists('*v:lua.vim.health.warn()')
    call v:lua.vim.health.warn(a:msg, a:suggestions)
  else
    echom '  - warn: '.a:msg
    for l:suggestion in a:suggestions
      echom '      - '.l:suggestion
    endfor
  endif
endfunction

function! s:ReportError(msg, suggestions) abort
  if exists('*v:lua.vim.health.error()')
    call v:lua.vim.health.error(a:msg, a:suggestions)
  else
    echom '  - error: '.a:msg
    for l:suggestion in a:suggestions
      echom '      - '.l:suggestion
    endfor
  endif
endfunction

function! s:ReportCheck(check) abort
  let [l:severity, l:msg, l:suggestions] = a:check

  if l:severity ==# 'ok'
    call s:ReportOk(l:msg)
  elseif l:severity ==# 'warn'
    call s:ReportWarn(l:msg, l:suggestions)
  elseif l:severity ==# 'error'
    call s:ReportError(l:msg, l:suggestions)
  else
    throw 'Unrecognized check severity: '.l:severity
  endif
endfunction

function! health#bettersml#check() abort
  call s:ReportStart('REPL')

  call s:ReportCheck(bettersml#process#CheckBackend())
  call s:ReportCheck(bettersml#check#Smlnj())
  call s:ReportCheck(bettersml#check#Rlwrap())

  call s:ReportStart('Type information')

  call s:ReportCheck(bettersml#check#Mlton())
  call s:ReportCheck(bettersml#check#Support())

  let l:hasMlton = bettersml#check#Mlton()[0] ==# 'ok'
  let l:hasJobs = bettersml#check#JobStart()[0] ==# 'ok'
  if l:hasMlton && l:hasJobs
    " will attempt to compile vbs-util if not compiled
    call bettersml#util#GetVbsUtil()
  endif

  call s:ReportStart('General')

  call s:ReportCheck(bettersml#check#JobStart())
  call s:ReportCheck(bettersml#check#MLB())
  call s:ReportCheck(bettersml#check#Diagnostics())
endfunction


