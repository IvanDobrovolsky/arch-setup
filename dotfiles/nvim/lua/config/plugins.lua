-- Catppuccin theme
local ok, catppuccin = pcall(require, "catppuccin")
if ok then
  catppuccin.setup({ transparent_background = true })
  vim.cmd.colorscheme("catppuccin")
end

-- Treesitter
local ts_ok, ts = pcall(require, "nvim-treesitter.configs")
if ts_ok then
  ts.setup({
    ensure_installed = {
      "typescript", "tsx", "javascript",
      "html", "css",
      "bash",
      "lua",
      "python",
      "rust",
      "json", "yaml", "toml",
      "markdown",
    },
    highlight = { enable = true },
    indent = { enable = true },
  })
end

-- Telescope
local tel_ok, telescope = pcall(require, "telescope")
if tel_ok then
  telescope.setup({
    defaults = {
      file_ignore_patterns = { "node_modules", ".git/" },
    },
  })
  pcall(telescope.load_extension, "fzf")

  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
  vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
  vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
  vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Grep word under cursor" })
end

-- Nvim Tree
local tree_ok, nvimtree = pcall(require, "nvim-tree")
if tree_ok then
  nvimtree.setup({
    view = { width = 30 },
    filters = { dotfiles = false },
    git = { enable = true, ignore = false },
    renderer = {
      highlight_git = "name",
      icons = {
        git_placement = "after",
        show = { git = true },
      },
    },
  })
  vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "File explorer" })
  vim.api.nvim_set_hl(0, "NvimTreeGitIgnoredHL", { fg = "#6c7086", italic = true })
end

-- Undotree
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undo tree" })

-- Gitsigns
local gs_ok, gitsigns = pcall(require, "gitsigns")
if gs_ok then
  gitsigns.setup()
end

-- Lualine
local ll_ok, lualine = pcall(require, "lualine")
if ll_ok then
  lualine.setup({
    options = {
      theme = "auto",
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
  })
end

-- LSP (vim.lsp.config for nvim 0.11+)
local servers = { "ts_ls", "html", "cssls", "bashls", "pyright", "rust_analyzer", "jsonls" }
for _, server in ipairs(servers) do
  vim.lsp.config(server, {})
end
vim.lsp.config("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})
vim.lsp.enable(vim.list_extend(servers, { "lua_ls" }))

-- Mason (LSP installer)
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
  mason.setup()
  local mlsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
  if mlsp_ok then
    mason_lsp.setup({
      ensure_installed = {
        "ts_ls", "html", "cssls", "bashls",
        "lua_ls", "pyright", "rust_analyzer", "jsonls",
      },
    })
  end
end
