syntax on
set ts=4
set nu
set hlsearch
set nocompatible
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

filetype plugin indent on
call vundle#begin()
Plugin 'The-NERD-Tree'
Plugin 'AutoComplPop'
Plugin 'taglist-plus'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/syntastic'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'morhetz/gruvbox'
Plugin 'junegunn/fzf'
call vundle#end()
"autocmd BufEnter * lcd %:p:h

let g:airline#extensions#tabline#enabled = 1 " turn on buffer list
let g:airline_theme='hybrid'
set laststatus=2 " turn on bottom bar

let g:NERDTreeDirArrows=0
map <F2> :NERDTreeToggle<CR>

nmap <F3> <c-]>
nmap <F4> <c-t>
nmap <c-d> <dd>
noremap <TAB> <C-W>w

autocmd BufWritePre * %s/\s\+$//e

set csprg=cscope
set csto=0
set cst
set nocsverb
if filereadable("./cscope.out")
	cs add cscope.out
else
	cs add /home/seongdeok.han/develop/Reprogram_UnitTest/0501/cscope.out
endif
set csverb

set tags=./tags

"colorscheme jellybeans
colorscheme gruvbox
set bg=dark
nnoremap <C-h> :bp<CR>
nnoremap <C-l> :bn<CR>
nnoremap <C-o> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-i': 'split',
  \ 'ctrl-v': 'vsplit' }
