" Remove a range of lines and move them into an archive file.

function! s:ArchiveRange(filename) range abort
    exec a:firstline . ',' . a:lastline . 'write >> ' . expand(a:filename)
    exec a:firstline . ',' . a:lastline . 'delete'
endfunction

command! -range -nargs=1 -complete=file Archive <line1>,<line2>call s:ArchiveRange(<args>)


" Search for `pattern` in all files in the current directory.

function! s:Ag(pattern) abort
    if executable('ag')
        let l:output = split(system("ag --ignore tags --vimgrep '" . a:pattern . "'"), '\n')
        if len(l:output) > 0
            call setqflist([], 'r', {'lines': l:output})
            copen
        endif
    else
        exec 'vimgrep /' . a:pattern . '/j **/*'
        copen
    endif
endfunction

command! -nargs=1 Ag call s:Ag(<args>)


" Change directory to root of current git repo

function! s:CdToGitRoot() abort
    if !exists('b:git_dir')
        echo 'No git repo found'
        return
    endif

    let git_root = fnamemodify(b:git_dir, ':h')
    let cmd = 'cd ' . git_root
    exec cmd
    echo cmd
endfunction

command! CdToGitRoot call s:CdToGitRoot()


" Remove trailing white space in a range.

function! s:CleanWhiteSpace() range abort
    let l:search_register = @/
    exec a:firstline . ',' . a:lastline . 'substitute/\s\+$//e'
    let @/ = l:search_register
endfunction

command! -range=% CleanWhiteSpace <line1>,<line2>call s:CleanWhiteSpace()


" Execute a command and then restore viewport to previous state.

function! s:ExecuteWithSavedView(command) abort
    let l:view = winsaveview()
    exec a:command
    call winrestview(l:view)
endfunction

command! -nargs=1 Vexec call s:ExecuteWithSavedView(<args>)


" Remove all elements in the quickfix list/location list that don't match the
" pattern.  If bang is not zero remove all elements *but* matching ones from the
" list.

function! s:FilterQuickfixList(bang, pattern) abort
    " Adapted from http://snippetrepo.com/snippets/filter-quickfix-list-in-vim
    let l:cmp = a:bang ? '!~?' : '=~?'
    call setqflist(filter(
        \ getqflist(),
        \ "v:val['text']" . l:cmp . ' a:pattern'))
endfunction

function! s:FilterLocationList(bang, pattern) abort
    let l:cmp = a:bang ? '!~?' : '=~?'
    call setloclist(0, filter(
        \ getloclist(0),
        \ "v:val['text']" . l:cmp . ' a:pattern'))
endfunction

command! -bang -nargs=1 Cgrep call s:FilterQuickfixList(<bang>0, <q-args>)
command! -bang -nargs=1 Lgrep call s:FilterLocationList(<bang>0, <q-args>)


" Look backwards from the cursor for a spelling error and either guess
" a correction or add the error to the dictionary.

function! s:FixSpelling() abort
    normal! mm[s1z=`m
endfunction

function! s:ErrorToDict() abort
    normal! mm[s1zg`m
endfunction

command! FixSpelling call s:FixSpelling()
command! ErrorToDict call s:ErrorToDict()


" Get the names of all elements in the syntax stack below the curser.

function! GetSyntaxStack(line, col) abort
    let l:names = []
    for l:syntax_id in synstack(a:line, a:col)
        let l:names += [synIDattr(l:syntax_id, 'name')]
    endfor
    return l:names
endfunction

command! EchoSyntaxStackAtPoint echo GetSyntaxStack(line('.'), col('.'))


" Move a line down by `distance` lines (negative distances move the line up).

function! s:MoveLine(distance) abort
    exec 'move ' . Clamp(line('.') + a:distance, 0, line('$'))
endfunction

command! -nargs=1 MoveLineUp call s:MoveLine(-(<args> + 1))
command! -nargs=1 MoveLineDown call s:MoveLine(<args>)


" Toggle between values of some options that are not just binary choices
" (i.e. where `set invoption` is not possible).

function! s:ToggleBackground() abort
    if &background ==# 'light'
        set background=dark
    else
        set background=light
    endif
    echo 'set background=' &background
endfunction

function! s:ToggleSyntax() abort
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

function! s:Underline(filler_string) abort
    " abort on <esc>
    if char2nr(a:filler_string) == 27
        return
    endif

    let l:underlining = FilledString(strdisplaywidth(getline('.')), a:filler_string)
    if !empty(l:underlining)
        call append('.', l:underlining)
    endif
endfunction

function! s:Overline(filler_string) abort
    " abort on <esc>
    if char2nr(a:filler_string) == 27
        return
    endif

    let l:underlining = FilledString(strdisplaywidth(getline('.')), a:filler_string)
    if !empty(l:underlining)
        call append(line('.') - 1, l:underlining)
    endif
endfunction

command! -nargs=1 Underline call s:Underline(<args>)
command! -nargs=1 Overline call s:Overline(<args>)
