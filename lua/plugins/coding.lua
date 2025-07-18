local completion = vim.g.completion_mode or "blink" -- or 'native'

local function deduplicate(list)
  local seen = {}
  local result = {}
  for _, item in ipairs(list) do
    if not seen[item] then
      seen[item] = true
      table.insert(result, item)
    end
  end
  return result
end


return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts_extend = { "ensure_installed" },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = deduplicate(opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = false,
          node_decremental = "<BS>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<M-]>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<M-[>a"] = "@parameter.inner",
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local tsc = require("treesitter-context")
      Snacks.toggle({
        name = "Treesitter Context",
        get = tsc.enabled,
        set = function(state)
          if state then
            tsc.enable()
          else
            tsc.disable()
          end
        end,
      }):map("<leader>ut")
      return { mode = "cursor", max_lines = 3 }
    end,
  },
  -- Setup Copilot
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   opts = {
  --     suggestion = {
  --       enabled = true,
  --       auto_trigger = true,
  --     },
  --   },
  -- },
  -- Autocomplete, refer to https://cmp.saghen.dev/#compared-to-built-in-completion for more information
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    enable = completion == "blink",
    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',
    dependencies = {
      -- optional: provides snippets for the snippet source
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load { paths = { vim.fn.stdpath "config" .. "/snippets" } }
          end,
        },
      },
    },
    ---@module 'blink.cmp'
    -- Refer https://cmp.saghen.dev/installation.html
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<M-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },

        ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },
      completion = {
        accept = { auto_brackets = { enabled = false } },
        -- Controls whether the documentation window will automatically show when selecting a completion item
        documentation = {
          auto_show = true,
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
      },
      -- Experimental signature help support
      signature = {
        enabled = false,
      },
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        nerd_font_variant = "mono",
      },
      snippets = { preset = "luasnip" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      -- Disable cmdline completions
      cmdline = {
        enabled = false,
      },
      -- Disable per file type
      enabled = function()
        return not vim.tbl_contains({ "copilot-chat" }, vim.bo.filetype)
          and not vim.tbl_contains({ "codecompanion" }, vim.bo.filetype)
          and vim.bo.buftype ~= "prompt"
          and vim.b.completion ~= false
      end,
    },
    -- without having to redefine it
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat", -- Support nvim-cmp source
      "sources.default",
    },
  },
  -- Lazydev
  {
    "folke/lazydev.nvim",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
    optional = true,
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show at a higher priority than lsp
          },
        },
      },
    },
  },
  -- Markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    opts = {},
    optional = true,
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "markdown" },
        providers = {
          markdown = {
            name = "RenderMarkdown",
            module = "render-markdown.integ.blink",
            fallbacks = { "lsp" },
          },
        },
      },
    },
  },
  -- Support copilot as source
  -- {
  --   "saghen/blink.cmp",
  --   dependencies = { "fang2hou/blink-copilot" },
  --   opts = {
  --     sources = {
  --       default = { "copilot" },
  --       providers = {
  --         copilot = {
  --           name = "copilot",
  --           module = "blink-copilot",
  --           score_offset = 100,
  --           async = true,
  --         },
  --       },
  --     },
  --   },
  -- },
  -- Refactoring
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>d", group = "debug" },
        { "<leader>r", group = "refactoring", icon = "" },
      },
    },
  },
  -- The Refactoring library based off the Refactoring book by Martin Fowler
  {
    "ThePrimeagen/refactoring.nvim",
    vscode = true,
    dependencies = {
      { "nvim-lua/plenary.nvim", vscode = true },
      { "nvim-treesitter/nvim-treesitter" },
    },
    keys = {
      {
        "<leader>rm",
        function()
          require("refactoring").select_refactor {
            show_success_message = true,
          }
        end,
        mode = { "n", "v" },
        desc = "Refactoring Menu",
      },
      {
        "<leader>re",
        function()
          require("refactoring").refactor "Extract Function"
        end,
        desc = "Extract",
        mode = "x",
      },
      {
        "<leader>rf",
        function()
          require("refactoring").refactor "Extract Function To File"
        end,
        desc = "Extract to file",
        mode = "x",
      },
      {
        "<leader>rv",
        function()
          require("refactoring").refactor "Extract Variable"
        end,
        desc = "Extract variable",
        mode = "x",
      },
      {
        "<leader>ri",
        function()
          require("refactoring").refactor "Inline Variable"
        end,
        desc = "Inline variable",
        mode = { "n", "x" },
      },
      {
        "<leader>rI",
        function()
          require("refactoring").refactor "Inline Function"
        end,
        desc = "Inline function",
        mode = { "n" },
      },
      {
        "<leader>rb",
        function()
          require("refactoring").refactor "Extract Block"
        end,
        desc = "Extract block",
      },
      {
        "<leader>rB",
        function()
          require("refactoring").refactor "Extract Block To File"
        end,
        desc = "Extract block to file",
      },
      -- Debug variable
      {
        "<leader>dv",
        function()
          require("refactoring").debug.print_var {
            show_success_message = true,
            below = true,
          }
        end,
        mode = { "n", "x" },
        desc = "Print below variables",
      },
      {
        "<leader>dV",
        function()
          require("refactoring").debug.print_var {
            show_success_message = true,
            below = false,
          }
        end,
        mode = { "n", "x" },
        desc = "Print above variables",
      },
      -- Clean up debugging
      {
        "<leader>dc",
        function()
          require("refactoring").debug.cleanup {
            force = true,
            show_success_message = true,
          }
        end,
        desc = "Clear debugging",
      },
    },
    opts = {
      prompt_func_return_type = {
        go = false,
        java = false,

        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,

        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {},
      print_var_statements = {},
    },
  },
  -- Code comment
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
  -- Learn those tips from LazyVim
  -- Auto pairs
  -- {
  --   "echasnovski/mini.pairs",
  --   event = "VeryLazy",
  --   opts = {},
  -- },
  -- Extend and create a/i textobjects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter { -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          },
          f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" }, -- function
          c = ai.gen_spec.treesitter { a = "@class.outer", i = "@class.inner" }, -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call { name_pattern = "[%w_]" }, -- without dot in function name
        },
      }
    end,
  },
  -- A better annotation generator. Supports multiple languages and annotation conventions.
  -- <C-n> to jump to next annotation, <C-p> to jump to previous annotation
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = { enabled = true },
    cmd = "Neogen",
    vscode = true,
    keys = {
      { "<leader>ci", "<cmd>Neogen<cr>", desc = "Neogen: Annotation generator" },
    },
  },
}
