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

" Syntastic {{{
  let g:syntastic_always_populate_loc_list=1
  let g:syntastic_ruby_checkers = ['mri', 'rubocop']
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

" vim-argwrap {{{
  nnoremap gS :ArgWrap<cr>
  au FileType ruby let b:argwrap_tail_comma=1
" }}}

" set *.es6 to filetype javascript {{{
  au BufRead,BufNewFile *.es6 set filetype=javascript
" }}}

function! BackgroundCommandClose(channel)
  execute "cfile! " . g:backgroundCommandOutput
  copen
  unlet g:backgroundCommandOutput

  let job = ch_getjob(a:channel)
  let info = job_info(job)
  if info['exitval'] > 0
    echohl Error
    echo 'FAIL'
  else
    echo 'PASS'
  endif
  echohl None
endfunction

function! RunBackgroundCommand(command)
  if v:version < 800
    echoerr 'RunBackgroundCommand requires VIM version 8 or higher'
    return
  endif

  if exists('g:backgroundCommandOutput')
    echo 'Already running task in background'
  else
    echo 'Running task in background'
    let g:backgroundCommandOutput = tempname()
    call job_start(a:command, {'close_cb': 'BackgroundCommandClose', 'out_io': 'file', 'out_name': g:backgroundCommandOutput})
  endif
endfunction
command! -nargs=+ -complete=shellcmd RunBackgroundCommand call RunBackgroundCommand(<q-args>)
