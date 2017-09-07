function! g:MoveLine(distance)
    let dest = line('.') + a:distance
    let dest = (dest >= 0) ? dest : 0
    let dest = (dest <= line('$')) ? dest : line('$')
    exec 'move ' . dest
endfunction
