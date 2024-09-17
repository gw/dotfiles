-- Basic setup
vim.opt.termguicolors = true  -- Enable true color support
vim.opt.lazyredraw = true     -- Don't redraw screen during macros (for performance)
vim.opt.scrolloff = 10        -- Keep 10 lines visible above/below cursor
vim.opt.wrap = false          -- Disable line wrapping
vim.opt.tabstop = 4           -- Set tab width to 4 spaces
vim.opt.ignorecase = true     -- Ignore case in search patterns
vim.opt.smartcase = true      -- Override ignorecase if search pattern contains uppercase
vim.opt.foldenable = false    -- Disable folding by default
vim.opt.cursorline = true     -- Highlight the current line
vim.opt.mouse = 'a'           -- Enable mouse support in all modes
vim.opt.hidden = true         -- Allow switching buffers without saving
vim.opt.undofile = true       -- Enable persistent undo
vim.opt.undodir = vim.fn.expand('~/.config/nvim/undodir')  -- Set undo directory
vim.opt.splitbelow = true     -- Open new splits below
vim.opt.splitright = true     -- Open new splits to the right

-- Plugins (using packer.nvim)
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()  -- Ensure packer is installed

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'  -- Packer can manage itself

  -- Colors and UI
  use 'projekt0n/github-nvim-theme'  -- GitHub color scheme
  use {
    'nvim-lualine/lualine.nvim',     -- Status line
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }  -- Icons for lualine
  }

  -- Editing helpers
  use 'tpope/vim-sleuth'                 -- Detect indent settings
  use 'ntpeters/vim-better-whitespace'   -- Highlight and remove trailing whitespace
  use 'numToStr/Comment.nvim'            -- Easy commenting

  if packer_bootstrap then
    require('packer').sync()  -- Sync plugins if packer was just installed
  end
end)

-- Color scheme
vim.cmd('colorscheme github_light')  -- Set the color scheme

-- Keybindings
vim.g.mapleader = ' '  -- Set leader key to space

-- Normal mode
vim.keymap.set('n', 'U', '<C-r>')   -- Map 'U' to redo
vim.keymap.set('n', '<Leader>w', ':wa<CR>')  -- Save all buffers
vim.keymap.set('n', '<Leader>q', ':quit<CR>')  -- Quit
vim.keymap.set('n', 'j', 'gj')  -- Move down by visual line
vim.keymap.set('n', 'k', 'gk')  -- Move up by visual line
vim.keymap.set('n', 'Y', 'y$')  -- Yank to end of line
vim.keymap.set('n', 'n', 'nzz')  -- Center view after next search result
vim.keymap.set('n', 'N', 'Nzz')  -- Center view after previous search result
vim.keymap.set('n', 'H', '0', { noremap = true, silent = true })  -- Move to beginning of line
vim.keymap.set('n', 'L', '$', { noremap = true, silent = true })  -- Move to end of line
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true })
-- Swap Ctrl+I and Ctrl+O for jump list navigation
vim.keymap.set('n', '<C-I>', '<C-O>', { noremap = true })
vim.keymap.set('n', '<C-O>', '<C-I>', { noremap = true })

-- Command mode navigation
vim.keymap.set('c', '<C-a>', '<Home>')  -- Move to beginning of line
vim.keymap.set('c', '<C-e>', '<End>')   -- Move to end of line
vim.keymap.set('c', '<C-b>', '<Left>')  -- Move left
vim.keymap.set('c', '<C-f>', '<Right>') -- Move right
vim.keymap.set('c', '<C-d>', '<Del>')   -- Delete character under cursor
vim.keymap.set('c', '<M-b>', '<S-Left>')  -- Move word left
vim.keymap.set('c', '<M-f>', '<S-Right>') -- Move word right

-- Insert mode navigation
vim.keymap.set('i', 'jk', '<Esc>')  -- Map 'jk' to escape in insert mode
vim.keymap.set('i', 'kj', '<Esc>')  -- Map 'kj' to escape in insert mode
vim.keymap.set('i', '<C-a>', '<Home>')  -- Move to beginning of line
vim.keymap.set('i', '<C-e>', '<End>')   -- Move to end of line
vim.keymap.set('i', '<C-p>', '<Up>')    -- Move up
vim.keymap.set('i', '<C-n>', '<Down>')  -- Move down
vim.keymap.set('i', '<C-b>', '<Left>')  -- Move left
vim.keymap.set('i', '<C-f>', '<Right>') -- Move right
vim.keymap.set('i', '<C-d>', '<Del>')   -- Delete character under cursor
vim.keymap.set('i', '<C-g>', '<Esc>')   -- Exit insert mode
vim.keymap.set('i', '<M-b>', '<S-Left>')  -- Move word left
vim.keymap.set('i', '<M-f>', '<S-Right>') -- Move word right
vim.keymap.set('i', '<C-k>', '<C-o>D', {noremap = true, silent = true}) -- Kill forward line (Ctrl+K)
vim.keymap.set('i', '<M-BS>', '<C-w>', {noremap = true, silent = true}) -- Delete backwards word (Ctrl+W)

-- Visual mode
vim.keymap.set('v', 'H', '0', { noremap = true, silent = true })  -- Move to beginning of line
vim.keymap.set('v', 'L', '$', { noremap = true, silent = true })  -- Move to end of line

-- Window navigation
vim.keymap.set('n', '<C-j>', '<C-w><C-j>')  -- Move to window below
vim.keymap.set('n', '<C-k>', '<C-w><C-k>')  -- Move to window above
vim.keymap.set('n', '<C-l>', '<C-w><C-l>')  -- Move to window right
vim.keymap.set('n', '<C-h>', '<C-w><C-h>')  -- Move to window left

-- Misc mappings
vim.keymap.set({'v', 'n', 'o'}, "'", '`')  -- Use ' for ` (go to mark)
vim.keymap.set({'n', 'v'}, ';', ':')       -- Use ; for : (command mode)

-- Lualine configuration
require('lualine').setup {
  options = {
    icons_enabled = true,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_c = {
      {
        'filename',
        path = 1,  -- Show relative path
      }
    }
  }
}

-- Comment.nvim setup
require('Comment').setup()  -- Initialize with default settings

-- vim-better-whitespace
vim.cmd([[
  autocmd BufWritePre * StripWhitespace  -- Remove trailing whitespace on save
]])

-- Autocommands
vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  command = "wincmd =",  -- Automatically resize splits when terminal is resized
})
