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

"Github settings
let g:github_user = $GITHUB_USER
let g:github_token = $GITHUB_TOKEN

"Disable ft-plugin-ruby because it causes vim to load up slowly when opening
"ruby files
autocmd filetype ruby let b:did_ftplugin = 1

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

"Minimalistic status line
set statusline=%t

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

if !exists("g:SolarizedSwitcher")
  let g:SolarizedSwitcher = 1
  "Custom functions to switch between solarized light and dark colour schemes
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
  call Dark()
endif
