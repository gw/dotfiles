" Prerequisites (in leu of a an install script)
" The Silver Searcher (ctrlp, vimgrep, ackprg)
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
Plug 'lifepillar/vim-solarized8'

"File/Project Search/Switching
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mileszs/ack.vim'
Plug 'jeetsukumaran/vim-filebeagle'
Plug 'ap/vim-buftabline'

"Autocompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-clang'
Plug 'jiangmiao/auto-pairs'

"Linting
Plug 'neomake/neomake'

"Text navigation
Plug 'easymotion/vim-easymotion'
Plug 'rhysd/clever-f.vim'
Plug 't9md/vim-quickhl'
Plug 'vim-scripts/argtextobj.vim' "Adds the `ia` and `aa` text objects for func args

"File settings, indentation
Plug 'tpope/vim-sleuth'
Plug 'ntpeters/vim-better-whitespace'

"Git
Plug 'airblade/vim-gitgutter'

"Tags
Plug 'majutsushi/tagbar'

call plug#end()

colorscheme solarized8_light_high

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

"Use Silver Searcher for all grepping
set grepprg=ag\ --nogroup\ --nocolor  "Vim's builtin grep search program
let g:ackprg = "ag --vimgrep"  "Ack.vim's search program

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
set undodir=~/.nvim/undodir

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

"'U' to 'redo'
nnoremap U <C-r>

" Save all buffers
noremap <Leader>w :wa<CR>
" Quit the tab
noremap <Leader>q :quit<CR>

" Switch Ctrl I and Ctrl O for more natural 'forward' 'back' when jumping
nnoremap <C-I> <C-O>
nnoremap <C-O> <C-I>

" Mash wf or fw to go from insert -> normal mode
inoremap wf <Esc>
inoremap fw <Esc>

" Y to copy from cursos to end of line, like D and C
nnoremap Y y$

" n and N center the matched line
nnoremap n nzz
nnoremap N Nzz

" Ctrl-u and Ctrl-y to navigate buffers
nnoremap <silent> <C-h> :bprev<CR>
nnoremap <silent> <C-l> :bnext<CR>
" Leader d to delete a buffer. Navs to prev buffer and kills the one we just
" left. This preserves the window split. Otherwise killing a buffer loses the
" split.
nnoremap <Leader>d :bprev\|bdelete #<CR>
" Leader D to reopen last deleted buffer
nnoremap <Leader>D :e #<CR>

" Leader t to swap windows
nnoremap <Leader>t <C-w><C-w>

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

"Ack.vim ('!' keeps Ack from popping up the first result)
nnoremap <Leader>a :Ack!<Space>
"Highlight search results
let g:ackhighlight = 1
"Autofold search results
let g:ack_autofold_results = 1
"Leader A to open Ack but with previous query pre-loaded
" nnoremap <Leader>A :AckFromSearch!<CR>

" YCM
"Don't highlight errors for now, doesn't work with solarized8
"let g:ycm_enable_diagnostic_highlighting = 0
"Gutter icon for lint errors
"let g:ycm_warning_symbol = '>'
"let g:ycm_error_symbol = '>'
"Make GoTo* commands open in same buffer
"let g:ycm_goto_buffer_command = 'same-buffer'
"nnoremap <Leader>sd :YcmCompleter GoTo<CR>

" Gitgutter
" Don't set up any keymappings, it sets <Leader>h which I want to save for
" quickhl
let g:gitgutter_map_keys = 0
" Don't update signs while typing (for speed)
let g:gitgutter_realtime = 0

" Neomake
" Open locations window automatically on lint errors, but without moving the
" cursor
"let g:neomake_open_list = 2
let g:neomake_list_height = 5
"let g:neomake_echo_current_error = 1

" Easymotion
" Disable all default mappings
let g:EasyMotion_do_mapping = 0
" Case insensitive unless capital
let g:Easymotion_smartcase = 1
nmap s <Plug>(easymotion-s2)
vmap s <Plug>(easymotion-s2)

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/libclang.dylib'
let g:deoplete#sources#clang#clang_header = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang'
" When deoplete window is open and you press enter, actually insert newline
" instead of just closing the deoplete window, which is the default.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
    return deoplete#close_popup() . "\<CR>"
endfunction
"Hide annoying preview window
set completeopt-=preview

" CtrlP
" Execute 'CtrlP' with ctrl+p
let g:ctrlp_map = '<Leader>f'
"Put CtrlP window at bottom of screen, best matches at top (top-to-bottom)
let g:ctrlp_match_window = 'bottom,order:ttb'
"Respect any changes we make to the workdir during a session
let g:ctrlp_working_path_mode = 0
"Use Silver Searcher under the hood, showing hidden files but still respecting
"the global ag ignore list at ~/.agignore
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
"ag is hella fast so don't cache the index--always be up to date
let g:ctrlp_use_caching = 0
"Add customize which modes are available for navigation by c-f and c-b
let g:ctrlp_extensions = ['tag']

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

" Tagbar
nnoremap <silent> <F3> :TagbarToggle<CR>
"Jump to tagbar window when opening it
let g:tagbar_autofocus = 1
"Don't alpha-sort the tags--show them as they appear in the file
let g:tagbar_sort = 0
"Omit help text and blank lines b/w scopes
let g:tagbar_compact = 1
"Show relative line numbers in tagbar window for easier motion
let g:tagbar_show_linenumbers = -1
"Single- instead of double-click jump to tag
let g:tagbar_singleclick = 1
"Close and Open scope folds with h and l, a la filebeagle
let g:tagbar_map_openfold = "l"
let g:tagbar_map_closefold = "h"


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

" Neomake
" Lint when entering or saving buffer
autocmd! BufWritePost,BufEnter * Neomake

" Ignore quickfix window when navigating buffers with :bnext and :bprev
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END
