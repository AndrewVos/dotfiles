runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
syntax on
filetype plugin indent on

colorscheme Tomorrow-Night

" backup to ~/.tmp {{{
  set backup
  set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
  set backupskip=/tmp/*,/private/tmp/* 
  set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
  set writebackup
" }}}

" vim-gnupg {{{
  " Use gpg2, because it stores symmetric passphrases in gpg-agent.
  let g:GPGExecutable="gpg2"
" }}}

" golang {{{
  " Does that auto import stuff
  let g:go_fmt_command = "goimports"
" }}}

" vim {{{
  set shortmess=ITt
  set hlsearch
  set smartcase
  set hidden
  set autowrite
  highlight Search ctermfg=black ctermbg=blue
" }}}

" gitgutter {{{
  let g:gitgutter_sign_removed = '×'
  let g:gitgutter_sign_column_always = 1
  highlight GitGutterAdd ctermfg=green
  highlight GitGutterChange ctermfg=yellow
  highlight GitGutterDelete ctermfg=red
  highlight GitGutterChangeDelete ctermfg=red
" }}}

" format json {{{
  noremap <leader>j :%!python -m json.tool<cr>
" }}}

" vim-argwrap {{{
  nnoremap gS :ArgWrap<cr>
  au FileType ruby let b:argwrap_tail_comma=1
" }}}

" set *.es6 to filetype javascript {{{
  au BufRead,BufNewFile *.es6 set filetype=javascript
" }}}

function! RunAllTests()
  compiler rspec
  make
endfunction
function! RunTests()
  if expand('%') =~ "_spec.rb"
    let g:testFile = expand('%')
  endif
  if exists('g:testFile')
    compiler rspec
    execute "make " . g:testFile
  endif
endfunction
noremap tf :call RunTests()<cr>
noremap tt :call RunAllTests()<cr>
