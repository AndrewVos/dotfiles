"""""""""""""""""""""""""""""""""""""""
" Use Vundle for plugin management
"""""""""""""""""""""""""""""""""""""""
set nocompatible
filetype on
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

Bundle 'altercation/vim-colors-solarized'
Bundle 'tomasr/molokai'

Bundle 'ervandew/supertab'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-cucumber'
Bundle 'kchmck/vim-coffee-script'
Bundle 'vim-scripts/draw.vim'
Bundle 'mattn/webapi-vim'
Bundle 'vim-scripts/Gist.vim'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-endwise'
Bundle 'mileszs/ack.vim'
Bundle 'benmills/vimux'
Bundle 'kien/ctrlp.vim'
Bundle 'Lokaltog/vim-powerline'

" TAGS -------------------------
Bundle 'majutsushi/tagbar'
Bundle 'xolox/vim-easytags'

"Open Tagbar when pressing <leader>b and automatically close it after
"selecting something
:map <leader>b :TagbarOpenAutoClose<cr>
" TAGS -------------------------

if $COLORTERM == "gnome-terminal"
  let g:solarized_termcolors=256
endif

"Make sure VIM can change the cursor in insert mode when using iTerm2
let &t_SI = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

"Launch ctrl+p with \t
map <leader>t <C-p>

let g:ctrlp_max_height = 30

" Jump to last cursor position unless it's invalid or in an event handler
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

"Github settings
let g:github_user = $GITHUB_USER
let g:github_token = $GITHUB_TOKEN

"set color scheme
set background=dark
:silent! :colorscheme solarized

"Don't show the vim intro text
set shortmess=I

"Turn syntax highlighting on
syntax on

"Turn on syntax highlighting for Arduino .pde c files
autocmd BufRead *.pde set filetype=c

"Stop vim from searching for insert completion words in all files referenced
set complete-=i

"Make sure undo history is kept for files in buffer.
set hidden

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

"Always show the status line
set laststatus=2

"Set the status line to something useful
set statusline=%f\ %=L:%l/%L\ %c\ (%p%%)

"Hide the toolbar
set guioptions-=T

" backup to ~/.tmp
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/* 
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

"Copy and paste to the system clipboard with F1 and F2
nmap <F1> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
imap <F1> <Esc>:set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
nmap <F2> :.w !pbcopy<CR><CR>
vmap <F2> :w !pbcopy<CR><CR>

"If there's a .vimlocal file automatically source it
function! SourceVimLocal()
  if filereadable(".vimlocal")
    source .vimlocal
  endif
endfunction
call SourceVimLocal()

"Allow piping of markdown files to the browser
au BufEnter,BufNew *.md map <enter> :wa\|!rbfu rdiscount % \| bcat<cr>

" Clear the search buffer
:nnoremap § :nohlsearch<cr>

" Show fancy powerline symbols
let g:Powerline_symbols = 'fancy'

"Get rid of the delay when pressing O (for example)
"http://stackoverflow.com/questions/2158516/vim-delay-before-o-opens-a-new-line
:set timeout timeoutlen=1000 ttimeoutlen=100

"Stop CTRL+P from changing directory paths automatically
let g:ctrlp_working_path_mode = 0
