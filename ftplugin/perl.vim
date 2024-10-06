if !exists('current_compiler')
    compiler perl
endif

function! s:PerlCritic(...) abort
    let l:files = []
    for l:file in a:000
        call extend(l:files, split(expand(l:file), "\n"))
    endfor
    compiler perlcritic
    if len(l:files) > 0
        exec 'make! ' . join(l:files, ' ')
    else
        make! %
    endif
    compiler perl
endfunction

command! -buffer -nargs=* PerlCritic :call s:PerlCritic(<args>)

nnoremap <buffer> <cr> :<c-u>make! %<cr>
nnoremap <buffer> <bs> :<c-u>PerlCritic '%'<cr>
