local vim = vim

-- Package manager
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath
    }
end
vim.opt.rtp:prepend(lazypath)

require("config.options")

-- Plugins
require("lazy").setup(
    {
        -- Color scheme
        require("plugins.debug"),
        require("plugins.autoformat"),
        require("plugins.neotree"),
        {
            "folke/trouble.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            opts = {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            },
        },
        {
            "lukas-reineke/indent-blankline.nvim",
            opts = {
                buftype_exclude = {
                    "nofile",
                    "terminal"
                },
                show_trailing_blankline_indent = false,
                use_treesitter = true,
                char = "▏",
                context_char = "▏",
                show_current_context = true,
            },
        },
        {
            "folke/tokyonight.nvim",
            lazy = false,
            priority = 1000,
            opts = {},
        },
        -- General plugins
        {
            "akinsho/toggleterm.nvim",
            opts = {
                size = 10,
                on_create = function()
                    vim.opt.foldcolumn = "0"
                    vim.opt.signcolumn = "no"
                end,
                open_mapping = [[<F12>]],
                shading_factor = 2,
                direction = "float",
                float_opts = {
                    border = "curved",
                    highlights = { border = "Normal", background = "Normal" },
                },
            },
        },
        "NMAC427/guess-indent.nvim",
        "mhinz/vim-startify",
        { "numToStr/Comment.nvim", opts = {} },
        { "folke/which-key.nvim",  opts = {} },
        { "windwp/nvim-autopairs", opts = {} },
        { "tpope/vim-surround", },
        -- Project
        {
            "ahmedkhalf/project.nvim",
            config = function()
                require("project_nvim").setup(
                    {
                        sync_root_with_cwd = true,
                        respect_buf_cwd = true,
                        update_focused_file = {
                            enable = true,
                            update_root = true
                        },
                        silent_chdir = false
                    }
                )
            end
        },
        {
            "nvim-telescope/telescope.nvim",
            version = "^0.1",
            dependencies = { "nvim-lua/plenary.nvim" },
        },
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build =
            'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
        },
        -- LSP, Completion
        {
            "neovim/nvim-lspconfig",
            dependencies = {
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
                { "j-hui/fidget.nvim", opts = {}, tag = "legacy" }, -- LSP status updates
            }
        },
        {
            "hrsh7th/nvim-cmp",
            dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = {
                ":TSUpdate"
            },
        },
        -- Git signs
        {
            "lewis6991/gitsigns.nvim",
            opts = {
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" }
                }
            },
        },
        -- Lualine
        {
            "nvim-lualine/lualine.nvim",
            opts = {
                options = {
                    icons_enabled = false,
                    theme = "tokyonight",
                    disabled_filetypes = {
                        "startify"
                    }
                }
            },
        },

        {
            "stevearc/dressing.nvim",
            opts = {
                select = {
                    backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
                    builtin = { win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" } },
                },
            },
        },
    }
)

local function set_keymap(mode, combo, mapping, options)
    vim.api.nvim_set_keymap(mode, combo, mapping, options)
end

set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
    { silent = true, noremap = true }
)

-- Project navigation
set_keymap('n', '<C-p>', ':Telescope projects<CR>', { noremap = true, silent = true })

-- Neotree activation
set_keymap('n', '<leader>e', ':Neotree<CR>', { noremap = true })

-- Netrw quit operation
set_keymap('n', '<leader>.', ':bd<CR>', { noremap = true })

-- Split navigation
local splits = {
    ['j'] = '<C-W><C-J>',
    ['k'] = '<C-W><C-K>',
    ['l'] = '<C-W><C-L>',
    ['h'] = '<C-W><C-H>',
    ['w'] = '<C-W><C-W>'
}
for k, v in pairs(splits) do
    set_keymap('n', '<leader>' .. k, v, { noremap = true })
end

-- Split operations
set_keymap('n', '<leader>\\', ':vsplit<CR>', { noremap = true, silent = true })
set_keymap('n', '<leader>-', ':split<CR>', { noremap = true, silent = true })

