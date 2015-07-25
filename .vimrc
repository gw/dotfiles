set nocompatible

" Required Vundle setup 
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Bundle 'gmarik/vundle'
"
" Begin Vundle Packages!!!!!
"

" Fuzzy File Finder
Bundle 'kien/ctrlp.vim'

" Fast commenting
Bundle 'scrooloose/nerdcommenter'

" File explorer gutter
Bundle 'scrooloose/nerdtree'

" Tab Autocompletion
Bundle 'ervandew/supertab'

" Smarter autoclosing 
Bundle 'jiangmiao/auto-pairs'

" Solarized color scheme
Bundle 'altercation/vim-colors-solarized'

" Better Javascript syntax highlighting
Bundle 'jelera/vim-javascript-syntax'


"
" End Vundle Packages!!!!!
"

" All packages must be listed above this line
call vundle#end()
filetype plugin indent on

set modifiable

set scrolloff=5

set mouse=a

" 1 tab == 4 spaces
set shiftwidth=2
set tabstop=2
imap <S-Tab> <C-o><<

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" Change existing tab characters to spaces
retab

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Remap switching between tabs to ctrl + j, k (to move) and n (to make new)
map  <C-k> :tabn<CR>
map  <C-j> :tabp<CR>
map  <C-n> :tabnew<CR>

" Remap switching between split panes to ctrl + h, l
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" CtrlP (fuzzy file search) settings
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0


" Map leader to ',' (usually) '\'
let mapleader = ","

" Map save to leader ',' + w
noremap <Leader>w :update<CR>

" Make uppercase U 'redo' insted of Ctr + R, which is a pain
nnoremap U <C-r>

" Press jk while in insert mode to go back to normal mode
inoremap jk <Esc>

set ruler
set cursorline
set number
syntax enable

let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Set Solarized theme
set background=dark
colorscheme solarized

" NERDTree autostart
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" NERDTree toggle
map <C-n> :NERDTreeToggle<CR>

" Close NERDTree if it's the only window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"Remap coyping and pasting from clipboard
vnoremap <C-c> :w !pbcopy<CR><CR> 
noremap <C-v> :r !pbpaste<CR><CR>

" In view mode, press enter on a word to toggle highlighting on all instances of that word. 
let g:highlighting = 0
function! Highlighting()
	  if g:highlighting == 1 && @/ =~ '^\\<'.expand('<cword>').'\\>$'
		      let g:highlighting = 0
		          return ":silent nohlsearch\<CR>"
			    endif
			      let @/ = '\<'.expand('<cword>').'\>'
			        let g:highlighting = 1
				  return ":silent set hlsearch\<CR>"
			  endfunction
			  nnoremap <silent> <expr> <CR> Highlighting()

