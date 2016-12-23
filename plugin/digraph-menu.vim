function! s:GetExactDigraph(digraph_table, char1, char2)
    let digraph = a:char1 . a:char2

    for mapping in a:digraph_table
        if mapping[0] ==# digraph
            return nr2char(mapping[1])
        endif
    endfor

    return a:char2
endfunction


function! DigraphMenu()
    let first_char = nr2char(getchar())

    let digraph_str = execute('digraphs')
    let pattern = '\C\V\(' . first_char . '\S\|\S' . first_char . '\) \.\S\*\s\+\(\d\{1,5\}\)'

    let digraph_table = []
    call substitute(digraph_str, pattern, '\=add(digraph_table, [submatch(1), str2nr(submatch(2))])', 'g')

    let digraph_display = ''
    let line_length = 0
    for mapping in digraph_table
        let item = mapping[0] . ' ' . nr2char(mapping[1]) . "\t"

        if line_length + strdisplaywidth(item) > &columns
            let line_length = 0
            let digraph_display .= "\n"
        endif

        let line_length += strdisplaywidth(item)
        let digraph_display .= item
    endfor

    echo digraph_display

    let second_char = nr2char(getchar())

    let result = <sid>GetExactDigraph(digraph_table, first_char, second_char)
    if result !=# second_char
        return result
    endif

    let result = <sid>GetExactDigraph(digraph_table, second_char, first_char)
    if result !=# first_char
        return result
    endif

    return second_char
endfunction
