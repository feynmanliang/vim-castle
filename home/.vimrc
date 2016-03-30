set nocompatible              " be iMproved, required
filetype off                  " required for Vundle

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins

Plugin 'tpope/vim-fugitive'
Plugin 'mhinz/vim-signify'
Plugin 'sjl/gundo.vim'
Plugin 'mileszs/ack.vim'

Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'

Plugin 'tpope/vim-commentary'
Plugin 'junegunn/vim-easy-align'
Plugin 'matze/vim-move'

Plugin 'scrooloose/syntastic'
Plugin 'plasticboy/vim-markdown'
Plugin 'pangloss/vim-javascript'
Plugin 'chrisbra/csv.vim'
Plugin 'elzr/vim-json'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

Plugin 'flazz/vim-colorschemes'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on " Filetype auto-detection
syntax on " Syntax highlighting

set tabstop=2
set shiftwidth=2
set softtabstop=2
set number
set expandtab " use spaces instead of tabs.
set smarttab " lets tab key insert 'tab stops', and bksp deletes tabs.
set shiftround " tab / shifting moves to closest tabstop.
set autoindent " Match indents on new lines.
set smartindent " Intellegently dedent / indent new lines based on rules.

" tab completion
set wildignore+=*.a,*.o
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=.DS_Store,.git,.hg,.svn
set wildignore+=*~,*.swp,*.tmp
" Wildmenu
if has("wildmenu")
    set wildignore+=*.a,*.o
    set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
    set wildignore+=.DS_Store,.git,.hg,.svn
    set wildignore+=*~,*.swp,*.tmp
    set wildmenu
    set wildmode=longest,list
endif

" We have VCS -- we don't need this stuff.
set nobackup " We have vcs, we don't need backups.
set nowritebackup " We have vcs, we don't need backups.
set noswapfile " They're just annoying. Who likes them?

" don't nag me when hiding buffers
set hidden " allow me to have buffers with unsaved changes.
set autoread " when a file has changed on disk, just load it. Don't ask.

" Make search more sane
set ignorecase " case insensitive search
set smartcase " If there are uppercase letters, become case-sensitive.
set incsearch " live incremental searching
set showmatch " live match highlighting
set hlsearch " highlight matches
set gdefault " use the `g` flag by default.

" allow the cursor to go anywhere in visual block mode.
set virtualedit+=block

" <leader> is a key that allows you to have your own "namespace" of keybindings.
let mapleader = "\\"

" bindings for easy split nav
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Use sane regex's when searching
nnoremap / /\v
vnoremap / /\v

" Visual line nav, not real line nav
" If you wrap lines, vim by default won't let you move down one line to the
" wrapped portion. This fixes that.
noremap j gj
noremap k gk

"
" Plugin settings:
"
"" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" vim-move modifier key
let g:move_key_modifier = 'C'

" Use silver searcher with ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Map the key for toggling comments with vim-commentary
nnoremap <leader>c <Plug>CommentaryLine

" Let ctrlp have up to 30 results.
let g:ctrlp_max_height = 30

" Airline
set laststatus=2 " always show statusline
let g:airline_theme='badwolf'
let g:airline_powerline_fonts=1 " use powerline fonts

" Set colors
colorscheme Tomorrow-Night
hi Normal ctermbg=none
highlight NonText ctermbg=none
