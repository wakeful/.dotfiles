set nocompatible
set backspace=2

set tabstop=2 shiftwidth=2 expandtab

" toggle auto-indenting on paste
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" set <Leader> key to ,
let mapleader = ","

" 121 char limit
set colorcolumn=121

" line wrapping at 120 char
set textwidth=120

" vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/plugins')

try
  call vundle#rc()
catch
  echohl Error | echo "Vundle is not installed. " | echohl None
endtry

Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'sickill/vim-monokai'

call vundle#end()  " required
filetype plugin indent on " required

" colors
syntax enable
" colorscheme monokai
set t_ut=
set t_Co=256

set background=dark
colorscheme base16-railscasts

highlight clear SignColumn
highlight VertSplit ctermbg=236
highlight ColorColumn ctermbg=237
highlight LineNr ctermbg=236 ctermfg=240
highlight CursorLineNr ctermbg=236 ctermfg=240
highlight CursorLine ctermbg=236
highlight StatusLineNC ctermbg=238 ctermfg=0
highlight StatusLine ctermbg=240 ctermfg=12
highlight IncSearch ctermbg=3 ctermfg=1
highlight Search ctermbg=1 ctermfg=3
highlight Visual ctermbg=3 ctermfg=0
highlight Pmenu ctermbg=240 ctermfg=12
highlight PmenuSel ctermbg=3 ctermfg=1
highlight SpellBad ctermbg=0 ctermfg=1

" nerdTree
nnoremap <Leader>n :NERDTreeToggle<CR>
let g:NERDTreeWinPos = "left"
let g:NERDTreeShowHidden = 1
let g:NERDTreeQuitOnOpen = 1

" search
set hlsearch
set ignorecase

" show invisible characters
set list

" show line numbers
set number
