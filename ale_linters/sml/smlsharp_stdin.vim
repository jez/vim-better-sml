" Author: Jake Zimmerman <jake@zimmerman.io>
" Description: Single-file SML checking with SMLSharp compiler

" Commented out until we there's a better way to detect that we're for sure in
" an SMLSharp project.

" call ale#linter#Define('sml', {
" \   'name': 'smlsharp_stdin',
" \   'aliases': ['smlsharp-stdin'],
" \   'executable': function('ale#handlers#smlsharp#GetExecutableSmlsharpStdin'),
" \   'command': 'smlsharp -ftypecheck-only',
" \   'output_stream': 'stderr',
" \   'callback': 'ale#handlers#smlsharp#Handle',
" \})
