" Vim Compiler File
" Compiler:	flake8

if exists("current_compiler")
    finish
endif
let current_compiler = "flake8"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

" TODO: proper error format
CompilerSet errorformat&
CompilerSet makeprg=python3\ -m\ flake8

let &cpo = s:cpo_save
unlet s:cpo_save
