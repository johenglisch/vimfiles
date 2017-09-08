" Remove a range of lines and move them into an archive file.

function! s:ArchiveRange(filename) range abort
    exec a:firstline . ',' . a:lastline . 'write >> ' . expand(a:filename)
    exec a:firstline . ',' . a:lastline . 'delete'
endfunction

command! -range -nargs=1 -complete=file Archive <line1>,<line2>call s:ArchiveRange(<args>)


" Remove trailing white space in a range.

function! s:CleanWhiteSpace() range
    let search_register = @/
    exec a:firstline . ',' . a:lastline . 'substitute/\s\+$//e'
    let @/ = search_register
endfunction

command! -range=% CleanWhiteSpace <line1>,<line2>call s:CleanWhiteSpace()


" Execute a command and then restore viewport to previous state.

function! s:ExecuteWithSavedView(command)
    let view = winsaveview()
    exec a:command
    call winrestview(view)
endfunction

command! -nargs=1 Vexec call s:ExecuteWithSavedView(<args>)


" Remove all elements in the quickfix list/location list that don't match the
" pattern.  If bang is not zero remove all elements *but* matching ones from the
" list.

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

command! -bang -nargs=1 Cgrep call s:FilterQuickfixList(<bang>0, <q-args>)
command! -bang -nargs=1 Lgrep call s:FilterLocationList(<bang>0, <q-args>)


" Look backwards from the cursor for a spelling error and either guess
" a correction or add the error to the dictionary.

function! s:FixSpelling()
    normal! mm[s1z=`m
endfunction

function! s:ErrorToDict()
    normal! mm[s1zg`m
endfunction

command! FixSpelling call s:FixSpelling()
command! ErrorToDict call s:ErrorToDict()


" Get the names of all elements in the syntax stack below the curser.

function! GetSyntaxStack(line, col)
    let names = []
    for syntax_id in synstack(a:line, a:col)
        let names += [synIDattr(syntax_id, 'name')]
    endfor
    return names
endfunction

command! EchoSyntaxStackAtPoint echo GetSyntaxStack(line('.'), col('.'))


" Move a line down by `distance` lines (negative distances move the line up).

function! s:MoveLine(distance)
    exec 'move ' . Clamp(line('.') + a:distance, 0, line('$'))
endfunction

command! -nargs=1 MoveLineUp call s:MoveLine(-(<args> + 1))
command! -nargs=1 MoveLineDown call s:MoveLine(<args>)


" Toggle between values of some options that are not just binary choices
" (i.e. where `set invoption` is not possible).

function! s:ToggleBackground()
    if &background ==# 'light'
        set background=dark
    else
        set background=light
    endif
    echo 'set background=' &background
endfunction

function! s:ToggleSyntax()
    if empty(&syntax) || &syntax ==# 'OFF'
        exec 'setlocal syntax=' . &filetype
    else
        setlocal syntax=OFF
    endif
    echo 'set syntax=' &syntax
endfunction

command! ToggleBackground call s:ToggleBackground()
command! ToggleSyntax call s:ToggleSyntax()


" Create a line below or above the current line which is filled with
" `filler_string`.

function! s:Underline(filler_string)
    " abort on <esc>
    if char2nr(a:filler_string) == 27
        return
    endif

    let underlining = FilledString(strdisplaywidth(getline('.')), a:filler_string)
    if !empty(underlining)
        call append('.', underlining)
    endif
endfunction

function! s:Overline(filler_string)
    " abort on <esc>
    if char2nr(a:filler_string) == 27
        return
    endif

    let underlining = FilledString(strdisplaywidth(getline('.')), a:filler_string)
    if !empty(underlining)
        call append(line('.') - 1, underlining)
    endif
endfunction

command! -nargs=1 Underline call s:Underline(<args>)
command! -nargs=1 Overline call s:Overline(<args>)