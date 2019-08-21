" Vim filtype plugin
" Language: SML
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 08 Mar 2016
" License: MIT License

" Use apostrophes in variable names (useful for things like ^P (completion),
" ^W (back delete word), etc.)
setlocal iskeyword+='
" '$' is valid as or in a variable name
setlocal iskeyword+=$
" '#' is valid in projections (like #1 or #foo)
setlocal iskeyword+=#

" Set comment string so things like vim-commentary and foldmethod can use them
" appropriately.
setlocal commentstring=(*%s*)

" The default lprolog filetype plugin that ships with Vim interferes with SML.
" To fight back, we explicitly turn off the formatprg here.
setlocal formatprg=

augroup vimbettersmlinternal
  au!
  " Automatically build def use file on save
  if g:sml_auto_create_def_use !=# 'never'
    au BufWritePost <buffer> call bettersml#process#BuildDefUse()
  endif
augroup END

" ----- Raimondi/delimitMate -----
" Single quotes are part of identifiers, and shouldn't always come in pairs.
let b:delimitMate_quotes = '"'

" ----- scrooloose/syntastic -----
" Attempt to detect CM files in SML/NJ checker
if exists('g:loaded_syntastic_plugin')
    let s:cm = bettersml#util#GetCmFileOrEmpty()
    if s:cm !=# ''
      let s:buf = bufnr('')
      call setbufvar(s:buf, 'syntastic_sml_smlnj_fname', '')
      call setbufvar(s:buf, 'syntastic_sml_smlnj_post_args', '-m ' . syntastic#util#shescape(s:cm))
    endif
endif

" ----- w0rp/ale -----
" Set b:sml_smlnj_cm_file using config from JSON file
if exists('g:loaded_ale')
  let s:buf = bufnr('')
  call setbufvar(s:buf, 'ale_sml_smlnj_cm_file', bettersml#util#GetCmFilePattern())
endif

" ----- a.vim -----
" Sets up *.sig and *.sml files as "alternates", similar to how *.h and *.c
" files are alternates
let g:alternateExtensions_sml = 'sig'
let g:alternateExtensions_sig = 'sml'

