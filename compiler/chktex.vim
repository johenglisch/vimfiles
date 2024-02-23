" Vim Compiler File
" Compiler:	chktex

if exists("current_compiler")
    finish
endif
let current_compiler = "chktex"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

CompilerSet errorformat=%f:%l:%c:%m
CompilerSet makeprg=chktex\ -qv0

let &cpo = s:cpo_save
unlet s:cpo_save
