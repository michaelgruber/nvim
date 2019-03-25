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
  call dein#add('carlitux/deoplete-ternjs', { 'rev': 'proc-init', 'build': 'yarn global add tern' })
  call dein#add('fatih/vim-go')
  call dein#add('ianks/vim-tsx')
  call dein#add('icymind/NeoSolarized')
  call dein#add('jparise/vim-graphql')
  call dein#add('jsfaint/gen_tags.vim')
  call dein#add('leafgarland/typescript-vim')
  call dein#add('mhartington/nvim-typescript', { 'build': './install.sh' })
  call dein#add('neoclide/denite-git')
  call dein#add('neoclide/vim-easygit')
  call dein#add('nsf/gocode', {'rtp': 'nvim', 'build': 'go get -u github.com/nsf/gocode'})
  call dein#add('pangloss/vim-javascript')
  call dein#add('Shougo/denite.nvim')
  call dein#add('Shougo/deoplete-clangx')
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('Shougo/neoinclude.vim')
  call dein#add('thinca/vim-qfreplace')
  call dein#add('zchee/deoplete-go')

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
autocmd BufNewFile,BufRead *.BUILD set syntax=bzl

" E=Explore. Always.
command! -nargs=* -bar -bang -count=0 -complete=dir	E call netrw#Explore(<count>,0,0+<bang>0,<q-args>)

" Functions
function InitWorkspace()
  :new
  :wincmd J
  :resize 15
  :set winfixheight
  :terminal
endfunction
nnoremap <LEADER>t :call InitWorkspace()<CR>

" deoplete.nvim
let g:deoplete#enable_at_startup = 1

call deoplete#custom#source('_', 'matchers', ['matcher_fuzzy',
  \ 'matcher_length'])

" denite.nvim
call denite#custom#source('tag', 'matchers', ['matcher/substring'])

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
call denite#custom#map(
  \ 'normal',
  \ 'a',
  \ '<denite:do_action:add>',
  \ 'noremap'
  \)
call denite#custom#map(
  \ 'normal',
  \ 'c',
  \ '<denite:do_action:reset>',
  \ 'noremap'
  \)
call denite#custom#map(
  \ 'normal',
  \ 'd',
  \ '<denite:do_action:delete>',
  \ 'noremap'
\)

nnoremap <C-o> :<C-u>Denite file_rec<CR>
nnoremap <C-f> :<C-u>Denite grep<CR>

" denite-git
noremap <LEADER>gs :<C-u>Denite gitstatus<CR>
noremap <LEADER>gl :<C-u>Denite gitlog<CR>
noremap <LEADER>gla :<C-u>Denite gitlog:all<CR>
noremap <LEADER>glf :<C-u>Denite gitlog::fix<CR>


" gen_tags.vim
let g:loaded_gentags#gtags=1
let g:gen_tags#ctags_auto_gen=1

" Windows
if has('win32')
  set guifont=Source\ Code\ Pro:h11,Consolas:h11

  " Python virtual envs
  let g:python3_host_prog=expand('$HOME/Envs/python37/Scripts/python.exe')
  let g:python_host_prog=expand('$HOME/Envs/python27/Scripts/python.exe')

" Unix
elseif has('unix')
  let s:uname = system("echo -n \"$(uname)\"") " get OS type

" OS X
  if !v:shell_error && s:uname == "Darwin"
    set guifont=Source\ Code\ Pro:h12,\ Menlo:h13

    " Python virtual envs
    let g:python3_host_prog=expand('$HOME/Envs/python37/bin/python')
    let g:python_host_prog=expand('$HOME/Envs/python27/bin/python')

" Linux
  else

  endif
endif
