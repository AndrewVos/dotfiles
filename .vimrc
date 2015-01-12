set shell=/bin/zsh

runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
syntax on
filetype plugin indent on

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

" Jump to last cursor position {{{
  augroup go_to_last_cursor_position
    autocmd!
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
  augroup END
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
  highlight SignColumn ctermbg=black

  highlight GitGutterAdd ctermbg=black ctermfg=green
  highlight GitGutterChange ctermbg=black ctermfg=yellow
  highlight GitGutterDelete ctermbg=black ctermfg=red
  " highlight GitGutterChangeDelete " a changed line followed by at least one removed line
" }}}

" rainbow parentheses {{{
  au VimEnter * RainbowParenthesesToggle
  au Syntax * RainbowParenthesesLoadRound
  au Syntax * RainbowParenthesesLoadSquare
  au Syntax * RainbowParenthesesLoadBraces
" }}}

" format json {{{
  noremap <leader>j :%!python -m json.tool<cr>
" }}}

" mappings {{{
  function! SetupMapping()
    let g:mapping = input('Command: ')
  endfunction
  function! ExecuteMapping()
    if exists("g:mapping")
      execute "!" . g:mapping
    endif
  endfunction
  noremap <leader>c :call SetupMapping()<cr>
  noremap <leader>r :call ExecuteMapping()<cr>
" }}}

if !empty(glob(".git"))
  function! GitLsFiles(A,L,P)
    let pattern = a:A
    if len(pattern) > 0
      return split(system("git ls-files --cached --modified --others \| grep " . pattern), "\n")
    else
      return split(system("git ls-files --cached --modified --others"), "\n")
    endif
  endfunction
  command! -complete=customlist,GitLsFiles -nargs=1 Z :edit <args>
endif

if !empty(glob(".git"))
  function! GitLsFilesModified(A,L,P)
    let pattern = a:A
    let gitCommand = "git status --untracked --porcelain | awk '{print ( $(NF) )}'"
    if len(pattern) > 0
      return split(system(gitCommand . " \| grep " . pattern), "\n")
    else
      return split(system(gitCommand), "\n")
    endif
  endfunction
  command! -complete=customlist,GitLsFilesModified -nargs=1 G :edit <args>
endif
