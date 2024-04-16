-- general
lvim.log.level = "warn"
lvim.format_on_save.enabled = false
lvim.colorscheme = "lunar"
-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
vim.opt.number = true
vim.opt.relativenumber = true
-- Avoid sticky selection when searching using /
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.signcolumn = "yes"
-- vim.opt.colorcolumn = "80"
-- Keep cursor always 8 lines above/below the top/bottom when scrolling
vim.opt.scrolloff = 8
-- Filetype .es6 opens as .js javascript file
vim.filetype.add({ extension = { es6 = "javascript" } })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- add your own keymapping
-- Ctrl-S on insert mode changes to visual mode and saves
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.insert_mode["<C-s>"] = "<esc>:w<cr>"

-- User Config for predefined plugins
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.project.active = false
lvim.builtin.autopairs.active = true
-- https://github.com/windwp/nvim-autopairs?tab=readme-ov-file#plugin-integration
-- lvim.builtin.autopairs.on_config_done = function()
--   require('nvim-autopairs').setup({
--   ignored_next_char = "[%w%.]" -- will ignore alphanumeric and `.` symbol
-- })
-- end

lvim.builtin.treesitter.highlight.enable = true
-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "scss",
  "css",
  "rust",
  "java",
  "yaml",
  "ruby",
  "vue"
}
-- lvim.builtin.treesitter.ignore_install = { "haskell" }

lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.nvimtree.setup.update_cwd = false
lvim.builtin.nvimtree.setup.update_focused_file.update_cwd = false
lvim.builtin.nvimtree.setup.update_focused_file.enable = true
lvim.builtin.nvimtree.setup.update_focused_file.update_root = false
lvim.builtin.nvimtree.setup.view.side = "right"
lvim.builtin.nvimtree.setup.view.width = 40

lvim.builtin.telescope = {
  active = true,
  defaults = {
    layout_strategy = "horizontal",
    theme = "dropdown",
    dynamic_preview_title = true,
    previewer = true,
    path_display = {
      truncate = true,
      shorten = {
        len = 4, exclude = { -1 },
      },
    },
  },
  pickers = nil,
}

-- lvim.builtin.which_key.mappings['P'] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings['sw'] = { "<cmd>Telescope grep_string<CR>", "Word Under Cursor" }
lvim.builtin.which_key.mappings['br'] = { "<cmd>bufdo e<CR>", "Reload All Buffers" }
lvim.builtin.which_key.mappings['gt'] = { "<cmd>Gitsigns toggle_current_line_blame<CR>", "Toogle Current Line Blame" }
lvim.builtin.which_key.mappings['bo'] = { "<cmd>%bd<CR><C-O>:bd#<CR>", "Close All Others" }
lvim.builtin.which_key.mappings['ba'] = { "<cmd>%bd<CR>", "Close All" }
-- lvim.builtin.which_key.mappings['ba'] = { "<cmd>%bw<CR>", "Close All" }
lvim.builtin.which_key.mappings['bx'] = { "<cmd>!chmod +x %<CR>", "Make Executable" }
-- Redefine to show preview when pressing <leader>f
-- Example using builtin telescope https://github.com/pytholic/pytholic-lvim/blob/main/lua/user/telescope.lua
-- local builtin = require("telescope.builtin")
lvim.builtin.which_key.mappings["f"] = {
  function()
    -- builtin.find_files()
    require("lvim.core.telescope.custom-finders").find_project_files { previewer = true }
  end,
  "Find File...",
}


lvim.builtin.which_key.mappings["t"] = {
  function()
    require("telescope.builtin").find_files {
      shorten_path = false,
      cwd = "~/.config",
      prompt_title = "Dotfiles",
      height = 10,
      layout_strategy = 'horizontal',
      layout_options = {
        preview_width = 0.75,
      },
    }
  end,
  "Dotfiles...",
}

lvim.plugins = {
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "css", "scss", "html", "javascript", "vue", "typescript" }, {
        RGB = true,      -- #RGB hex codes
        RRGGBB = true,   -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true,   -- CSS rgb() and rgba() functions
        hsl_fn = true,   -- CSS hsl() and hsla() functions
        css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },
  {
    "mbbill/undotree",
    config = function()
      lvim.builtin.which_key.mappings['u'] = { "<cmd>UndotreeToggle<CR>", "Undo Tree" }
    end
  }
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    name = "prettier",
    selected = true, -- Enable formatting only on the selected range
    -- filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "css", "json", "markdown", "scss", "yaml", "html" },
  },
}
-- lvim.format_on_save.enabled = true
-- lvim.format_on_save.timeout = 5000
-- Define a keybinding for formatting only the selected range
-- lvim.builtin.which_key.mappings["j"] = "<cmd>lua require('lvim.lsp.buf.formatting').format()<CR>"
-- Define a keybinding for formatting only the selected range
-- lvim.keys.normal_mode["<leader>j"] = "<cmd>require('lvim.lsp.buf.formatting').format()<CR>"
--

-- This is because Vue integration brakes in Volar 2.0.7
-- https://github.com/vuejs/language-tools/issues/4159
require("lvim.lsp.manager").setup("volar", {
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  init_options = {
    vue = {
      hybridMode = false,
    },
  },
})

