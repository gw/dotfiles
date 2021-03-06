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
Plug 'cormacrelf/vim-colors-github'
Plug 'tomasr/molokai'

" UI
Plug 'itchyny/lightline.vim'

"File/Project Search/Switching
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'zackhsi/fzf-tags'
Plug 'wincent/ferret'
Plug 'jeetsukumaran/vim-filebeagle'

" Autocomplete
" Plug 'lifepillar/vim-mucomplete'
Plug 'ajh17/VimCompletesMe'

" Linting
Plug 'w0rp/ale'
Plug 'maximbaz/lightline-ale'

"Text navigation
Plug 'easymotion/vim-easymotion'
Plug 'rhysd/clever-f.vim'
Plug 't9md/vim-quickhl'

"File settings, indentation
Plug 'tpope/vim-sleuth'
Plug 'ntpeters/vim-better-whitespace'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'

" Editing
Plug 'tmsvg/pear-tree'
Plug 'tpope/vim-commentary'

" Windows / Buffers
Plug 'moll/vim-bbye'

call plug#end()

set termguicolors
colorscheme github

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
" set relativenumber
"Absolute line number on current line
" set nonumber
" Allows line and col number to be shown when you press C-g
set noruler
"Highlight current line
set cursorline

"Enable mouse
set mouse=a

"Allow edited/unsaved buffers to be hidden
set hidden

"Maintain undo history between sessions
set undofile
set undodir=~/.config/nvim/undodir


" Reduce updatetime so gitgutter updates faster
set updatetime=500

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
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Del>
" This doesn't work in command mode, for some reason
" cnoremap <C-g> <Esc>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

" Mirror above in insert mode
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-d> <Del>
inoremap <C-g> <Esc>
inoremap <M-b> <S-Left>
inoremap <M-f> <S-Right>

" Leader d to delete a buffer. Leader D to bring it back.
" Close location window, nav to last buffer, then close the one we just left.
" This preserves the window split. Otherwise killing a buffer loses the split.
nnoremap <silent> <Leader>d :Bdelete<CR>
" Leader D to reopen the last buffer (deleted or not)
nnoremap <silent> <Leader>D :e #<CR>

" C-{hjkl} to move splits
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

" Open new splits to the right and down
set splitbelow
set splitright

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
nnoremap <silent> <Leader>c :nohls<CR>
" Double-click a word to highlight it
nnoremap <silent> <2-LeftMouse> :let @/='\V\<'.escape(expand('<cword>'), '\').'\>'<cr>:set hls<cr>


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

" Ale
" Only lint on save
let g:ale_lint_on_text_changed = 'never'
" Run all javascript linters on .jsx files too
let g:ale_linter_aliases = {'jsx': ['javascript']}
let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\}
let g:ale_fix_on_save = 1
" Configure signs
let g:ale_echo_msg_format = '[%linter%] %s'

" pay-server config
function! SetupConfigForPayServer()
" let g:vroom_test_unit_command = 'pay test'
" let g:vroom_use_bundle_exec = 0
  let g:ale_ruby_rubocop_executable = '/Users/gwu/stripe/pay-server/scripts/bin/rubocop'
endfunction

autocmd BufRead,BufNewFile */stripe/pay-server/* call SetupConfigForPayServer()

" Ferret
" Don't set any normal mode mappings
let g:FerretMap=0
nmap <Leader>fs <Plug>(FerretAck)
" Grep for word under cursor
nmap <Leader>fw <Plug>(FerretAckWord)
" Always open quickfix menus (i.e., Ferret search results) in vertical splits
" Just does whatever <C-w>L does
autocmd FileType qf wincmd L

" FZF
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fb :Buffers<CR>
nnoremap <Leader>fh :History<CR>

" FZF-tags
nmap <C-]> <Plug>(fzf_tags)

" Fugitive / Rhubarb
let g:github_enterprise_urls = ['https://git.corp.stripe.com']

" Gitgutter
" Don't set up any default mappings
let g:gitgutter_map_keys = 0
" Jump b/w hunks
" nmap <Leader>hn <Plug>GitGutterNextHunk
" nmap <Leader>hp <Plug>GitGutterPrevHunk
" Stage / unstage hunks
" nmap <Leader>ha <Plug>GitGutterStageHunk
" nmap <Leader>hr <Plug>GitGutterUndoHunk
" Preview hunks (for seeing what it looked like before)
" nmap <Leader>hp <Plug>GitGutterPreviewHunk

" Gutentags
" Enable GutentagsToggleEnabled and GutentagsToggleTrace
let g:gutentags_define_advanced_commands = 1
" Enable tracing on startup
" let g:gutentags_trace = 1
let g:gutentags_file_list_command = 'fd --type f'
" Only generate the tags file when writing a new file.
" This makes vim way faster to exit when writing git commits,
" presuambly b/c it isn't trying to kill ctags or something.
let g:gutentags_generate_on_missing = 0
let g:gutentags_generate_on_new = 0

" Lightline
" Don't show --INSERT-- in the command area, since lightline shows the mode
set noshowmode
" Show full filepath instead of just filename--have plenty of room down there
let g:lightline = {
      \ 'component_function': {
      \   'filename': 'FilenameForLightline'
      \ }
      \ }

" Show full path of filename
function! FilenameForLightline()
    return expand('%')
endfunction

" Show ALE warnings/errors
let g:lightline.component_expand = {
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }
let g:lightline.active = { 'right': [['linter_errors', 'linter_warnings', 'linter_ok' ]] }

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
nmap <Leader>h <Plug>(quickhl-manual-this-whole-word)
xmap <Leader>h <Plug>(quickhl-manual-this-whole-word)
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

" Maintain split proportions when Vim is resized
autocmd VimResized * :wincmd =

" Ignore quickfix window when navigating buffers with :bnext and :bprev
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END
