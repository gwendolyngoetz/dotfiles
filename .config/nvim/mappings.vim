" Keyboard Mappings

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

" Nvim Tree settings
map <C-n> :NvimTreeToggle<CR>

" Colorizer
map <C-c> :ColorizerToggle<CR>
