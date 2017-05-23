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

command! SMLTypeQuery call bettersml#typequery#TypeQuery()
command! SMLJumpToDef call bettersml#jumptodef#JumpToDef()

" ----- Raimondi/delimitMate -----
" Single quotes are part of identifiers, and shouldn't always come in pairs.
let b:delimitMate_quotes = '"'

" ----- scrooloose/syntastic -----
" Attempt to detect CM files in SML/NJ checker
if exists('g:loaded_syntastic_plugin')
    let s:smlnj_args = ''
    if exists('g:syntastic_sml_no_polyeq') && g:syntastic_sml_no_polyeq != 0
      echo "hello kek"
      let s:smlnj_args .= '-Ccontrol.poly-eq-warn=false '
    endif
    let s:cm = syntastic#util#findGlobInParent('*.cm', expand('%:p:h', 1))
    if s:cm !=# ''
      let s:buf = bufnr('')
      let s:smlnj_args .= '-m ' . syntastic#util#shescape(s:cm)
      " It might be neater to make this only happen once or something
      call setbufvar(s:buf, 'syntastic_sml_smlnj_args', s:smlnj_args)
      call setbufvar(s:buf, 'syntastic_sml_smlnj_fname', '')
    else
      call setbufvar(s:buf, 'syntastic_sml_smlnj_args', s:smlnj_args)
    endif
endif

" ----- a.vim -----
" Sets up *.sig and *.sml files as "alternates", similar to how *.h and *.c
" files are alternates
let g:alternateExtensions_sml = 'sig'
let g:alternateExtensions_sig = 'sml'

