augroup VimBetterSMLFtDetect
  autocmd!
  autocmd BufRead,BufNewFile *.sig setlocal filetype=sml
  autocmd BufRead,BufNewFile *.fun setlocal filetype=sml
  autocmd BufRead,BufNewFile *.lex set filetype=mllex
  autocmd BufRead,BufNewFile *.grm set filetype=mlyacc
  autocmd BufRead,BufNewFile *.cm setlocal filetype=smlcm
  autocmd BufRead,BufNewFile *.mlb setlocal filetype=mlbasis
  autocmd BufRead,BufNewFile *.smackspec set filetype=smackspec
  autocmd BufRead,BufNewFile *.smi set filetype=sml
augroup END
