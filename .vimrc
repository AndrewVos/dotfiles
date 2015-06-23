runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
syntax on
filetype plugin indent on

set t_Co=256
colorscheme tomorrow-night

" backup to ~/.tmp {{{
  set backup
  set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
  set backupskip=/tmp/*,/private/tmp/* 
  set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
  set writebackup
" }}}

" Syntastic {{{
  let g:syntastic_always_populate_loc_list=1
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
  set omnifunc=syntaxcomplete#Complete
  set completeopt=longest,menu
  set autowrite
  highlight Search ctermfg=black ctermbg=blue
" }}}

" gitgutter {{{
  highlight GitGutterAdd ctermfg=green
  highlight GitGutterChange ctermfg=yellow
  highlight GitGutterDelete ctermfg=red
  highlight GitGutterChangeDelete ctermfg=red
" }}}

" format json {{{
  noremap <leader>j :%!python -m json.tool<cr>
" }}}

" mappings {{{
  function! SetupMapping()
    let g:mapping = input("Command: ", "", "shellcmd")
  endfunction
  function! ExecuteMapping()
    if exists("g:mapping")
      execute "!" . g:mapping
    else
      call SetupMapping()
    endif
  endfunction
  noremap <leader>c :call SetupMapping()<cr>
  noremap <leader>r :call ExecuteMapping()<cr>
" }}}
