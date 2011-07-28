"""""""""""""""""""""""""""""""""""""""
" Use Vundle for plugin management
"""""""""""""""""""""""""""""""""""""""
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

Bundle 'altercation/vim-colors-solarized'
Bundle 'ervandew/supertab'
Bundle 'plasticboy/vim-markdown'
Bundle 'tpope/vim-cucumber'
Bundle 'kchmck/vim-coffee-script'
Bundle 'corntrace/bufexplorer'
Bundle 'scrooloose/nerdcommenter'
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'kogent/vim-puppet'
Bundle 'vim-scripts/htmlspecialchars'
Bundle 'vim-scripts/draw.vim'
Bundle 'vim-scripts/Gist.vim'

if $COLORTERM == "gnome-terminal"
  let g:solarized_termcolors=256
endif

"Make sure VIM can change the cursor in insert mode when using iTerm2
let &t_SI = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

"Github settings
let g:github_user = $GITHUB_USER
let g:github_token = $GITHUB_TOKEN

"set color scheme
set background=dark
:colorscheme solarized

"Automatically size windows to make the active window larger
set winwidth=84
set winheight=5
set winminheight=5
set winheight=999

"Maps space to the leader key
map <Space> <Leader>

"FuzzyFinder
map <Leader>f :FufFile<cr>

"Don't show the vim intro text
set shortmess=I

"Turn syntax highlighting on
syntax on

"Turn on syntax highlighting for Arduino .pde c files
autocmd BufRead *.pde set filetype=c

"Stop vim from searching for insert completion words in all files referenced
set complete-=i

"Turn indentation on
filetype indent on

"Enable filetype plugins
filetype plugin on

"Disable folding because it is evil
set nofoldenable

"Turn word wrap off
set nowrap

"Scroll with more context
set scrolloff=10

"Allow backspace to delete end of line, indent and start of line characters
set backspace=indent,eol,start

"Convert tabs to spaces
set expandtab

"Set tab size
set tabstop=2

"The number of spaces inserted for a tab
set shiftwidth=2

"Turn on line numbers
set number

"Highlight tailing whitespace
set list listchars=tab:\ \ ,trail:·

"Highlight search
set hlsearch
set incsearch
set ignorecase
set smartcase

"Set font
set guifont=Monaco:h16

"Always show the status line
set laststatus=2

"Set the status line to something useful
set statusline=%f\ %=L:%l/%L\ (%p%%)

"Hide the toolbar
set guioptions-=T

"disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

"Copy and paste to the system clipboard with F1 and F2
nmap <F1> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
imap <F1> <Esc>:set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
nmap <F2> :.w !pbcopy<CR><CR>
vmap <F2> :w !pbcopy<CR><CR>
