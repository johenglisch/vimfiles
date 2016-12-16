function! DigraphMenu()
    let first_char = nr2char(getchar())

    let digraph_str = execute('digraphs')
    let pattern = '\C\v(' . first_char . '\S).{-}(\d+)'

    let digraph_list = []
    call substitute(digraph_str, pattern, '\=add(digraph_list, [submatch(1), str2nr(submatch(2))])', 'g')

    let digraph_disp = ''
    let line_length = 0
    for mapping in digraph_list
        let item = mapping[0] . ' ' . nr2char(mapping[1]) . "\t"

        if line_length + strdisplaywidth(item) > &columns
            let line_length = 0
            let digraph_disp .= "\n"
        endif

        let line_length += strdisplaywidth(item)
        let digraph_disp .= item
    endfor

    echo digraph_disp

    let second_char = nr2char(getchar())

    let digraph = first_char . second_char
    for mapping in digraph_list
        if mapping[0] ==# digraph
            return nr2char(mapping[1])
        endif
    endfor

    return second_char
endfunction
