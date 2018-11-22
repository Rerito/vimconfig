set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'Vimball'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'

" Solarized color scheme
Plugin 'altercation/vim-colors-solarized'

" JellyBeans color scheme
Plugin 'nanotech/jellybeans.vim'

" Inkpot color scheme
Plugin 'ciaranm/inkpot'

" Color scheme pack
Plugin 'flazz/vim-colorschemes'

" Bandit color scheme
Plugin 'bandit.vim'

" On the flight syntax check
Plugin 'scrooloose/syntastic'

" Source-code browser
Plugin 'majutsushi/tagbar'

" gundo, displays undo tree
Plugin 'sjl/gundo.vim'

" Air-line
Plugin 'bling/vim-airline'

" Autocomplete
Plugin 'davidhalter/jedi-vim'

Plugin 'javacomplete'

Plugin 'Valloric/YouCompleteMe'

" CTags Highlighting
Plugin 'TagHighlight'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set textwidth=80  " lines longer than 79 columns will be broken
set shiftwidth=2  " operation >> indents 4 columns; << unindents 4 columns
set tabstop=2     " a hard TAB displays as 4 columns
set expandtab     " insert spaces when hitting TABs
set softtabstop=2 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
set shiftround    " round indent to multiple of 'shiftwidth'
set autoindent    " align the new line indent with the previous line
set clipboard=unnamedplus

" Gundo
nnoremap <F3> :GundoToggle<CR>
let g:gundo_prefer_python3 = 1

" Tagbar
nmap <F8> :TagbarToggle <CR>

" YCM
let g:ycm_always_populate_location_list = 1


" Solarized
syntax enable
set t_Co=256
set background=dark

" Nerd-tree
map <C-n> :NERDTreeToggle<CR>

" Air-line
set laststatus=2
let g:airline_powerline_fonts=1

" Toogle the errors panel
function! ToggleErrors()
  if empty(filter(tabpagebuflist(), 'getbufvar(v:val, "&buftype") is# "quickfix"'))
    " No location/quickfix list shown, open syntastic error location
    " panel
    Errors
  else
    lclose
  endif
endfunction

function! GetCTagsFile()
"  set tags=%:p:h/.git/tags;/ 
"  let &tags = &tags . "," .  expand("%:p:h") . "/.git/cpp_tags;/"
  set tags+=~/.vim/tags/stl_tags
endfunction
" function! getCTagsFile()
"  let shellcmd = 'git rev-parse --show-toplevel '.a:%

" Change title of the terminal:

autocmd BufEnter * let &titlestring = hostname() . "[vim(" . expand("%:t") . ")]"

if &term == "screen"
  set t_ts=k
  set t_fs=\
endif

if &term == "screen" || &term == "xterm"
  set title
endif

" auto close options when exiting insert mode
 autocmd InsertLeave * if pumvisible() == 0|pclose|endif
 set completeopt=menu,menuone

" -- configs --
"let OmniCpp_MayCompleteDot = 1 " autocomplete with .
"let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
"let OmniCpp_MayCompleteScope = 1 " autocomplete with ::
"let OmniCpp_SelectFirstItem = 2 " select first item (but don't insert)
"let OmniCpp_NamespaceSearch = 2 " search namespaces in this and included files
"let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype (i.e. parameters) 

if(has("autocmd"))
  autocmd Filetype java setlocal omnifunc=javacomplete#Complete
endif

call GetCTagsFile()

nnoremap <silent> <C-e> :<C-u>call ToggleErrors()<CR>
