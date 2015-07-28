set nocompatible

" Required Vundle setup 
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle
Plugin 'gmarik/vundle'

"
" Begin Vundle Packages!!!!!
"

" Fuzzy File Finder
Plugin 'kien/ctrlp.vim'
" Plugin to delete buffers in ctrlp
Plugin 'd11wtq/ctrlp_bdelete.vim'

" Silver surfer plugin for vim
"Plugin 'rking/ag.vim'

" Search everything
Plugin 'shougo/unite.vim'

" Explore everything
Plugin 'shougo/vimfiler.vim'

" Search everything faster
Plugin 'shougo/vimproc.vim'

" Fast commenting
Plugin 'scrooloose/nerdcommenter'

" Tab Autocompletion
Plugin 'ervandew/supertab'

" Smarter autoclosing 
" https://github.com/jiangmiao/auto-pairs
Plugin 'jiangmiao/auto-pairs'

" Better Javascript syntax highlighting
"Plugin 'pangloss/vim-javascript'

" Better Javascript syntax highlighting
Plugin 'jelera/vim-javascript-syntax'

" Easymotion!
Plugin 'Lokaltog/vim-easymotion'
"Plugin 'joequery/Stupid-EasyMotion'

" BufSurf
Plugin 'ton/vim-bufsurf'

" Set paste mode automatically, even in tmux 
Plugin 'ConradIrwin/vim-bracketed-paste'

" Kill buffers nicely, without losing split
Plugin 'mattdbridges/bufkill.vim'

" Gruvbox colorscheme
Plugin 'morhetz/gruvbox'

"
" End Vundle Packages!!!!!
"

" All packages must be listed above this line
call vundle#end()
filetype plugin indent on

" automatically reload vimrc when it's saved
"au BufWritePost .vimrc so ~/.vimrc

" Set 256 color and color scheme
if !has("gui_running")
   let g:gruvbox_italic=0
endif
set term=xterm
set t_Co=256
set background=dark
"colorscheme base16-twilight
colorscheme gruvbox

" Turn on all python syntax highlighting options
let python_highlight_all = 1

"
" Bufkill, splits
"
nnoremap <Leader>bd :BD<CR>
"nnoremap <Leader>V <C-w>v


" Set modifiable buffers so NERDTree can edit
set modifiable

set hidden

set scrolloff=5

set mouse=a

set clipboard=unnamed

set backspace=indent,eol,start 

set textwidth=80

set noswapfile

"set incsearch
set hlsearch


" Navigate splits
nnoremap <C-k> <C-w>k    
nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Move along wrapped lines
"nnoremap k gk
"nnoremap j gj
"nnoremap 0 g0
"nnoremap $ g$
"nnoremap ^ g^

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

set autoindent "Auto indent
set smartindent "Smart indent
set smarttab
set wrap "Wrap lines

set ignorecase
set smartcase

" Map leader to ',' (usually) '\'
let mapleader = ","

" Map save to leader ',' + w
noremap <Leader>w :update<CR>

" Map quit to leader ',' + q
noremap <Leader>q :quit<CR>

" Make uppercase U 'redo' insted of Ctr + R, which is a pain
nnoremap U <C-r>

" JUMPING
" Map single quote to ` so going to a mark puts you in the right column too
nnoremap ' `

" Switch Ctrl I and Ctrl O for more natural 'forward' 'back' when jumping
"nnoremap <C-I> <C-O>
"nnoremap <C-O> <C-I>
nmap <silent> <C-i> :BufSurfBack<CR>
nmap <silent> <C-o> :BufSurfForward<CR>

" Easymotion shortcut
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Bi-directional find motion
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-s2)
vmap s <Plug>(easymotion-s2)

" Press jk while in insert mode to go back to normal mode
inoremap jk <Esc>
inoremap kj <Esc>

" No delay exiting visual mode with esc
set timeoutlen=1000 ttimeoutlen=0

set ruler
set cursorline
set relativenumber
set number
syntax enable

" Cursor becomes vertical line in insert mode and block in normal
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

"" Move lines and blocks with Alt j and Alt k
"" see http://vim.wikia.com/wiki/Moving_lines_up_or_down
" Normal mode
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==

" Insert mode
inoremap ∆ <ESC>:m .+1<CR>==gi
inoremap ˚ <ESC>:m .-2<CR>==gi

" Visual mode
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv



"let NERDTreeHijackNetrw = 1
"map <C-e> :NERDTreeToggle<CR>

"
" UNITE
"
" "Map space to the prefix for Unite
nnoremap [unite] <Nop>
nmap <space> [unite]

" Set up unite grepping with Ag
let g:unite_source_grep_command = 'ag'
	  let g:unite_source_grep_default_opts =
	  \ '-i --line-numbers --nocolor --nogroup --hidden -S --ignore ' .
	  \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
	  let g:unite_source_grep_recursive_opt = ''

nnoremap <silent> [unite]g :<C-u>Unite -buffer-name=search grep:.<cr>
nnoremap <silent> [unite]w :<C-u>UniteWithCursorWord -buffer-name=search grep:.<cr>


"" Set Vimfiler as default explorer and disable netrw
let g:vimfiler_as_default_explorer = 1
let g:loaded_netrwPlugin = 1

"" Map VimFiler to space e
nmap [unite]e :VimFiler -find<CR>

"" Open VimFiler if vim is called with no arguments
function! StartUp()
    if argc() == 0
        VimFiler
    end
endfunction

autocmd VimEnter * call StartUp()

" Use control to move in insert mode in unite
" General recursive fuzzy file search in working directory
" General recursive fuzzy file search in entire Code folder, ignoring
" unimportant files
" Create new file and open in new buffer
" open files in split or tabs
"

"
" CtrlP (fuzzy file search) settings
"
"
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'

" Search on filename instead of full path
let g:ctrlp_by_filename = 1

" Ctrl u opens buffer search
nnoremap <C-u> :CtrlPBuffer <CR> 

" Init plugin to delete buffers from ctrlpbuffer
" CTRL - 2 deletes buffers in ctrl p, can mark with ctrl z
call ctrlp_bdelete#init()

" Use Ag to index
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "**/*.pyc"
      \ -g ""'

" The Silver Searcher
"if executable('ag')
  " Use ag over grep
  "set grepprg=ag\ --nogroup\ --nocolor

" bind K to grep word under cursor
"nnoremap K :Ag! '\b<C-R><C-W>\b'<CR>:cw<CR>

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  "let g:ctrlp_user_command = 'ag %s -l --nocolor -g ''"

  " ag is fast enough that CtrlP doesn't need to cache
  "let g:ctrlp_use_caching = 0
"endif


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


"
" Syntax Highlighting 
"

" .ejs files highlighted as html
au BufNewFile,BufRead *.ejs set filetype=html
au BufNewFile,BufRead *.dust set filetype=html
