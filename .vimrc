"Use 256 colour mode
set t_Co=256

"Don't show the vim intro text
set shortmess=I

"Needed for coffeescript plugin to work
call pathogen#runtime_append_all_bundles()

"Turn syntax highlighting on
syntax on

"Turn indentation on
filetype indent on

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
set completeopt=preview

"Set font
set guifont=Monaco:h16

"Set color scheme
colorscheme mustang
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

"Map NERDTree to \n
map <Leader>n :NERDTreeToggle<CR>

"Command-/ to toggle comments
map <D-/> <plug>NERDCommenterToggle<CR>

" Map <Leader>t to write the current file and run rspec
map <Leader>t :w\|!rspec spec<cr>
