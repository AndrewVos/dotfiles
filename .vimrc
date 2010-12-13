"Don't show the vim intro text
set shortmess=I

"Turn syntax highlighting on
syntax on

"Turn word wrap off
set nowrap

"Convert tabs to spaces
set expandtab

"Set tab size
set tabstop=2

"The number of spaces inserted for a tab
set shiftwidth=2

"Full screen takes up entire screen
set fuoptions=maxhorz,maxvert

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

"Hide the toolbar
set guioptions-=T

"Map NERDTree to \n
map <Leader>n :NERDTreeToggle<CR>

"Command-/ to toggle comments
map <D-/> <plug>NERDCommenterToggle<CR>
