let s:zig_tags = expand('~/repos/ziglang/zig/tags')

if filereadable(s:zig_tags)
    exec 'setlocal tags+=' . s:zig_tags
endif

function s:RunZigTests() abort
    let l:saved_makeprg = &makeprg
    let &makeprg = 'zig build test'
    make!
    let &makeprg = l:saved_makeprg
endfunction

command -buffer RunZigTests :call s:RunZigTests()

nnoremap <buffer> <cr> :<c-u>make!<cr>
nnoremap <buffer> <backspace> :<c-u>RunZigTests<cr>
