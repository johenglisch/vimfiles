function! s:ArchiveRange(filename) range abort
    exec a:firstline . ',' . a:lastline . 'write >> ' . expand(a:filename)
    exec a:firstline . ',' . a:lastline . 'delete'
endfunction

command! -range -nargs=1 -complete=file Archive <line1>,<line2>call s:ArchiveRange(<args>)
