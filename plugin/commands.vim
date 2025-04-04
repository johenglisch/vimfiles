" Remove a range of lines and move them into an archive file.

function! s:ArchiveRange(filename) range abort
    exec a:firstline . ',' . a:lastline . 'write >> ' . expand(a:filename)
    exec a:firstline . ',' . a:lastline . 'delete'
endfunction

command! -range -nargs=1 -complete=file Archive <line1>,<line2>call s:ArchiveRange(<args>)


" Search for `pattern` in all files in the current directory.

function! s:Ag(pattern) abort
    if executable('rg')
        let l:command = "rg --vimgrep -S -e '" . a:pattern . "'"
        let l:output = split(system(l:command), '\n')
        if len(l:output) > 0
            call setqflist([], 'r', {'lines': l:output})
            copen
        endif
    elseif executable('ag')
        let l:command = "ag --ignore tags --vimgrep '" . a:pattern . "'"
        let l:output = split(system(l:command), '\n')
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


" Run a shell command and fill the quickfix/location list with its output.

function! s:FillQuickfixListWithCommand(showlist, command) abort
    cexpr system(a:command)
    if a:showlist && !empty(getqflist())
        copen
    endif
endfunction

function! s:FillLocationListWithCommand(showlist, command) abort
    lexpr system(a:command)
    if a:showlist && !empty(getloclist())
        lopen
    endif
endfunction

command! -bang -nargs=+ ClRun call s:FillQuickfixListWithCommand(<bang>1, <q-args>)
command! -bang -nargs=+ LlRun call s:FillLocationListWithCommand(<bang>1, <q-args>)


" Make the current line blink for a bit.

function! s:FindCursor() abort
    set invcursorline
    redraw
    sleep 100m
    set invcursorline
    redraw
    sleep 100m
    set invcursorline
    redraw
    sleep 100m
    set invcursorline
    redraw
    sleep 100m
    set invcursorline
    redraw
    sleep 100m
    set invcursorline
    redraw
endfunction

command! FindCursor call s:FindCursor()


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


" Generate (permanent) github link for the current file and copy it to the
" clipboard.
"  * Calling GithubLink on a range will highlight the lines.
"  * Calling GithubLink! with a bang will open the link with `xdg-open` instead.

function! s:ExtractGitRemote(text_lines) abort
    let l:is_in_origin_block = 0
    for l:line in a:text_lines
        if !l:is_in_origin_block && l:line ==# '[remote "origin"]'
            let l:is_in_origin_block = 1
        elseif l:is_in_origin_block
            if l:line[0] == '['
                break
            elseif l:line =~# '^\s*url\s*='
                return substitute(l:line, '^\s*url\s*=\s*', '', '')
            endif
        endif
    endfor
    throw 'No url found for remote origin'
endfunction

function! s:GithubLink(bang, file_name) range abort
    try
        let l:project_folder = FindGitRoot(a:file_name)
    catch
        echo v:exception
        return
    endtry

    let l:git_folder = l:project_folder . '/.git'
    try
        " TODO: don't hard-code remote 'origin'
        " (also: show little menu if there is more than one remote)
        let l:remote_url = s:ExtractGitRemote(readfile(l:git_folder.'/config'))
    catch
        echo v:exception
        return
    endtry

    let l:remote_url = substitute(
                \ l:remote_url, '\v^git\@([^:]*):', 'https://\1/', '')
    let l:commit_hash = system('git log -n1 --format=format:%H')
    let l:relative_path = substitute(
                \ a:file_name,
                \ '\V\^'.escape(l:project_folder, '\').'/\?',
                \ '', '')
    if a:firstline == 1 && a:lastline == line('$')
        let l:line_range = ''
    elseif a:firstline == a:lastline
        let l:line_range = '#L' . a:firstline
    else
        let l:line_range = '#L' . a:firstline . '-L' . a:lastline
    endif

    if l:remote_url =~? '\v^(https?://)codeberg\.org/'
        let l:permanent_url =
                    \ l:remote_url
                    \ . '/src/commit/' . l:commit_hash
                    \ . '/' . l:relative_path
                    \ . l:line_range
    elseif l:remote_url =~? '\v^(https?://)github\.com/'
        let l:permanent_url =
                    \ l:remote_url
                    \ . '/blob/' . l:commit_hash
                    \ . '/' . l:relative_path
                    \ . l:line_range
    else
        " TODO: gitlab?
        echomsg 'unknown hosting service: ' . l:remote_url
        return
    endif

    if a:bang
        exec "!xdg-open " . shellescape(escape(l:permanent_url, '\%#'))
    else
        let @+ = l:permanent_url
    endif
endfunction

command! -bang -range=% GithubLink <line1>,<line2>call s:GithubLink(<bang>0, expand('%:p'))


" Move a line down by `distance` lines (negative distances move the line up).

function! s:MoveLine(distance) abort
    exec 'move ' . Clamp(line('.') + a:distance, 0, line('$'))
endfunction

command! -nargs=1 MoveLineUp call s:MoveLine(-(<args> + 1))
command! -nargs=1 MoveLineDown call s:MoveLine(<args>)


" Echo statusline-like message

function! s:Status() abort
    let l:current_file = expand('%:p')
    let l:filename = empty(l:current_file) ? '(no file)' : l:current_file
    let l:readonly = &readonly ? ',RO' : ''
    let l:filetype = empty(&filetype) ? '' : ' ['.&filetype.']'

    let l:status =
                \ Modified() . l:filename . l:readonly
                \ . l:filetype
                \ . ' ' . GitBranch()
    echo l:status
endfunction

command! Status call s:Status()


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
