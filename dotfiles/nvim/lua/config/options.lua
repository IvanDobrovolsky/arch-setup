local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = false

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.cursorline = true

-- Behavior
opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("state") .. "/undo"
opt.undofile = true
opt.updatetime = 50
opt.clipboard = "unnamedplus"
opt.splitright = true
opt.splitbelow = true

-- Auto-save
opt.autowriteall = true
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost", "BufLeave" }, {
  callback = function(ev)
    local buf = ev.buf
    if vim.bo[buf].modified and vim.bo[buf].buftype == "" and vim.fn.bufname(buf) ~= "" then
      vim.api.nvim_buf_call(buf, function() vim.cmd("silent! write") end)
    end
  end,
})

-- Diagnostics
vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN]  = "▲",
      [vim.diagnostic.severity.HINT]  = "⚑",
      [vim.diagnostic.severity.INFO]  = "»",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "
