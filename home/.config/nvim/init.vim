" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:

" Neovim {

" Neovim Python Provider {
let g:python_host_prog="/home/fliang/.pyenv/versions/neovim2/bin/python"
let g:python3_host_prog="/home/fliang/.pyenv/versions/neovim3/bin/python"
" }

" }

" Environment {
    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=zsh\ -l
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
            set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }

    " Arrow Key Fix {
        " https://github.com/spf13/spf13-vim/issues/780
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    " }
" }

" Bundles {

    call plug#begin('~/.config/nvim/plugged')
    " Plugins {
        Plug 'tpope/vim-fugitive'
        Plug 'mhinz/vim-signify'
        Plug 'mbbill/undotree'
        Plug 'luochen1990/rainbow'

        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        Plug 'junegunn/fzf.vim'
        Plug 'scrooloose/nerdtree'
        " Plug 'Xuyuanp/nerdtree-git-plugin'

        Plug 'tpope/vim-dispatch'

        Plug 'neomake/neomake'

        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
        Plug 'carlitux/deoplete-ternjs'
        Plug 'zchee/deoplete-jedi'
        Plug 'zchee/deoplete-clang'

        " Plug 'ervandew/supertab'
        if has('python') && v:version >= 704
            Plug 'SirVer/ultisnips', { 'on': [] } | Plug 'honza/vim-snippets'
        endif

        " Automatic completion of parenthesis, brackets, etc.
        Plug 'Raimondi/delimitMate'
        let g:delimitMate_expand_cr=1                 " Put new brace on newline after CR

        " On save, create directories if they don't exist
        Plug 'dockyard/vim-easydir'

        " On Arch Linux, the exuberant-ctags executable is named 'ctags'. Elsewhere, it
        " is 'ctags-exuberant'. On Macs, the ctags executable provided is NOT exuberant
        " ctags.
        if executable('ctags') && !OSX() || executable('ctags-exuberant')
            Plug 'xolox/vim-easytags' | Plug 'xolox/vim-misc'
            if !WINDOWS()
                let g:easytags_async=1
            endif
        endif

        " Class outline viewer
        if has('patch-7.0.167')
            Plug 'majutsushi/tagbar'
            nnoremap <leader>tb :TagbarToggle<cr>
        endif

        Plug 'chrisbra/SudoEdit.vim'
        Plug 'tpope/vim-commentary' " bound to 'gcc' and 'gc' keys
        Plug 'tpope/vim-surround'
        Plug 'justinmk/vim-sneak'
        Plug 'matze/vim-move'
        Plug 'tpope/vim-sleuth'
        Plug 'junegunn/vim-easy-align'
        Plug 'ntpeters/vim-better-whitespace'

        Plug 'othree/html5.vim', { 'for': ['html', 'jinja'] }
        Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'scss'] }
        Plug 'groenewege/vim-less', { 'for': 'less' }
        Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
        Plug 'mxw/vim-jsx', { 'for': ['javascript', 'jsx'] }
        Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }

        " LaTeX compilation commands and autocomplete
        if executable('latexmk')
          Plug 'LaTeX-Box-Team/LaTeX-Box', { 'for': 'tex' }
          let g:LatexBox_latexmk_preview_continuously=1 " Auto-compile TeX on save
          let g:LatexBox_build_dir='latexmk'            " Build files are in 'latexmk'
          let g:LatexBox_loaded_matchparen=0            " Disable LatexBox paren matching for performance
        endif

        Plug 'plasticboy/vim-markdown'
        " Markdown preview
        if has('nvim') && executable('cargo')
          function! g:BuildComposer(info)
            if a:info.status !=# 'unchanged' || a:info.force
              !cargo build --release
              UpdateRemotePlugins
            endif
          endfunction

          Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
          let g:markdown_composer_syntax_theme='hybrid'
        elseif executable('npm')
          Plug 'euclio/vim-instant-markdown', {
                \ 'for': 'markdown',
                \ 'do': 'npm install euclio/vim-instant-markdown-d'
                \}
        endif

        Plug 'avakhov/vim-yaml', { 'for': 'yaml' }
        Plug 'cespare/vim-toml', { 'for': 'toml' }
        Plug 'chrisbra/csv.vim', { 'for': 'csv' }
        Plug 'elzr/vim-json', { 'for': 'json' }
        "
        "" Filetype plugin for Scala and SBT
        " Plug 'derekwyatt/vim-scala', { 'for': ['scala', 'sbt.scala'] }
        " Plug 'derekwyatt/vim-sbt', { 'for': 'sbt.scala' }
        "
        " Plug 'racer-rust/vim-racer'
        "
        " Plug 'rust-lang/rust.vim'
        " let g:rustfmt_autosave = 1
        " let g:rustfmt_fail_silently = 1

        Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

        " " Haskell omnifunc
        " if executable('ghc-mod')
        "   Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
        "   let g:necoghc_enable_detailed_browse=1          " Show types of symbols
        " endif

        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'

        Plug 'w0ng/vim-hybrid'
    " }
    call plug#end()
