" " Don't autoselect first omnicomplete option, show options even if there is only
" " one (so the preview documentation is accessible). Remove 'preview', 'popup'
" " and 'popuphidden' if you don't want to see any documentation whatsoever.
" " Note that neovim does not support `popuphidden` or `popup` yet:
" " https://github.com/neovim/neovim/issues/10996
" if has('patch-8.1.1880')
"   set completeopt=longest,menuone,popuphidden
"   " Highlight the completion documentation popup background/foreground the same as
"   " the completion menu itself, for better readability with highlighted
"   " documentation.
"   set completepopup=highlight:Pmenu,border:off
" else
"   set completeopt=longest,menuone,preview
"   " Set desired preview window height for viewing documentation.
"   set previewheight=5
" endif

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
let g:ale_linters = { 'cs': ['OmniSharp'] }

if exists('OmniSharpTypeLookup')
    " The following commands are contextual, based on the cursor position.
    nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
    nmap <silent> <buffer> Öosfu <Plug>(omnisharp_find_usages)
    nmap <silent> <buffer> Öosfi <Plug>(omnisharp_find_implementations)
    nmap <silent> <buffer> Öospd <Plug>(omnisharp_preview_definition)
    nmap <silent> <buffer> Öospi <Plug>(omnisharp_preview_implementations)
    nmap <silent> <buffer> Öost <Plug>(omnisharp_type_lookup)
    nmap <silent> <buffer> Öosd <Plug>(omnisharp_documentation)
    nmap <silent> <buffer> Öosfs <Plug>(omnisharp_find_symbol)
    nmap <silent> <buffer> Öosfx <Plug>(omnisharp_fix_usings)
    nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
    imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

    " Navigate up and down by method/property/field
    nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
    nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
    " Find all code errors/warnings for the current solution and populate the quickfix window
    nmap <silent> <buffer> Öosgcc <Plug>(omnisharp_global_code_check)
    " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
    nmap <silent> <buffer> Öosca <Plug>(omnisharp_code_actions)
    xmap <silent> <buffer> Öosca <Plug>(omnisharp_code_actions)
    " Repeat the last code action performed (does not use a selector)
    nmap <silent> <buffer> Öos. <Plug>(omnisharp_code_action_repeat)
    xmap <silent> <buffer> Öos. <Plug>(omnisharp_code_action_repeat)

    nmap <silent> <buffer> Öos= <Plug>(omnisharp_code_format)

    nmap <silent> <buffer> Öosnm <Plug>(omnisharp_rename)

    nmap <silent> <buffer> Öosre <Plug>(omnisharp_restart_server)
    nmap <silent> <buffer> Öosst <Plug>(omnisharp_start_server)
    nmap <silent> <buffer> Öossp <Plug>(omnisharp_stop_server)
endif
