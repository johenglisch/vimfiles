" Vim Compiler File
" Compiler:	setuptools

if exists("current_compiler")
    finish
endif
let current_compiler = "setuptools"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

CompilerSet errorformat&		" use the default 'errorformat'
CompilerSet makeprg=pip\ --disable-pip-version-check\ install\ --no-deps\ --no-build-isolation\ -qe\ .

let &cpo = s:cpo_save
unlet s:cpo_save
