if empty($XDG_CONFIG_HOME)
    let g:vimfiles_dir = expand('~/.config/nvim/')
else
    let g:vimfiles_dir = expand($XDG_CONFIG_HOME . '/nvim/')
endif


if has('unix')
    let g:python_host_prog = '/usr/bin/python2'
    let g:python3_host_prog = '/usr/bin/python3'
endif


tnoremap <C-c><C-g> <C-\><C-n>
tnoremap <C-c><C-c> <C-c>


exec 'source ' . g:vimfiles_dir . 'vimrc'
