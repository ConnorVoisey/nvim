return {
    -- ── Autocompletion (kept; now wired to native LSP via capabilities) ──
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args) luasnip.lsp_expand(args.body) end,
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(select),
                    ['<C-n>'] = cmp.mapping.select_next_item(select),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-f>'] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() else fallback() end
                    end, { 'i', 's' }),
                    ['<C-b>'] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then luasnip.jump(-1) else fallback() end
                    end, { 'i', 's' }),
                }),
            })
        end,
    },

    -- ── lazydev: replaces the archived neodev.nvim for lua-ls + Neovim API ──
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    -- ── LSP (native vim.lsp.config / vim.lsp.enable — no more lsp-zero) ──
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        cmd = { 'LspInfo', 'LspStart' },
        dependencies = {
            { 'mason-org/mason.nvim', config = true },
            'mason-org/mason-lspconfig.nvim',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            -- Diagnostics: configured once (previously re-set on every attach).
            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '✘',
                        [vim.diagnostic.severity.WARN]  = '▲',
                        [vim.diagnostic.severity.HINT]  = '⚑',
                        [vim.diagnostic.severity.INFO]  = '»',
                    },
                },
            })

            -- Default config merged into every server (0.11+ native API).
            -- Feeds nvim-cmp's completion capabilities to all language servers.
            vim.lsp.config('*', {
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            })

            -- lua_ls: recognise the `vim` global (lazydev supplies the library).
            vim.lsp.config('lua_ls', {
                settings = { Lua = { diagnostics = { globals = { 'vim' } } } },
            })

            -- rust_analyzer is owned by rustaceanvim (see plugins/rustaceanvim.lua);
            -- it's excluded from automatic_enable below so only one instance runs.

            -- roc: not packaged by mason/lspconfig — register + enable manually.
            -- root_markers replaces the deprecated lspconfig.util.find_git_ancestor.
            vim.lsp.config('roc', {
                cmd = { 'roc_language_server' },
                filetypes = { 'roc' },
                root_markers = { '.git' },
            })
            vim.lsp.enable('roc')

            -- mason installs the servers; mason-lspconfig (main branch) then
            -- auto-enables every installed server via vim.lsp.enable().
            require('mason-lspconfig').setup({
                ensure_installed = { 'lua_ls' },
                -- rustaceanvim starts rust-analyzer itself; enabling it here
                -- too would run two servers fighting over the target/ lock.
                automatic_enable = { exclude = { 'rust_analyzer' } },
            })

            -- Buffer-local keymaps on attach. Neovim 0.11+ already provides
            -- grn (rename), gra (code action), grr (refs), gri (impl), grt,
            -- gO (symbols), K (hover), <C-s> (sig help), [d/]d, <C-w>d as
            -- defaults — these keep your existing <leader>v* muscle memory.
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(event)
                    local opts = { buffer = event.buf, remap = false }
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
                    vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
                    vim.keymap.set('n', '<leader>ve', vim.diagnostic.open_float, opts)
                    vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
                    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
                    -- Fixed: previously [d/]d were reversed and used the now
                    -- deprecated vim.diagnostic.goto_next/goto_prev.
                    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, opts)
                    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, opts)
                end,
            })
        end,
    },
}
