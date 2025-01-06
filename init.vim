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
  call dein#add('icymind/NeoSolarized')
  call dein#add('neovim/nvim-lspconfig')

  call dein#add('Shougo/ddc.vim')
  call dein#add('Shougo/ddu.vim')
  call dein#add('Shougo/pum.vim')
  call dein#add('vim-denops/denops.vim')

  call dein#add('Shougo/ddc-matcher_head')
  call dein#add('Shougo/ddc-nvim-lsp')
  call dein#add('Shougo/ddc-path.vim')
  call dein#add('Shougo/ddc-sorter_rank')
  call dein#add('Shougo/neco-vim')

  call dein#add('Shougo/ddu-ui-ff')
  call dein#add('Shougo/ddu-kind-file')
  call dein#add('Shougo/ddu-filter-matcher_substring')
  call dein#add('Shougo/ddu-source-file')
  call dein#add('Shougo/ddu-source-file_rec')

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

" Shougo/pum.vim
inoremap <Tab>   <Cmd>call pum#map#insert_relative(+1)<CR>
inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
inoremap <PageDown> <Cmd>call pum#map#insert_relative_page(+1)<CR>
inoremap <PageUp>   <Cmd>call pum#map#insert_relative_page(-1)<CR>

" Shougo/ddu.vim
call ddu#custom#patch_global({
    \ 'ui': 'ff',
    \ 'kindOptions': {
    \   'file': {
    \     'defaultAction': 'open',
    \   },
    \ },
    \ 'sourceOptions': {
    \   '_': {
    \     'matchers': ['matcher_substring'],
    \   },
    \ },
    \ 'sources': [{
    \   'name': 'file',
    \   'params': {}
    \ }],
    \ })
" call ddu#start({'sources': [
"     \   {'name': 'file_rec', 'params': {'path': expand('~')}}
"     \ ]})

" ddc
call ddc#custom#patch_global('sources', ['around', 'nvim-lsp'])
call ddc#custom#patch_global('sourceOptions', {
    \ '_': {
    \   'matchers': ['matcher_head'],
    \   'sorters': ['sorter_rank'],
    \ },
    \ 'around': { 'mark': 'A' },
    \ 'necovim': {'mark': 'vim'},
    \ 'nvim-lsp': {
    \   'mark': 'lsp',
    \   'forceCompletionPattern': '\.\w*|:\w*|->\w*'
    \ },
    \ })
call ddc#custom#patch_global('sourceParams', {
    \ 'around': { 'maxSize': 500 },
    \ })
call ddc#custom#patch_filetype(
    \ ['vim'], 'sources', ['necovim'])
call ddc#custom#patch_filetype(
    \ ['c', 'cpp'], 'sources', ['around', 'clangd'])
call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', {
    \ 'clangd': { 'mark': 'C' },
    \ })
call ddc#custom#patch_filetype('markdown', 'sourceParams', {
    \ 'around': { 'maxSize': 100 },
    \ })
inoremap <silent><expr> <TAB>
    \ ddc#map#pum_visible() ? '<C-n>' :
    \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
    \ '<TAB>' : ddc#map#manual_complete()
inoremap <expr><S-TAB>  ddc#map#pum_visible() ? '<C-p>' : '<C-h>'
call ddc#enable()

" lspconfig
lua << EOF
  local opts = { noremap=true, silent=true }
  vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

  local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  local servers = { 'ts_ls' }
  for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup { on_attach = on_attach }
  end
EOF

" Windows
if has('win32')
  set guifont=Source\ Code\ Pro:h11,Consolas:h11

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
