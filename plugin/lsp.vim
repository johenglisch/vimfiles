" LSP settings

let g:lsp_diagnostics_enabled = 1
" Move all that nonsense out of my editing window into the echo line.
let g:lsp_diagnostics_signs_enabled = 0
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1


" Set up individual servers

if executable('clangd')
    augroup RegisterCLSP
        autocmd!
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd', '-background-index']},
                    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                    \ })
    augroup END
elseif executable('ccls')
    augroup RegisterCLSP
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'ccls',
                    \ 'cmd': {server_info->['ccls']},
                    \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
                    \ 'initialization_options': {'cache': {'directory': expand('~/.cache/ccls') }},
                    \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
                    \ })
    augroup END
endif

if executable('gopls')
    augroup RegisterGoLSP
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'gopls',
                    \ 'cmd': {server_info->['gopls', '-remote=auto']},
                    \ 'allowlist': ['go', 'gomod', 'gohtmltmpl', 'gotexttmpl'],
                    \ })
    augroup END
endif

if executable('haskell-language-server-wrapper')
    augroup Haskell
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'haskell-language-server-wrapper',
                    \ 'cmd': {server_info->['haskell-language-server-wrapper', '--lsp']},
                    \ 'root_uri':{server_info->lsp#utils#path_to_uri(
                    \     lsp#utils#find_nearest_parent_file_directory(
                    \         lsp#utils#get_buffer_path(),
                    \         ['.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml', '.git'],
                    \     ))},
                    \ 'whitelist': ['haskell', 'lhaskell'],
                    \ })
    augroup END
endif

if executable('ols')
    " https://github.com/DanielGavin/ols
    augroup RegisterPythonLSP
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'ols',
                    \ 'cmd': {server_info->['ols']},
                    \ 'allowlist': ['odin'],
                    \ })
    augroup END
endif

if executable('pylsp')
    " $ pip install python-lsp-server
    augroup RegisterPythonLSP
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'pylsp',
                    \ 'cmd': {server_info->['pylsp']},
                    \ 'allowlist': ['python'],
                    \ })
    augroup END
endif

if executable('rust-analyzer')
    " https://github.com/rust-lang/rust-analyzer
    " $ rustup component add rust-analyzer
    augroup RegisterRustLSP
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'rust-analyzer',
                    \ 'cmd': {server_info->['rust-analyzer']},
                    \ 'allowlist': ['rust'],
                    \ })
    augroup END
endif

if executable('texlab')
    " https://github.com/latex-lsp/texlab
    " $ cargo install texlab
    augroup RegisterTeXLab
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'texlab',
                    \ 'cmd': {server_info->['texlab']},
                    \ 'allowlist': ['tex'],
                    \ })
    augroup END
endif


" Enable key bindings

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(definition)
    nmap <buffer> gs <plug>(document-symbol-search)
    nmap <buffer> gS <plug>(workspace-symbol-search)
    nmap <buffer> gr <plug>(references)
    nmap <buffer> gi <plug>(implementation)
    nmap <buffer> gt <plug>(type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-name)
    nmap <buffer> ÖO :<c-u>LspCodeAction<cr>
    nmap <buffer> ÖP <plug>(lsp-previous-diagnostic)
    nmap <buffer> ÖN <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
    nnoremap <buffer> <backspace> :<c-u>LspDocumentDiagnostics<cr>
endfunction

augroup lsp_install
    autocmd!
    " call s:on_lsp_buffer_enabled only for languages that have the server
    " registered
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
