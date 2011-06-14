"""""""""""""""""""""""""""""""""""""""
" Use Vundle for plugin management
"""""""""""""""""""""""""""""""""""""""
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

Bundle 'altercation/vim-colors-solarized'
Bundle 'vim-scripts/EasyMotion'
Bundle 'ervandew/supertab'
Bundle 'plasticboy/vim-markdown'
Bundle 'tpope/vim-cucumber'
Bundle 'kchmck/vim-coffee-script'
Bundle 'vim-scripts/CycleColor'
Bundle 'corntrace/bufexplorer'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'kogent/vim-puppet'
Bundle 'vim-scripts/htmlspecialchars'

"Maps space to the leader key
map <Space> <Leader>

"Don't show the vim intro text
set shortmess=I

"Turn syntax highlighting on
syntax on

"Turn on syntax highlighting for Arduino .pde c files
autocmd BufRead *.pde set filetype=c

"Turn indentation on
filetype indent on

"Enable filetype plugins
filetype plugin on

"Disable folding because it is evil
set nofoldenable

"Turn word wrap off
set nowrap

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

"Hide the completion menu
"set completeopt=preview

"Set font
set guifont=Monaco:h16

"Set color scheme
"colorscheme mustang
"colorscheme candycode
"colorscheme neon
"colorscheme pyte
"colorscheme jellybeans+
"colorscheme railscasts
"colorscheme wombat256

"Minimalistic status line
set statusline=%t

"Hide the toolbar
set guioptions-=T

"Map NERDTree to <Leader>n
map <Leader>n :NERDTreeToggle<CR>

" disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Custom functions to switch between solarized light and dark colour schemes
function! Light()
  call SetTerminalColourScheme("Solarized Light ansi")
  set background=light
  :colorscheme solarized
endfunction

function! Dark()
  call SetTerminalColourScheme("Solarized Dark ansi")
  set background=dark
  :colorscheme solarized
endfunction

function! SetTerminalColourScheme(colourScheme)
  let osaScriptCommand = 'osascript -e "tell application \"Terminal.app\" to set current settings of front window to settings set \"{COLOURS}\""'
  let scriptCommand = substitute(osaScriptCommand, "{COLOURS}", a:colourScheme, "")
  call system(scriptCommand)
endfunction

:command Light call Light()
:command Dark call Dark()
call Light()
