" Vim Compiler File
" Compiler:	ruff

if exists("current_compiler")
    finish
endif
let current_compiler = "ruff"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

" TODO: proper error format
CompilerSet errorformat&
CompilerSet makeprg=ruff\ check\ --output-format\ concise

let &cpo = s:cpo_save
unlet s:cpo_save
