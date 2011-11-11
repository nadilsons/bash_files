":colorscheme slate 
:colorscheme desert 
" Settings for terminal version of vim
:highlight Search ctermbg=yellow ctermfg=black
" Settings for gvim (linux) / macvim
:highlight Search guibg=yellow guifg=black

set incsearch
set cursorline
set number
set autoindent 

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,htmldjango,jinjahtml,eruby,mako source ~/.vim/bundle/closetag/plugin/closetag.vim

imap <Tab> <C-X><C-F>

map <D-t> :CommandT<CR>
map <F2> :NERDTreeToggle<CR>