-- Disable <Space> keymap
set_keymap('n', '<Space>', '<Nop>', { silent = true })

-- Centering post scrolling
set_keymap('n', '<C-d>', '<C-d>zz', { silent = true })
set_keymap('n', '<C-u>', '<C-u>zz', { silent = true })

-- Startify browse operation
set_keymap('n', '<leader>p', ':Startify<CR>', { desc = 'Browse startify', silent = true })

-- Diagnostic navigation
set_keymap('n', '<leader>dp', ':lua vim.diagnostic.goto_prev()<CR>', { desc = '[D]iagnostic [P]revious' })
set_keymap('n', '<leader>dn', ':lua vim.diagnostic.goto_next()<CR>', { desc = '[D]iagnostic [N]ext' })
set_keymap('n', '<leader>dm', ':lua vim.diagnostic.open_float()<CR>', { desc = '[D]iagnostic [M]essage' })
set_keymap('n', '<leader>dl', ':lua vim.diagnostic.setloclist()<CR>', { desc = '[D]iagnostic [L]ist' })

-- Telescope operations
set_keymap('n', '<leader>f', ':Telescope find_files<CR>', { desc = "Search [F]iles", silent = true })
set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = "Search live [G]rep", silent = true })
set_keymap('n', '<leader>fb', ':Telescope buffers<CR>', { desc = "Search [B]uffers", silent = true })
set_keymap('n', '<leader>fd', ':Telescope diagnostics<CR>', { desc = "Search [D]iagnostics", silent = true })

-- LSP Keymaps
local on_attach = function(_, bufnr)
    local function set_lsp_keymap(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    set_lsp_keymap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    set_lsp_keymap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    set_lsp_keymap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    set_lsp_keymap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    set_lsp_keymap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    set_lsp_keymap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    set_lsp_keymap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    set_lsp_keymap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    set_lsp_keymap('K', vim.lsp.buf.hover, 'Hover Documentation')
    set_lsp_keymap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
end

-- Setup colorscheme
vim.cmd [[colorscheme tokyonight-storm]]

-- Load plugins
local telescope = require("telescope")
local treesitter = require("nvim-treesitter.configs")
local mason = require("mason")
local mason_lspconfig = require "mason-lspconfig"
local cmp = require "cmp"
local luasnip = require "luasnip"
local dressing = require('dressing')

-- Setup nvim-cmp
luasnip.config.setup {}

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert {
        ["<C-Space>"] = cmp.mapping.complete {},
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        },
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item()
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }
}

-- Setup Telescope
telescope.setup {
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = require("telescope.actions").move_selection_next,
                ["<C-k>"] = require("telescope.actions").move_selection_previous
            }
        },
    }
}
telescope.load_extension('fzf') -- Load fzf extension for Telescope
require('telescope').load_extension('projects')

-- Setup Treesitter
treesitter.setup({
    ensure_installed = { "c", "cpp", "lua", "markdown", "rust", "vimdoc", "vim", "python", "html", "haskell" },
    highlight = { enable = true },
    indent = { enable = true }
})

-- Setup LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local servers = {
    clangd = {},
    pyright = {},
    rust_analyzer = {},
    jdtls = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false }
        }
    }
}

mason.setup()

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers)
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name]
        }
    end
}

-- Startify settings
vim.g.startify_bookmarks = {
    { a = "~/.config/nvim/init.lua" }
}

-- Dressing setup
dressing.setup({})

-- Explorer settings
set_keymap('n', '<leader>e', ':Neotree toggle<cr>', { noremap = true, silent = true })

function toggle_explorer_focus()
    if vim.bo.filetype == "neo-tree" then
        vim.cmd("wincmd p")
    else
        vim.cmd("Neotree focus")
    end
end

-- Key mapping to call toggle_explorer_focus
set_keymap('n', '<leader>o', ':lua toggle_explorer_focus()<cr>', { noremap = true, silent = true })

vim.loader.enable()
