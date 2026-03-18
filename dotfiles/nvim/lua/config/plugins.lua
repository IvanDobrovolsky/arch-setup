-- Catppuccin theme
local ok, catppuccin = pcall(require, "catppuccin")
if ok then
  catppuccin.setup({ transparent_background = true })
  vim.cmd.colorscheme("catppuccin")
end

-- Treesitter
-- Parsers: install via :TSInstall tsx typescript javascript html css bash python rust json yaml toml
vim.treesitter.start = vim.treesitter.start or function() end

-- Treesitter Textobjects
local tso_ok, tso = pcall(require, "nvim-treesitter-textobjects")
if tso_ok then
  tso.setup({ select = { lookahead = true }, move = { set_jumps = true } })
  local select_to = require("nvim-treesitter-textobjects.select").select_textobject
  local move = require("nvim-treesitter-textobjects.move")
  -- Select: around/inside function, class, argument, conditional, loop
  for _, m in ipairs({ "x", "o" }) do
    vim.keymap.set(m, "af", function() select_to("@function.outer") end, { desc = "Around function" })
    vim.keymap.set(m, "if", function() select_to("@function.inner") end, { desc = "Inside function" })
    vim.keymap.set(m, "ac", function() select_to("@class.outer") end, { desc = "Around class" })
    vim.keymap.set(m, "ic", function() select_to("@class.inner") end, { desc = "Inside class" })
    vim.keymap.set(m, "aa", function() select_to("@parameter.outer") end, { desc = "Around argument" })
    vim.keymap.set(m, "ia", function() select_to("@parameter.inner") end, { desc = "Inside argument" })
    vim.keymap.set(m, "ai", function() select_to("@conditional.outer") end, { desc = "Around conditional" })
    vim.keymap.set(m, "ii", function() select_to("@conditional.inner") end, { desc = "Inside conditional" })
    vim.keymap.set(m, "al", function() select_to("@loop.outer") end, { desc = "Around loop" })
    vim.keymap.set(m, "il", function() select_to("@loop.inner") end, { desc = "Inside loop" })
  end
  -- Move: jump between functions, classes, arguments
  vim.keymap.set("n", "]f", function() move.goto_next_start("@function.outer") end, { desc = "Next function" })
  vim.keymap.set("n", "]c", function() move.goto_next_start("@class.outer") end, { desc = "Next class" })
  vim.keymap.set("n", "]a", function() move.goto_next_start("@parameter.inner") end, { desc = "Next argument" })
  vim.keymap.set("n", "[f", function() move.goto_previous_start("@function.outer") end, { desc = "Prev function" })
  vim.keymap.set("n", "[c", function() move.goto_previous_start("@class.outer") end, { desc = "Prev class" })
  vim.keymap.set("n", "[a", function() move.goto_previous_start("@parameter.inner") end, { desc = "Prev argument" })
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
vim.lsp.config("eslint", {})
vim.lsp.enable(vim.list_extend(servers, { "lua_ls", "eslint" }))

-- ESLint: fix all on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(ev)
    local clients = vim.lsp.get_clients({ bufnr = ev.buf, name = "eslint" })
    if #clients > 0 then
      vim.cmd("silent! EslintFixAll")
    end
  end,
})

-- Autocompletion
local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
  local luasnip_ok, luasnip = pcall(require, "luasnip")
  cmp.setup({
    snippet = {
      expand = function(args)
        if luasnip_ok then luasnip.lsp_expand(args.body) end
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip_ok and luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip_ok and luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }, {
      { name = "buffer" },
      { name = "path" },
    }),
  })
end

-- Mason (LSP installer)
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
  mason.setup()
  local mlsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
  if mlsp_ok then
    mason_lsp.setup({
      ensure_installed = {
        "ts_ls", "html", "cssls", "bashls",
        "lua_ls", "pyright", "rust_analyzer", "jsonls", "eslint",
      },
    })
  end
end
