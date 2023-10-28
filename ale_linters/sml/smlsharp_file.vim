" Author: Jake Zimmerman <jake@zimmerman.io>
" Description: Whole-project SMLSharp checking

" Using file mode requires that we set "lint_file: 1", since it reads the files
" from the disk itself.
call ale#linter#Define('sml', {
\   'name': 'smlsharp_file',
\   'aliases': ['smlsharp-file'],
\   'executable': function('ale#handlers#smlsharp#GetExecutableSmlsharpFile'),
\   'lint_file': 1,
\   'command': 'smlsharp -ftypecheck-only %s',
\   'output_stream': 'stderr',
\   'callback': 'ale#handlers#smlsharp#Handle',
\})

" vim:ts=4:sts=4:sw=4
