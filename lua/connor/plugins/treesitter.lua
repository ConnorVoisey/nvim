return {
    "IndianBoy42/tree-sitter-just",
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require 'nvim-treesitter.configs'.setup {
                -- A list of parser names, or "all"
                ensure_installed = { "vimdoc", "javascript", "typescript", "c", "lua", "rust", "svelte" },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = true,

                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false
                }
            }
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            parser_config.blade = {
                install_info = {
                    url = "https://github.com/EmranMR/tree-sitter-blade",
                    files = { "src/parser.c" },
                    branch = "main",
                },
                filetype = "blade"
            }
            parser_config.just = {
                install_info = {
                    url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
                    files = { "src/parser.c", "src/scanner.c" },
                    branch = "main",
                    -- use_makefile = true -- this may be necessary on MacOS (try if you see compiler errors)
                },
                maintainers = { "@IndianBoy42" },
            }
            parser_config.roc = {
                install_info = {
                    url = "~/.local/share/nvim/site/pack/tree-sitter-queries/start/tree-sitter-roc", -- local path or git repo
                    files = { "src/parser.c", "src/scanner.c" },
                    -- use_makefile = true -- this may be necessary on MacOS (try if you see compiler errors)
                },
                filetype = "roc",
            }
        end
    },
    'nvim-treesitter/playground',
    -- "nvim-treesitter/nvim-treesitter-context",
}
