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
set paste
"colorscheme molokai
set t_Co=256
let g:molokai_original = 1
set autoindent
set cindent
set smartindent
set ignorecase
set backspace=eol,start,indent
set showmatch
set encoding=utf-8
set fileencodings=utf-8,cp949


"filetype off


set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'The-NERD-Tree'
Plugin 'AutoComplPop'
Plugin 'taglist-plus'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'fatih/vim-go'
Plugin 'vim-scripts/Conque-GDB'
call vundle#end()

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
 



let g:airline#extensions#tabline#enabled = 1 " turn on buffer list
let g:airline_theme='hybrid'
set laststatus=2 " turn on bottom bar

let g:NERDTreeDirArrows=0
map <F2> :NERDTreeToggle<CR>

nmap <F3> <c-]>
nmap <F4> <c-t>
nmap <c-d> <dd>
noremap <TAB> <C-W>w


set csprg=/usr/bin/cscope
set csto=0
set cst
set nocsverb
if filereadable("./cscope.out")
	cs add cscope.out
endif
set csverb


let g:ConqueTerm_Color = 2                                                            
let g:ConqueTerm_CloseOnEnd = 1                                                       
let g:ConqueTerm_StartMessages = 0                                                    
let g:ConqueGdb_SrcSplit = 'left'                                                                                      
function DebugSession()                                                               
    !g++ -o vimgdb -g % -std=c++11                                            
	"redraw!                                                                           
    if (filereadable("vimgdb"))                                                       
        ConqueGdb vimgdb      
		call conque_gdb#command("break main")
		call conque_gdb#command("run")

    else                                                                              
        echom "Couldn't find debug file"                                              
    endif                                                                             
endfunction                                                                           
function DebugSessionCleanup(term)                                                    
    if (filereadable("vimgdb"))                                                       
        let ds=delete("vimgdb")                                                       
    endif                                                                             
endfunction

function DebugNext()
	call conque_gdb#command("next")
	call conque_gdb#command("info local")
endfunction

call conque_term#register_function("after_close", "DebugSessionCleanup")              
nmap <leader>d :call DebugSession()<CR>  
nmap <F5> :call conque_gdb#command("step")<CR>
"nmap <F6> :call conque_gdb#command("next")<CR>
nmap <F6> :call DebugNext()<CR>
