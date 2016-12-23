function! s:GetExactDigraph(digraph_table, char1, char2)
    let digraph = a:char1 . a:char2

    for mapping in a:digraph_table
        if mapping[0] ==# digraph
            return nr2char(mapping[1])
        endif
    endfor

    return a:char2
endfunction


function! s:GetDigraph(digraph_table, char1, char2)
    let result = <sid>GetExactDigraph(a:digraph_table, a:char1, a:char2)
    if result !=# a:char2
        return result
    endif

    let result = <sid>GetExactDigraph(a:digraph_table, a:char2, a:char1)
    if result !=# a:char1
        return result
    endif

    return a:char2
endfunction


function! DigraphMenu()
    let char1 = nr2char(getchar())

    " abort on <esc>
    if char2nr(char1) == 27
        return ''
    endif

    " FIXME Digraph pattern is still suboptimal
    "
    " Example: '>H ☞  9758  0u ☺  9786'
    "  - >H gets parsed to ['>H', 97580]
    "  - 0u doesn't show up at all

    let pattern = '\C\V\(' . char1 . '\S\|\S' . char1 . '\) \.\S\*\s\+\(\d\{1,5\}\)'

    " XXX Is there a way to get access to the actual digraph table in vimscript?
    "
    " Manually parsing the output of the :digraph command just blows...  There
    " must be a better way.™

    let digraph_table = []
    let digraph_str = execute('digraphs')
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

    let char2 = nr2char(getchar())

    " abort on <esc>
    if char2nr(char2) == 27
        return ''
    endif

    return <sid>GetDigraph(digraph_table, char1, char2)
endfunction
