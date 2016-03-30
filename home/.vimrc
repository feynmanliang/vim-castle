set nocompatible " Required for Vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Let Vundle manage itself
Plugin 'gmarik/vundle.vim'

" Plugins
Plugin 'scrooloose/syntastic'
Plugin 'bling/vim-airline'
Plugin 'elzr/vim-json'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'plasticboy/vim-markdown'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'sjl/gundo.vim'
Plugin 'tpope/vim-fugitive'

" Color schemes
Plugin 'w0ng/vim-hybrid'

" required, plugins available after.
call vundle#end()
filetype plugin indent on
