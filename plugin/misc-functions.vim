function! Clamp(value, min, max)
    return min([a:max, max([a:min, a:value])])
endfunction

function! FilledString(length, filler)
    if empty(a:filler)
        echoerr 'Empty fill string'
        return ''
    endif

    let new_string = repeat(a:filler, a:length / strlen(a:filler))
    if strlen(new_string) < a:length
        let new_string .= a:filler[:a:length - strlen(new_string) - 1]
    endif

    return new_string
endfunction

function! Strip(string)
    return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction


function! s:ArchiveRange(filename) range abort
    exec a:firstline . ',' . a:lastline . 'write >> ' . expand(a:filename)
    exec a:firstline . ',' . a:lastline . 'delete'
endfunction


function! s:CleanWhiteSpace() range
    let search_register = @/
    exec a:firstline . ',' . a:lastline . 'substitute/\s\+$//e'
    let @/ = search_register
endfunction


function! s:ExecuteWithSavedView(command)
    let view = winsaveview()
    exec a:command
    call winrestview(view)
endfunction


function! s:FilterQuickfixList(bang, pattern)
    " Adapted from http://snippetrepo.com/snippets/filter-quickfix-list-in-vim
    let cmp = a:bang ? '!~?' : '=~?'
    call setqflist(filter(
        \ getqflist(),
        \ "v:val['text']" . cmp . " a:pattern"))
endfunction

function! s:FilterLocationList(bang, pattern)
    let cmp = a:bang ? '!~?' : '=~?'
    call setloclist(0, filter(
        \ getloclist(0),
        \ "v:val['text']" . cmp . " a:pattern"))
endfunction


function! GetSyntaxStack(line, col)
    let names = []
    for syntax_id in synstack(a:line, a:col)
        let names += [synIDattr(syntax_id, 'name')]
    endfor
    return names
endfunction


function! g:MoveLine(distance)
    exec 'move ' . Clamp(line('.') + a:distance, 0, line('$'))
endfunction


function! g:ToggleBackground()
    if &background ==# 'light'
        set background=dark
    else
        set background=light
    endif
    echo 'set background=' &background
endfunction

function! g:ToggleHighlighting()
    if empty(&syntax) || &syntax ==# 'OFF'
        exec 'setlocal syntax=' . &filetype
    else
        setlocal syntax=OFF
    endif
endfunction


function! g:Underline(filler_string)
    " abort on <esc>
    if char2nr(a:filler_string) == 27
        return
    endif

    let underlining = FilledString(strdisplaywidth(getline('.')), a:filler_string)
    if !empty(underlining)
        call append('.', underlining)
    endif
endfunction

function! g:Overline(filler_string)
    " abort on <esc>
    if char2nr(a:filler_string) == 27
        return
    endif

    let underlining = FilledString(strdisplaywidth(getline('.')), a:filler_string)
    if !empty(underlining)
        call append(line('.') - 1, underlining)
    endif
endfunction


" XXX Maybe paddle back and actually create commands for the global functions above

command! -range -nargs=1 -complete=file Archive <line1>,<line2>call s:ArchiveRange(<args>)

command! EchoSyntaxStackAtPoint echo GetSyntaxStack(line('.'), col('.'))

command! -bang -nargs=1 Cgrep call s:FilterQuickfixList(<bang>0, <q-args>)
command! -bang -nargs=1 Lgrep call s:FilterLocationList(<bang>0, <q-args>)

command! -range=% CleanWhiteSpace <line1>,<line2>call s:CleanWhiteSpace()

command! -nargs=1 Vexec call s:ExecuteWithSavedView(<args>)
