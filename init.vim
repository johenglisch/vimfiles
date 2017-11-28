if empty($XDG_CONFIG_HOME)
    let g:vimfiles_dir = expand('~/.config/nvim/')
else
    let g:vimfiles_dir = expand($XDG_CONFIG_HOME . '/nvim/')
endif


exec 'source ' . g:vimfiles_dir . 'vimrc'
