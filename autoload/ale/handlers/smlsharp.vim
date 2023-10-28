" Author: Jake Zimmerman <jake@zimmerman.io>
" Description: Shared functions for SMLSharp linters

" Only one of smlsharp_stdin or smlsharp_file can be enabled at a time.
function! s:GetExecutable(buffer, source) abort
    let l:smi_path = expand('#' . a:buffer . ':r')
    if filereadable(l:smi_path . ".smi")
        " Found an SMI file; only allow smlsharp_file mode to be enabled
        if a:source is# 'smlsharp-stdin'
            return ''
        elseif a:source is# 'smlsharp-file'
            return 'smlsharp'
        endif
    else
        " No SMI file found; only allow smlsharp_stdin mode to be enabled
        if a:source is# 'smlsharp-stdin'
            return 'smlsharp'
        elseif a:source is# 'smlsharp-file'
            return ''
        endif
    endif
endfunction

function! ale#handlers#smlsharp#GetExecutableSmlsharpFile(buffer) abort
    return s:GetExecutable(a:buffer, 'smlsharp-file')
endfunction

function! ale#handlers#smlsharp#GetExecutableSmlsharpStdin(buffer) abort
    return s:GetExecutable(a:buffer, 'smlsharp-stdin')
endfunction

function! ale#handlers#smlsharp#Handle(buffer, lines) abort
    " Try to match basic smlsharp errors
    let l:out = []

    " foo.sml:3.8(28)-3.9(29) Error: (name evaluation "190") unbound variable: pp
    " (interactive):3.8-3.8(28) Error: (name evaluation "190") unbound variable: p
    let l:pattern = '^\([^:]*\):\(\d\+\)\.\(\d\+\)\((\d\+)\)\?-\(\d\+\)\.\(\d\+\)\((\d\+)\)\? \(Error\|Warning\):\(.*\)$'

    let l:cur_entry = {}

    for l:line in a:lines
        if l:cur_entry != {}
            let l:cur_entry.text .= l:line
            call add(l:out, l:cur_entry)
            let l:cur_entry = {}
            continue
        endif

        let l:match = matchlist(l:line, l:pattern)

        if len(l:match) != 0
            let l:cur_entry = {
                        \   'filename': l:match[1],
                        \   'lnum': l:match[2],
                        \   'col' : l:match[3] + 1,
                        \   'end_lnum': l:match[5],
                        \   'end_col' : l:match[6] + 1,
                        \   'type': l:match[8] =~# '^Warning' ? 'W' : 'E',
                        \   'text': l:match[8] . ':' . l:match[9],
                        \}

            if l:match[9] !=# ''
                call add(l:out, l:cur_entry)
                let l:cur_entry = {}
            endif
        endif
    endfor

    return l:out
endfunction

" vim:ts=4:sts=4:sw=4
