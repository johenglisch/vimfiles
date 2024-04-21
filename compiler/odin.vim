" Vim Compiler File
" Compiler:	odin

if exists("current_compiler")
    finish
endif
let current_compiler = "odin"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

CompilerSet errorformat=%f(%l:%c)\ %m
CompilerSet makeprg=odin\ build\ .\ -debug\ -vet\ -vet-style\ -vet-semicolon\ -strict-style\ -terse-errors

let &cpo = s:cpo_save
unlet s:cpo_save
