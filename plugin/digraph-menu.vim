scriptencoding utf-8


function! DigraphMenu() abort
    let l:char1 = nr2char(getchar())

    " abort on <esc>
    if char2nr(l:char1) == 27
        return ''
    endif

    " FIXME Digraph pattern is still suboptimal
    "
    " Example: '>H ☞  9758  0u ☺  9786'
    "  - >H gets parsed to ['>H', 97580]
    "  - 0u doesn't show up at all

    let l:pattern = '\C\V\(' . l:char1 . '\S\|\S' . l:char1 . '\) \.\S\*\s\+\(\d\{1,5\}\)'

    " XXX Is there a way to get access to the actual digraph table in vimscript?
    "
    " Manually parsing the output of the :digraph command just blows...  There
    " must be a better way.™

    let l:digraph_table = []
    let l:digraph_str = execute('digraphs')
    call substitute(l:digraph_str, l:pattern, '\=add(l:digraph_table, [submatch(1), str2nr(submatch(2))])', 'g')

    let l:digraph_display = ''
    let l:line_length = 0
    for l:mapping in l:digraph_table
        let l:item = l:mapping[0] . ' ' . nr2char(l:mapping[1]) . "\t"

        if l:line_length + strdisplaywidth(l:item) > &columns
            let l:line_length = 0
            let l:digraph_display .= "\n"
        endif

        let l:line_length += strdisplaywidth(l:item)
        let l:digraph_display .= l:item
    endfor

    echo l:digraph_display

    let l:char2 = nr2char(getchar())

    " abort on <esc>
    if char2nr(l:char2) == 27
        return ''
    endif

    return '' . l:char1 . l:char2
endfunction