" }

" General {
    filetype plugin indent on " Filetype auto-detection
    syntax on " Syntax highlighting
    scriptencoding utf-8

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    set shortmess+=filmnrxoOtT                      " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore                         " Allow for cursor beyond last character
    set virtualedit+=block                          " allow the cursor to go anywhere in visual block mode.
    set history=1000                                " Store a ton of history (default is 20)
    set hidden                                      " allow me to have buffers with unsaved changes.
    set autoread                                    " when a file has changed on disk, just load it. Don't ask.
    set iskeyword-=.                                " '.' is an end of word designator
    set iskeyword-=#                                " '#' is an end of word designator
    set iskeyword-=-                                " '-' is an end of word designator

    " Restore cursor to file position in previous editing session
    function! ResCur()
        if line("'\"") <= line("$")
            silent! normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " Setting up the directories {
        " We have VCS -- we don't need this stuff.
        set nobackup      " We have vcs, we don't need backups.
        set nowritebackup " We have vcs, we don't need backups.
        set noswapfile    " They're just annoying. Who likes them?
        if has('persistent_undo')
            set undofile         " So is persistent undo ...
            set undolevels=1000  " Maximum number of changes that can be undone
            set undoreload=10000 " Maximum number lines to save for undo on a buffer reload
        endif
    " }
" }

