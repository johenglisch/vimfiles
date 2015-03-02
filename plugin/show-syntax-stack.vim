function! GetSyntaxStack(line, col)
    let names = []
    for syntax_id in synstack(a:line, a:col)
        let names += [synIDattr(syntax_id, 'name')]
    endfor
    return names
endfunction

command! EchoSyntaxStackAtPoint echo GetSyntaxStack(line('.'), col('.'))
