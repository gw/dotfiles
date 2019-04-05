" Prerequisites (in leu of a an install script)
" Ripgrep
" .agignore should be set up, pref symlinked from .gitignore_global
" clang, libclang (deoplete)
" ~/.nvim/undodir must exist (for persistent undo)
"
"
"
"
"
"
call plug#begin('~/.nvim/plugged')

"Colors
Plug 'endel/vim-github-colorscheme'
Plug 'connorholyday/vim-snazzy'

"File/Project Search/Switching
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'jeetsukumaran/vim-filebeagle'

"Text navigation
Plug 'easymotion/vim-easymotion'
Plug 'rhysd/clever-f.vim'
Plug 't9md/vim-quickhl'

"File settings, indentation
Plug 'tpope/vim-sleuth'
Plug 'ntpeters/vim-better-whitespace'

" Git
Plug 'tpope/vim-fugitive'

call plug#end()

set termguicolors
colorscheme snazzy

"
"
"
"
"
" BASIC CONFIG
"
"
"
"
"

let mapleader="\<SPACE>"

"Buffer screen redraws for performance
set lazyredraw

"Always 5 lines b/w cursor and window edge
set scrolloff=10

"Don't wrap long lines
set nowrap

"Display tabs as 4 spaces. Everything else is left to vim-sleuth
set tabstop=4

"Case insensitive searching
set ignorecase
"...Unless query has capital letters
set smartcase

"Enable folding by indent
set foldmethod=indent
"Don't fold newly opened files
set nofoldenable

"Relative line numbers on all other lines
set relativenumber
"Absolute line number on current line
set number
"Highlight current line
set cursorline

"Enable mouse
set mouse=a

"Allow edited/unsaved buffers to be hidden
set hidden

"Maintain undo history between sessions
set undofile
set undodir=~/.config/nvim/undodir

" Check for on-disk changes when gaining focus or switching buffers
au FocusGained,BufEnter * :checktime

" Remember cursor position between vim sessions
" see :h shada (the viminfo replacement for Neovim)
autocmd BufReadPost *
      \ if line("'\"") > 0 && line ("'\"") <= line("$") |
      \   exe "normal! g'\"" |
      \ endif

"
"
"
"
"
" Generic Keybindings
"
"
"
"
"

" jk or kj to escape to normal mode
imap jk <Esc>
imap kj <Esc>

"'U' to 'redo'
nnoremap U <C-r>

" Save all buffers
noremap <Leader>w :wa<CR>
" Quit the tab
noremap <silent> <Leader>q :quit<CR>

" Move by visual line, not logical line, when soft-wrapping
nnoremap j gj
nnoremap k gk

" Switch Ctrl I and Ctrl O for more natural 'forward' 'back' when jumping
nnoremap <C-I> <C-O>
nnoremap <C-O> <C-I>

" Y to copy from cursor to end of line, like D and C
nnoremap Y y$

" n and N center the matched line
nnoremap n nzz
nnoremap N Nzz

" Emacs-y navigation in command mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Del>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

" Leader d to delete a buffer.
" Close location window, nav to last buffer, then close the one we just left.
" This preserves the window split. Otherwise killing a buffer loses the split.
nnoremap <silent> <Leader>d :lclose<bar>b#<bar>bd #<CR>
" Leader D to reopen last deleted buffer
nnoremap <silent> <Leader>D :e #<CR>

" Leader t to swap windows
nnoremap <Leader>t <C-w><C-w>

" ' jumps to line, ` jumps to line and column, so always do the latter
vnoremap ' `
nnoremap ' `
onoremap ' `

" clever-f frees up ';', so just hit that to enter ex mode
nnoremap ; :
vnoremap ; :

" Modify '*' to not move cursor and support visual ranges
nnoremap <silent> * :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy:let @/=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>:set hls<CR>
" Clear all '*' highlights (doesn't affect quickhl)
nnoremap <silent> <Leader>* :nohls<CR>


"
"
"
"
"
" Plugin-Specific Settings
"
"
"
"
"

" FZF
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fb :Buffers<CR>
nnoremap <Leader>fh :History<CR>

" Easymotion
" Disable all default mappings
let g:EasyMotion_do_mapping = 0
nmap s <Plug>(easymotion-s2)
vmap s <Plug>(easymotion-s2)
" Case insensitive unless capital
let g:Easymotion_smartcase = 1

" vim-better-whitespace
" Strip all whitespace on save
autocmd BufWritePre * StripWhitespace

" vim-filebeagle
" disable netrw
let loaded_netrwPlugin = 1
" Disable builtin FileBeagle invocation mappings so we can define our own.
" Doesn't affect mappings within FileBeagle AFAIK.
let g:filebeagle_suppress_keymaps = 1
map <silent> <Leader>p  <Plug>FileBeagleOpenCurrentWorkingDir
map <silent> -          <Plug>FileBeagleOpenCurrentBufferDir


" clever-f
" Don't search across lines--more similar to original ';' behavior
let g:clever_f_across_no_line = 1
" 'F' always searches back and 'f' always searches forwards--also more
" similar to original behavior.
let g:clever_f_fix_key_direction = 1

" quickhl
" Add a highlight to the cword or visual range
nmap <Leader>h <Plug>(quickhl-manual-this)
xmap <Leader>h <Plug>(quickhl-manual-this)
" Clear all quickhl highlights
nmap <Leader>H <Plug>(quickhl-manual-reset)
xmap <Leader>H <Plug>(quickhl-manual-reset)


"
"
"
"
"
" Autocommands
"
"
"
"
"

" Ignore quickfix window when navigating buffers with :bnext and :bprev
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END
