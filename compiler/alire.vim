" Vim Compiler File
" Compiler:	alire

if exists("current_compiler")
    finish
endif
let current_compiler = "alire"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

CompilerSet errorformat&		" use the default 'errorformat'

" FIXME: There Must Be a Better Way™
CompilerSet makeprg=alr\ --no-tty\ build\ 2>&1\ \\\|\ sed\ -nE\ 's/^[^:]+:[0-9]+:[0-9]+:/src\\/&/p'

let &cpo = s:cpo_save
unlet s:cpo_save
