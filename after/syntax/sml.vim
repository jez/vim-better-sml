" Vim filtype plugin
" Language: SML
" Maintainer: Jake Zimmerman <jake@zimmerman.io>
" Created: 16 Jul 2016
" License: MIT License
"
" Description:
"   Assorted improvements on syntax highlighting for SML
"
"
" Usage:
"   To allow Vim to conceal things like 'a -> α in SML, use:
"
"       au! FileType sml setlocal conceallevel=2
"
"   To not hide the tick in Greek type variables (i.e., use 'a -> 'α
"   instead of 'a -> α), add
"
"       let g:sml_greek_tyvar_show_tick = 1
"
"   to your vimrc.
"

" Initialize settings (just for consistency)
if !exists('g:sml_greek_tyvar_show_tick')
    let g:sml_greek_tyvar_show_tick = 0
endif

" Fix wonky highlighting for => operator
syn match smlOperator  "=>"

" Also highlight 'NOTE' and 'Note' in comments
syn keyword  smlTodo contained NOTE Note

" Highlight type variables (i.e., tokens that look like 'xyz).
syn match smlType "\<'\w\+\>" contains=smlGreekTyvar

" Add conceal characters for common Greek letters
" that are used for type variables.
hi def link smlGreekTyvar smlType
function! s:ConcealTyvar(tyvar, cchar)
    let l:tick = "'"
    if g:sml_greek_tyvar_show_tick
        let l:tick = '\%(' . l:tick . '\)\@<='
    endif
    " The pattern looks like  'a\>  or  \%('\)\@<=a\>, depending on the
    " value of `g:sml_greek_tyvar_show_tick`.
    let l:pattern = l:tick . a:tyvar . '\>'
    let l:options = 'contained conceal cchar=' . a:cchar
    let l:cmd = 'syn match smlGreekTyvar "' . l:pattern . '" ' . l:options
    exec l:cmd
endfunction

call s:ConcealTyvar('a', 'α')
call s:ConcealTyvar('alpha', 'α')
call s:ConcealTyvar('b', 'β')
call s:ConcealTyvar('beta', 'β')
call s:ConcealTyvar('c', 'γ')
call s:ConcealTyvar('gamma', 'γ')
call s:ConcealTyvar('d', 'δ')
call s:ConcealTyvar('delta', 'δ')
call s:ConcealTyvar('e', 'ε')
call s:ConcealTyvar('epsilon', 'ε')

call s:ConcealTyvar('zeta', 'ζ')
call s:ConcealTyvar('eta', 'η')
call s:ConcealTyvar('theta', 'θ')
call s:ConcealTyvar('kappa', 'κ')
call s:ConcealTyvar('lambda', 'λ')

call s:ConcealTyvar('m', 'μ')
call s:ConcealTyvar('mu', 'μ')
call s:ConcealTyvar('n', 'ν')
call s:ConcealTyvar('nu', 'ν')

call s:ConcealTyvar('xi', 'ξ')

call s:ConcealTyvar('p', 'π')
call s:ConcealTyvar('pi', 'π')
call s:ConcealTyvar('r', 'ρ')
call s:ConcealTyvar('rho', 'ρ')
call s:ConcealTyvar('s', 'σ')
call s:ConcealTyvar('sigma', 'σ')
call s:ConcealTyvar('t', 'τ')
call s:ConcealTyvar('tau', 'τ')

call s:ConcealTyvar('upsilon', 'υ')
call s:ConcealTyvar('phi', 'ϕ')
call s:ConcealTyvar('x', 'χ')
call s:ConcealTyvar('chi', 'χ')

call s:ConcealTyvar('psi', 'ψ')

call s:ConcealTyvar('w', 'ω')
call s:ConcealTyvar('omega', 'ω')

" --- Coneal lambda functions with lambda ---
" We need to redefine fn as a 'match', not a 'keyword' because 'keyword' takes
" precedence, but can't have 'contains'
syn clear smlKeyword

" These are copy/pasted from $VIMRUNTIME/syntax/sml.vim ...
if exists("sml_noend_error")
  syn match    smlKeyword    "\<end\>"
endif
syn region   smlKeyword start="\<signature\>" matchgroup=smlModule end="\<\w\(\w\|'\)*\>" contains=smlComment skipwhite skipempty nextgroup=smlMTDef
syn keyword  smlKeyword  and andalso case
syn keyword  smlKeyword  datatype else eqtype
" ... but this line is different: there's no fun or fn
syn keyword  smlKeyword  exception handle
syn keyword  smlKeyword  in infix infixl infixr
syn keyword  smlKeyword  match nonfix of orelse
syn keyword  smlKeyword  raise handle type
syn keyword  smlKeyword  val where while with withtype

" Finally, define fn with a 'match' not a 'keyword' for the 'contains='
syn match smlFunction "\<fn\>" contains=smlFnLam,smlFnDot
syn cluster smlContained add=smlFnLam,smlFnDot
" Hack: use two match groups, so we can simulate a two-character conceal
syn match smlFnLam "f"                 contained conceal cchar=λ
syn match smlFnDot "n"                 contained conceal cchar=.
" -------------------------------------------

" Define match group for SML function keywords
syn keyword smlFunction fun

" Color fun and fn as Function
hi def link smlFunction Function
hi def link smlFnLam Function
hi def link smlFnDot Function
