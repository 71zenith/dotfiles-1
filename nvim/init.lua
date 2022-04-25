-- Plugins {{{
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'terrortylor/nvim-comment'
  use 'windwp/nvim-autopairs'
  use 'marko-cerovac/material.nvim'
  use "lukas-reineke/indent-blankline.nvim"
  use "akinsho/toggleterm.nvim"
  use 'lewis6991/impatient.nvim'
  use 'akinsho/bufferline.nvim'
  use 'andweeb/presence.nvim'
  use 'mhinz/vim-startify'
  use 'nvim-treesitter/nvim-treesitter'
  use 'kyazdani42/nvim-web-devicons'
  use 'kyazdani42/nvim-tree.lua'
  use 'nvim-lualine/lualine.nvim'
  config = {
    compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
  }
  if packer_bootstrap then
    require('packer').sync()
  end
end)
-- }}}

-- Starting some plugins {{{
require("packer.compile")

require('bufferline').setup {
  options = {
    numbers = "ordinal",
    offsets = {{filetype = "NvimTree", text = "NvimTree" , text_align = "left" }},
  }
}

require("presence"):setup({
    auto_update         = true,
    neovim_image_text   = "Neovim > Emacs",
    main_image          = "file",
    debounce_timeout    = 20, 
    enable_line_number  = true,
    buttons = {
      {
        label = "I Like Neovim" ,
        url = "https://github.com/71zenith" 
      }
    }
})

require("toggleterm").setup({
  open_mapping = [[<c-o>]],
  direction = 'float',
  shell = "zsh",
})

vim.g.nvim_tree_width = 25
require'nvim-tree'.setup {auto_open = 1, gitignore = 1}

require("indent_blankline").setup {
    show_current_context = true,
    show_current_context_start = true,
    filetype_exclude = { "startify" , "NvimTree", "packer" , "toggleterm" }
}

require('nvim_comment').setup({comment_empty = false})

require'nvim-autopairs'.setup{check_ts = true}

require('lualine').setup{
    extensions = {'nvim-tree','toggleterm'},
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua" , "vim" , "bash" , "go" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}
-- }}}

-- Setting some keybindings {{{
local keymap = vim.api.nvim_set_keymap

keymap('n', '<c-f>', ':NvimTreeFindFileToggle<cr>' , {silent = true})
keymap('n', '<C-h>', '<C-w>h', {noremap = true, silent = true})
keymap('n', '<C-l>', '<C-w>l', {noremap = true, silent = true})
keymap('n', '<C-n>', '<C-w>n', {noremap = true, silent = true})
keymap('n', '<C-j>', '<C-w>j', {noremap = true, silent = true})
keymap('n', '<C-k>', '<C-w>k', {noremap = true, silent = true})
keymap('n', '<C-w>q' , ':bdelete!<CR>' , {silent = true})
keymap("n", "<C-Up>", ":resize -2<CR>", {silent = true})
keymap("n", "<C-Down>", ":resize +2<CR>", {silent = true})
keymap("n", "<C-Left>", ":vertical resize -2<CR>", {silent = true})
keymap("n", "<C-Right>", ":vertical resize +2<CR>", {silent = true})
keymap("n", "<S-h>", ":BufferLineCyclePrev<cr>", {silent = true})
keymap("n", "<S-l>", ":BufferLineCycleNext<cr>", {silent = true})
-- }}}

-- Some basic settings {{{
vim.cmd[[autocmd FileType startify f Startify]]
vim.cmd('filetype plugin indent on')
vim.o.swapfile = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.backup = false
vim.o.cursorline = true
vim.o.autochdir = true
vim.o.ignorecase = true
vim.o.smarttab = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.splitbelow = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.clipboard = "unnamedplus"
vim.o.mouse = 'a'
vim.o.cmdheight = 2
vim.o.showmode = false
vim.o.shell = '/bin/dash'
vim.o.scrolloff = 999
vim.g["mapleader"] = ","
vim.g.material_style = "darker"
vim.o.autoread = true
-- }}}

-- Colorscheme config {{{
require('material').setup({
	italics = {comments = true},
	disable = {
		borders = true,
		background = true,
	},
	lualine_style = "stealth"
})
vim.cmd('colorscheme material')
-- }}}

-- Startify config {{{
vim.api.nvim_command([[
highlight StartifyHeader  ctermfg=114
let g:startify_bookmarks = [ { 'v' : '~/.config/nvim/init.lua'} ]
let g:startify_lists = [{ 'header': ['     Recent'],'type': 'files' },{ 'header': ['     Bookmarks'],'type': 'bookmarks' },]
let g:startify_custom_header ='startify#center(startify#fortune#cowsay())'
hi StartifyPath ctermbg=None ctermfg=Blue
nnoremap <silent> <C-e> :Startify<cr>
let g:startify_update_oldfiles = 1
let g:startify_fortune_use_unicode = 1
let g:startify_files_number = 12
let g:startify_padding_left = 5
autocmd TabNewEntered * Startify
]])
-- }}}

-- Autocommands{{{
vim.api.nvim_command([[
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
]])
vim.cmd[[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]]
-- }}}

-- vim:foldmethod=marker