" Vim UI {
    set background=dark " Assume dark background
    colorscheme hybrid
    " Transparent terminal background
    highlight Normal ctermbg=none
    highlight NonText ctermbg=none

    " Bold syntax highlighting {
        highlight Comment     cterm=none
        highlight Conditional cterm=bold
        highlight Constant    cterm=none
        highlight Identifier  term=none
        highlight Number      cterm=bold
        highlight PreProc     cterm=bold
        highlight Special     term=none
        highlight Statement   cterm=bold
        highlight String      cterm=bold
        highlight Todo        cterm=bold
        highlight Type        cterm=bold
        highlight Underlined  cterm=bold,underline
        highlight Ignore      cterm=bold
    " }

    set tabpagemax=15 " Only show 15 tabs
    set showmode      " Display the current mode
    set cursorline    " Highlight current line
    "set cursorcolumn  " Highlight current column
    set colorcolumn=120 " Highlight max 120cw

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=%{fugitive#statusline()} " Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    " set relativenumber              " Relative line numbers
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    "set gdefault                    " use the `g` flag by default.

    " tab completion
    set wildignore+=*.a,*.o,*.so,*.pyc
    "set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
    set wildignore+=.DS_Store,.git,.hg,.svn
    set wildignore+=*~,*.swp,*.tmp
    " Wildmenu
    if has("wildmenu")
        set wildignore+=*.a,*.o
        "set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
        set wildignore+=.DS_Store,.git,.hg,.svn
        set wildignore+=*~,*.swp,*.tmp
        set wildmenu                    " Show list instead of just completing
        set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    endif

    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Formatting {
    set nowrap        " Do not wrap long lines
    set autoindent    " Indent at the same level of the previous line
    set shiftwidth=4  " Use indents of 4 spaces
    set expandtab     " Tabs are spaces, not tabs
    set smarttab      " lets tab key insert 'tab stops', and bksp deletes tabs.
    set shiftround    " tab / shifting moves to closest tabstop.
    set smartindent   " Intellegently dedent / indent new lines based on rules.
    set tabstop=4     " An indentation every 4 columns
    set softtabstop=4 " Let backspace delete indent
    set nojoinspaces  " Prevents inserting two spaces after punctuation on a join (J)
    set splitright    " Puts new vsplit windows to the right of the current
    set splitbelow    " Puts new split windows to the bottom of the current
    set pastetoggle=<F12> " pastetoggle (sane indentation on pastes)
    " set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,scala,yml setlocal expandtab shiftwidth=2 softtabstop=2
    " preceding line best in a plugin but here for now.

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell,rust setlocal nospell

    " LaTex editing performance tweaks
    au FileType tex setlocal nocursorline norelativenumber
    au FileType tex :NoMatchPare
" }

" Key (re)Mappings {

" The default leader is '\', but many people prefer ',' as it's in a standard
" location. To override this behavior and set it back to '\' (or any other
" character) add the following to your .vimrc.before.local file:
" let mapleader='\\'
let mapleader = ','
let maplocalleader = '_'

" Easier moving in tabs and windows
" The lines conflict with the default digraph mapping of <C-K>
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-L> <C-W>l<C-W>_
map <C-H> <C-W>h<C-W>_

" End/Start of line motion keys act relative to row/wrap width in the
" presence of `:set wrap`, and relative to line for `:set nowrap`.
" Default vim behaviour is to act relative to text line in both cases
" Same for 0, home, end, etc
function! WrapRelativeMotion(key, ...)
    let vis_sel=""
    if a:0
        let vis_sel="gv"
    endif
    if &wrap
        execute "normal!" vis_sel . "g" . a:key
    else
        execute "normal!" vis_sel . a:key
    endif
endfunction

" Map g* keys in Normal, Operator-pending, and Visual+select
noremap $ :call WrapRelativeMotion("$")<CR>
noremap <End> :call WrapRelativeMotion("$")<CR>
noremap 0 :call WrapRelativeMotion("0")<CR>
noremap <Home> :call WrapRelativeMotion("0")<CR>
noremap ^ :call WrapRelativeMotion("^")<CR>
" Overwrite the operator pending $/<End> mappings from above
" to force inclusive motion with :execute normal!
onoremap $ v:call WrapRelativeMotion("$")<CR>
onoremap <End> v:call WrapRelativeMotion("$")<CR>
" Overwrite the Visual+select mode mappings from above
" to ensure the correct vis_sel flag is passed to function
vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>

" Stupid shift key fixes
if has("user_commands")
    command! -bang -nargs=* -complete=file E e<bang> <args>
    command! -bang -nargs=* -complete=file W w<bang> <args>
    command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    command! -bang -nargs=* -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif

cmap Tabe tabe

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Code folding options
nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>

" Most prefer to toggle search highlighting rather than clear the current
" search results.
nmap <silent> <leader>/ :set invhlsearch<CR>

" Shortcuts
" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" Some helpers to edit mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Adjust viewports to the same size
map <Leader>= <C-w>=

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

" Easier horizontal scrolling
map zl zL
map zh zH

" Easier formatting
nnoremap <silent> <leader>q gwip

" Python ctags
" map <F11> :!ctags -R -f ./tags . `python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"`<CR>

" Switch to buffer
map <F2> :ls<CR>:b<Space>

" }

" Plugins {

" OmniComplete {
if has("autocmd") && exists("+omnifunc")
autocmd Filetype *
            \if &omnifunc == "" |
            \setlocal omnifunc=syntaxcomplete#Complete |
            \endif
endif

hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

" Some convenient mappings
"inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

" Automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menu,preview,longest
" }

" Ctags {
set tags=~/.vimtags

" enable asynchronous tag file updates
let g:easytags_async = 1

" Make tags placed in .git/tags file available in all levels of a repository
" let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
" if gitroot != ''
"     let &tags = &tags . ',' . gitroot . '/.git/tags'
" endif
" }

" NerdTree {
if isdirectory(expand("~/.config/nvim/plugged/nerdtree/"))
"map <C-e> <plug>NERDTreeTabsToggle<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>n :NERDTreeToggle<CR>

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=0
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0

" close if NERDTree is only buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

endif
" }

" fzf {
if isdirectory(expand("~/.config/nvim/plugged/fzf.vim/"))
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git --ignore node_modules --ignore target --ignore dist --ignore build -g ""'
nnoremap <c-p> :Files<cr>
nnoremap <c-l> :Ag<cr>

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
endif
"}

" better-whitespace {
if isdirectory(expand("~/.config/nvim/plugged/vim-better-whitespace/"))
nnoremap <leader>W :StripWhitespace<CR>
let g:strip_whitespace_on_save = 1
endif
" }

" TagBar {
if isdirectory(expand("~/.config/nvim/plugged/tagbar/"))
nnoremap <silent> <leader>tt :TagbarToggle<CR>
endif
"}

" Rainbow {
if isdirectory(expand("~/.config/nvim/plugged/rainbow/"))
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
endif
"}

" Fugitive {
if isdirectory(expand("~/.config/nvim/plugged/vim-fugitive/"))
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
" Mnemonic _i_nteractive
nnoremap <silent> <leader>gi :Git add -p %<CR>
nnoremap <silent> <leader>gg :SignifyToggle<CR>
endif
" }

" deoplete.nvim {
if isdirectory(expand("~/.config/nvim/plugged/deoplete.nvim/"))
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_ignore_case = 1
    let g:deoplete#enable_smart_case = 1
    let g:deoplete#enable_camel_case = 1
    let deoplete#sources#jedi#show_docstring = 1
    call deoplete#custom#set('_', 'min_pattern_length', 1)

    let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
    let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'

endif
" }

" ultisnips {
if isdirectory(expand("~/.config/nvim/plugged/ultisnips/"))
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" defer loading ultisnips until first entering insert mode
augroup load_us
    autocmd!
    autocmd InsertEnter * call plug#load('ultisnips')
                \| autocmd! load_us
augroup END
endif
" }

" UndoTree {
if isdirectory(expand("~/.config/nvim/plugged/undotree/"))
nnoremap <Leader>u :UndotreeToggle<CR>
" If undotree is opened, it is likely one wants to interact with it.
let g:undotree_SetFocusWhenToggle=1
endif
" }

" neomake {
autocmd! BufWritePost,BufEnter * Neomake
nmap <Leader><Space>o :lopen<CR>      " open location window
nmap <Leader><Space>c :lclose<CR>     " close location window
" nmap <Leader><Space>, :ll<CR>         " go to current error/warning
" nmap <Leader><Space>n :lnext<CR>      " next error/warning
" nmap <Leader><Space>p :lprev<CR>      " previous error/warning
" }

" Syntastic {
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 0 " no quickfix list
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" }

" Signify {
"" highlight signs in Sy
highlight SignifySignAdd    cterm=bold ctermbg=none ctermfg=119
highlight SignifySignDelete cterm=bold ctermbg=none ctermfg=167
highlight SignifySignChange cterm=bold ctermbg=none ctermfg=227
highlight clear SignColumn
" }

" EasyAlign {
"" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }

" vim-airline {
" Set configuration options for the statusline plugin vim-airline.
" Use the powerline theme and optionally enable powerline symbols.
" To use the symbols , , , , , , and .in the statusline
" segments add the following to your .vimrc.before.local file:
let g:airline_powerline_fonts=1
" If the previous symbols do not render for you then install a
" powerline enabled font.
"
" See `:echo g:airline_theme_map` for some more choices
" Default in terminal vim is 'dark'
if isdirectory(expand("~/.config/nvim/plugged/vim-airline-themes/"))
    if !exists('g:airline_theme')
        let g:airline_theme = 'powerlineish'
    endif
    if !exists('g:airline_powerline_fonts')
        " Use the default set of separators with a few customizations
        let g:airline_left_sep='›'  " Slightly fancier than '>'
        let g:airline_right_sep='‹' " Slightly fancier than '<'
    endif
endif
" }

" vim-move {
" vim-move modifier key
let g:move_key_modifier = 'C'
" }

" GUI Settings {

if has('gui_running')
" GVIM- (here instead of .gvimrc)
set guioptions-=T           " Remove the toolbar
set lines=40                " 40 lines of text instead of 24
else
if &term == 'xterm' || &term == 'screen'
    set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
endif
"set term=builtin_ansi       " Make arrow and other keys work
endif

" }

" Functions {

" Initialize directories {
function! InitializeDirectories()
let parent = $HOME
let prefix = 'vim'
let dir_list = {
            \ 'backup': 'backupdir',
            \ 'views': 'viewdir',
            \ 'swap': 'directory' }

if has('persistent_undo')
    let dir_list['undo'] = 'undodir'
endif

let common_dir = parent . '/.' . prefix

for [dirname, settingname] in items(dir_list)
    let directory = common_dir . dirname . '/'
    if exists("*mkdir")
        if !isdirectory(directory)
            call mkdir(directory)
        endif
    endif
    if !isdirectory(directory)
        echo "Warning: Unable to create backup directory: " . directory
        echo "Try: mkdir -p " . directory
    else
        let directory = substitute(directory, " ", "\\\\ ", "g")
        exec "set " . settingname . "=" . directory
    endif
endfor
endfunction
call InitializeDirectories()
" }

" Shell command {
function! s:RunShellCommand(cmdline)
botright new

setlocal buftype=nofile
setlocal bufhidden=delete
setlocal nobuflisted
setlocal noswapfile
setlocal nowrap
setlocal filetype=shell
setlocal syntax=shell

call setline(1, a:cmdline)
call setline(2, substitute(a:cmdline, '.', '=', 'g'))
execute 'silent $read !' . escape(a:cmdline, '%#')
setlocal nomodifiable
1
endfunction

command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
" e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
" }

" }

