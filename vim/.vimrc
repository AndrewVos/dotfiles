runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
syntax on
filetype plugin indent on

" Press C-A to go to beginning of line in command mode
cnoremap <C-A> <Home>

" colour scheme
colorscheme dim

" tags file location
set tags^=./.git/tags;

" vim-autoformat
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

function! Format()
  normal! ix
  normal! "_x
  undojoin
  :Autoformat
endfunction
au BufWrite * call Format()

" backup to ~/.tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" vim-gnupg
" Use gpg2, because it stores symmetric passphrases in gpg-agent.
let g:GPGExecutable="gpg2"

" golang
let g:go_fmt_command = "goimports"

" vim
set shortmess=ITt
set hlsearch
set smartcase
set ignorecase
set hidden
set autowrite
highlight clear Search
highlight Search cterm=NONE ctermfg=red ctermbg=None

set nofoldenable
set number

" templates
augroup templates
  function! ReadTemplate(path)
    execute 'silent 0r ' . a:path
    execute 'normal! G'
  endfunction
  autocmd BufNewFile *.sh call ReadTemplate('~/.vim-templates/template.sh')
augroup END

" fzy
function! FzyCommand(choice_command, vim_command)
  try
    let output = system(a:choice_command . " | fzy ")
  catch /Vim:Interrupt/
    " Swallow errors from ^C, allow redraw! below
  endtry
  redraw!
  if v:shell_error == 0 && !empty(output)
    exec a:vim_command . ' ' . output
  endif
endfunction
nnoremap <C-p> :call FzyCommand("git ls-files --cached --modified \| sort \| uniq", ":e")<cr>

" gitgutter
" Async support breaks vim rendering when you use :make with
" unsaved changes, and autowrite enabled.
let g:gitgutter_async=0
set updatetime=100
let g:gitgutter_sign_removed = '×'
set signcolumn=yes

highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=yellow
highlight GitGutterDelete ctermfg=red
highlight GitGutterChangeDelete ctermfg=red

command! -nargs=0 Revert :GitGutterUndoHunk

" :Usages <tag> to jump to tag usages
command! -nargs=1 -complete=tag Usages :Ggrep <f-args>

" format json
noremap <leader>j :%!python -m json.tool<cr>

" vim-argwrap
nnoremap gS :ArgWrap<cr>
au FileType ruby let b:argwrap_tail_comma=1

" set *.es6 to filetype javascript
au BufRead,BufNewFile *.es6 set filetype=javascript

" html
" Before:
" <p>
" Text
" </p>
" After:
" <p>
"   Text
" </p>
let g:html_indent_inctags = "p"

" vim-js-file-import
set wildignore+=*/node_modules/*
let g:js_file_import_omit_semicolon = 1
let g:js_file_import_no_mappings = 1
let g:js_file_import_sort_after_insert = 1
let g:js_file_import_force_require = 1

" rspec
function! RunAllTests()
  compiler rspec
  setlocal makeprg=bundle\ exec\ rspec\ --fail-fast
  make!
endfunction
function! RunTests()
  if expand('%') =~ "_spec.rb"
    let g:testFile = expand('%')
  endif
  if exists('g:testFile')
    compiler rspec
    setlocal makeprg=bundle\ exec\ rspec\ --fail-fast
    execute "make! " . g:testFile
  endif
endfunction
function! RunSingleTest()
  if exists('g:singleTestFile')
    compiler rspec
    setlocal makeprg=bundle\ exec\ rspec\ --fail-fast
    execute "make! " . g:singleTestFile
  endif
endfunction
function! FocusTest()
  if expand('%') =~ "_spec.rb"
    let g:singleTestFile = expand('%') . ':' . line('.')
  endif
endfunction
noremap tf :call RunTests()<cr>
noremap tt :call RunAllTests()<cr>
command! -nargs=0 FocusTest call FocusTest()
noremap tF :call RunSingleTest()<cr>

" sideways.vim
nnoremap <C-Left> :SidewaysLeft<cr>
nnoremap <C-Right> :SidewaysRight<cr>

" startify
let g:startify_custom_header = []
let g:startify_change_to_dir = 0
let g:startify_lists = [
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

function! RunRubocop()
  let errorformat = '%f:%l: %t: %m'
  set makeprg=rubocop
  make
endfunction
command! -nargs=0 Rubocop call RunRubocop()
