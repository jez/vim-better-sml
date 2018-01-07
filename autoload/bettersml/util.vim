" Utility functions for vim-better-sml
"
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 19 Mar 2017
" License: MIT License

let s:scriptroot = fnamemodify(resolve(expand('<sfile>:p')), ':h:h:h')

function! bettersml#util#GetVbsUtil() abort
  return s:scriptroot.'/bin/vbs-util'
endfunction

" Start in directory a:where and walk up the parent folders until it finds a
" file matching a:what; return path to that file
" Credit: vim-syntastic
function! bettersml#util#findGlobInParent(what, where) abort
    let here = fnamemodify(a:where, ':p')

    let root = '/'

    let old = ''
    while here !=# ''
        try
            " Vim 7.4.279 and later
            let p = globpath(here, a:what, 1, 1)
        catch /\m^Vim\%((\a\+)\)\=:E118/
            let p = split(globpath(here, a:what, 1), "\n")
        endtry

        if !empty(p)
            return fnamemodify(p[0], ':p')
        elseif here ==? root || here ==? old
            break
        endif

        let old = here

        " we use ':h:h' rather than ':h' since ':p' adds a trailing '/'
        " if 'here' is a directory
        let here = fnamemodify(here, ':p:h:h')
    endwhile

    return ''
endfunction

function! bettersml#util#LoadDefUse() abort
  return bettersml#util#findGlobInParent('*.du', expand('%:p:h', 1))
endfunction

" Ensure that the *.ud file is up-to-date
function! bettersml#util#LoadUseDef() abort
  let vbsUtil = bettersml#util#GetVbsUtil()
  if !executable(l:vbsUtil)
    echom "Have you built the support files?  :help vim-better-sml-def-use"
    return ''
  endif

  let duf = bettersml#util#LoadDefUse()

  " duf doesn't exist; ask user to build
  if l:duf ==# ''
    echom "You need to build a def-use file first.  :help vim-better-sml-def-use"
    return ''
  endif

  let udf = fnamemodify(l:duf, ':r').'.ud'

  " udf doesn't exist or out of date
  if !filereadable(l:udf) || getftime(l:duf) > getftime(l:udf)
    call system(l:vbsUtil.' invert '.l:duf.' > '.l:udf)
  endif

  return l:udf
endfunction

" Get line number and column in a format suitable
" for grepping in a def-use or use-def file
function! bettersml#util#SymLineCol() abort
  let l:sympos = getpos('.')
  return l:sympos[1] . '.' . l:sympos[2]
endfunction

function! bettersml#util#LoadConfig() abort
  " TODO(jez) We're hard-coding 'sml.json'.
  " Can we assume this will always be the config file name?
  return bettersml#util#findGlobInParent('sml.json', expand('%:p:h', 1))
endfunction

function! bettersml#util#GetCmFilePattern()
  let l:configFile = bettersml#util#LoadConfig()

  if l:configFile ==# ''
    return '*.cm'
  else
    let l:vbsUtil = bettersml#util#GetVbsUtil()

    if !executable(l:vbsUtil)
      echom "Detected an sml.json file, but the support files aren't executable."
      return '*.cm'
    else
      " Use systemlist(...)[0] to avoid trailing newlines
      let l:result = systemlist(l:vbsUtil.' config '.l:configFile.' cm.make/onSave')[0]

      if v:shell_error
        echom l:result
        return '*.cm'
      else
        return l:result
      endif
    endif
  endif
endfunction

function! bettersml#util#GetCmFileOrEmpty()
  let l:cmPattern = bettersml#util#GetCmFilePattern()
  return bettersml#util#findGlobInParent(l:cmPattern, expand('%:p:h', 1))
endfunction
