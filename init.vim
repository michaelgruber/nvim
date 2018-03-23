" dein.vim
if &compatible
  set nocompatible
endif

runtime! plugin/python_setup.vim

set runtimepath+=$HOME/.dein/repos/github.com/Shougo/dein.vim

if dein#load_state(expand('$HOME/.dein'))
  call dein#begin(expand('$HOME/.dein'))

  " Let dein manage dein
  call dein#add(expand('$HOME/.dein/repos/github.com/Shougo/dein.vim'))

  " Plugins
  call dein#add('fatih/vim-go')
  call dein#add('ianks/vim-tsx')
  call dein#add('icymind/NeoSolarized')
  call dein#add('leafgarland/typescript-vim')
  call dein#add('mhartington/nvim-typescript', { 'build': 'yarn global add typescript' })
  call dein#add('pangloss/vim-javascript')
  call dein#add('Shougo/denite.nvim')
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('thinca/vim-qfreplace')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

" General
cd %:p:h         " set working dir to current file/dir
set path=$PWD/** " add subdirectories to path for searching
set backspace=2  " enable backspace
set hidden       " hide buffer instead of closing
set nowrap       " don't wrap lines
set number       " line numbers
set ruler        " cursor location
set spell        " spell checker
set novisualbell " stop beeping
set nohlsearch   " don't highlight all search matches
set incsearch    " highlight current search match

" Persist undo
if has('persistent_undo')
  set undofile
endif

" Recovery and backup off
set nobackup
set noswapfile
set nowb

" Indentation
set tabstop=2
set shiftwidth=2
set expandtab " soft tabs

" Complete
set completeopt-=preview

" NeoSolarized
set termguicolors
set background=light
colorscheme NeoSolarized

" Syntax
autocmd BufNewFile,BufRead Supfile set syntax=yaml

" deoplete.nvim
let g:deoplete#enable_at_startup = 1

call deoplete#custom#source('_', 'matchers', ['matcher_fuzzy',
  \ 'matcher_length'])

" denite.nvim
call denite#custom#var('file_rec', 'command',
  \ ['pt', '--follow', '--nocolor', '--nogroup', '-l', ''])

call denite#custom#var('grep', 'command', ['pt'])
call denite#custom#var('grep', 'default_opts',
  \ ['--nogroup', '--nocolor', '--smart-case'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

function! s:qfreplace_action(context)
  call denite#do_action(a:context, 'quickfix', a:context['targets'])
  call qfreplace#start('')
  :ccl " close the quickfix window since Qfreplace is open
endfunction
call denite#custom#action('file', 'qfreplace', function('s:qfreplace_action'))

call denite#custom#map(
  \ 'insert',
  \ '<Down>',
  \ '<denite:move_to_next_line>',
  \ 'noremap'
  \)
call denite#custom#map(
  \ 'insert',
  \ '<Up>',
  \ '<denite:move_to_previous_line>',
  \ 'noremap'
  \)
call denite#custom#map(
  \ 'normal',
  \ 'r',
  \ '<denite:do_action:qfreplace>',
  \ 'noremap'
  \)

nnoremap <C-p> :<C-u>Denite file_rec<CR>
nnoremap <C-f> :<C-u>Denite grep<CR>

" Tsuquyomi
let g:tsuquyomi_shortest_import_path = 1

" vim-prettier
let g:prettier#quickfix_enabled = 0
let g:prettier#autoformat = 0

" Windows
if has('win32')
  set guifont=Source\ Code\ Pro:h11,Consolas:h11

  " Python virtual envs
  let g:python3_host_prog=expand('$HOME/Envs/python3/Scripts/python.exe')
  let g:python_host_prog=expand('$HOME/Envs/python/Scripts/python.exe')

" Unix
elseif has('unix')
  let s:uname = system("echo -n \"$(uname)\"") " get OS type

" OS X
  if !v:shell_error && s:uname == "Darwin"
    set guifont=Source\ Code\ Pro:h12,\ Menlo:h13

" Linux
  else

  endif
endif
