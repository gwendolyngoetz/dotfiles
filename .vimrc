set nocompatible              " required
set encoding=utf-8
filetype off                  " required

" Don't delete!
source $VIMRUNTIME/vimrc_example.vim

" *********************************************
" START VUNDLE
" *********************************************
" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin('$HOME/.vim/bundle/')
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" Add all your plugins here, call :PluginInstall after starting
"Plugin 'tmhedberg/SimpylFold'
"Plugin 'w0rp/ale'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'python-mode/python-mode'
Plugin 'scrooloose/nerdtree'
"Plugin 'ctrlpvim/ctrlp.vim'
"Plugin 'davidhalter/jedi-vim'
"Plugin 'PProvost/vim-ps1' 
"Plugin 'matze/vim-move'
"Plugin 'Valloric/YouCompleteMe'
"Plugin 'maralla/completor.vim'
Plugin 'chrisbra/Colorizer'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" END VUNDLE


" *********************************************
" Vim settings
" *********************************************
syntax on
colorscheme dracula
"set guifont=Consolas:h12:cANSI
set cursorline "highlight current line
set hlsearch "highlight search
set viminfo+=n$HOME/.vim/.viminfo
set number "Show line numbers
set relativenumber "Relative line numbers with current line showing actual line number
set expandtab "Convert tabs to spaces
set tabstop=4 "Tab size
set backspace=indent,eol,start
"set nowrap
"" folding settings
set foldmethod=indent
set foldlevel=99

" split settings
set splitbelow
set splitright

"let python_highlight_all=1


" *********************************************
" Keyboard Mappings
" *********************************************
" Remove arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" Enable folding with the spacebar
nnoremap <space> za

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"" Move line up/down
""nnoremap <A-K> :m .-2<CR>==
""nnoremap <A-J> :m .+1<CR>==

" Tabbing between buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" NERDTree settings
map <C-N> :NERDTreeToggle<CR>


" ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~
" Plugin Settings
" ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~


"" *********************************************
"" Completor settings
"" *********************************************
""let g:completor_python_binary = '$ProgramFiles/python35/lib/site-packages/jedi'


" *********************************************
" Airline settings
" *********************************************
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'


" *********************************************
" NERDTree settings
" *********************************************
" Open NERDTree and set cursor focus to file
let g:NERDTreeWinSize=24
let g:NERDTree_tabs_open_on_gui_startup=0
" autocmd vimenter * NERDTree | wincmd p 
" Close if NERDTree is the last buffer left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"
"" *********************************************
"" Python Mode
"" *********************************************
"let g:pymode_python = 'python3'
"let g:pymode_rope_lookup_project = 0
"let g:pymode_rope = 0


" *********************************************
" Colorizer settings
" *********************************************
map <C-c> :ColorToggle<CR>
