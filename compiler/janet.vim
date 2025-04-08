" Vim Compiler File
" Compiler:	janet

if exists("current_compiler")
    finish
endif
let current_compiler = "janet"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

CompilerSet errorformat=error:\ %f:%l:%c:\ %m
CompilerSet makeprg=janet\ -k\ %

let &cpo = s:cpo_save
unlet s:cpo_save
