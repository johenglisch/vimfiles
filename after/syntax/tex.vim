" conceal '\emph' as if it were '\textit'
if !exists(g:tex_conceal) || g:tex_conceal =~ 'b'
   syn region texItalStyle matchgroup=texTypeStyle start="\\emph\s*{" end="}" concealends contains=@texItalGroup
endif
