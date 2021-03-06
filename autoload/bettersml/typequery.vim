" Query expression type information from Vim
"
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 19 Mar 2017
" License: MIT License
"

function! bettersml#typequery#TypeQuery() abort
  " Need to make sure use def is up-to-date to do the type query
  let udf = bettersml#util#LoadUseDef()
  if l:udf ==# ''
    return
  endif

  " Move the cursor to the beginning of the current word
  normal lb

  " Get position of current symbol, and file it occurs in
  let l:symlinecol = bettersml#util#SymLineCol()
  let l:symfile = resolve(expand('%:p'))

  " Use a bash oneliner to search in the use-def file
  let l:symloc = fnameescape(l:symfile).' '.l:symlinecol
  let l:symdef = system('fgrep -w -A1 "'.l:symloc.'" '.l:udf.' | head -n 2 | tail -n +2')

  if l:symdef ==# ''
    if getftime(expand('%')) > getftime(l:udf)
      let shortudf = fnamemodify(l:udf, ':t')
      echom 'No results. Is the def-use file out of date?'
    else
      echom 'Search for definition information returned no results.'
    endif
    return
  endif

  let parsed = split(l:symdef)

  if l:parsed[0] ==# 'variable' ||
        \ l:parsed[0] ==# 'constructor' ||
        \ l:parsed[0] ==# 'exception'
    let quoted = join(l:parsed[4:])
    let unquoted = strpart(l:quoted, 1, len(l:quoted) - 2)
    echom l:unquoted
  else
    echom l:parsed[0]
  endif
endfunction

