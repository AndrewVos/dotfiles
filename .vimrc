runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
syntax on
filetype plugin indent on

if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif
colorscheme Tomorrow-Night

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
  set omnifunc=syntaxcomplete#Complete
  set completeopt=longest,menu
  set autowrite
  highlight Search ctermfg=black ctermbg=blue
  set colorcolumn=80
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

" vim-argwrap {{{
  nnoremap gS :ArgWrap<cr>
  au FileType ruby let b:argwrap_tail_comma=1
" }}}

" function! Focus()
"   let g:focusedFile=expand("%")
"   echo "Focusing " . g:focusedFile
" endfunction
" function! Unfocus()
"   if exists('g:focusedFile')
"     echo "Unfocusing ".g:focusedFile
"     unlet g:focusedFile
"   else
"     echo "There wasn't anything focused?"
"   endif
" endfunction
" function! Run()
"   if exists('g:focusedFile')
"     exec ':Rrunner ' . g:focusedFile
"   else
"     exec ':Rrunner spec'
"   endif
" endfunction
" command! Focus call Focus()
" command! Unfocus call Unfocus()
" command! Run call Run()
" nnoremap <leader>r :wa\|:Run<cr>
