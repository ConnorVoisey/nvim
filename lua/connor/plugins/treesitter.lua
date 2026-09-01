return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")
            local uv = vim.uv or vim.loop

            -- Optional: defaults to stdpath("data").."/site" which is already
            -- on runtimepath, so the installed parsers + queries take priority
            -- over the (mismatched) system parsers in /usr/lib.
            -- ts.setup {}

            -- ── Register parsers that aren't in the built-in table ──────
            -- New install_info shape: url + (branch|revision), `generate`
            -- only when the repo ships grammar.js but no committed src/.
            local parsers = require("nvim-treesitter.parsers")
            parsers.blade = {
                install_info = {
                    url = "https://github.com/EmranMR/tree-sitter-blade",
                    branch = "main",
                    generate = true, -- repo has no committed parser.c
                },
            }
            parsers.just = {
                install_info = {
                    url = "https://github.com/IndianBoy42/tree-sitter-just",
                    branch = "main", -- ships parser.c + scanner.c, no generate
                },
                maintainers = { "@IndianBoy42" },
            }

            -- ── Filetype detection (used to live in install_info.filetype) ──
            vim.filetype.add({
                extension = { qbe = "qbe", lang = "lang" },
            })

            -- ── Fetch / keep maintained + GitHub parsers up to date ─────
            ts.install({
                "vimdoc", "javascript", "typescript", "c", "lua",
                "rust", "svelte", "blade", "just",
            })

            -- ── Local parsers: install() only supports GitHub tarballs,
            --    so compile pre-generated parser.c by hand into site/. ───
            local function compile_local(lang, src)
                local out_dir = vim.fn.stdpath("data") .. "/site/parser"
                local out = out_dir .. "/" .. lang .. ".so"
                if not uv.fs_stat(src .. "/src/parser.c") then return end
                if uv.fs_stat(out) then return end -- delete the .so to rebuild
                vim.fn.mkdir(out_dir, "p")
                local cmd = { "cc", "-o", out, "-shared", "-Os", "-fPIC",
                    "-I", src .. "/src", src .. "/src/parser.c" }
                if uv.fs_stat(src .. "/src/scanner.c") then
                    table.insert(cmd, src .. "/src/scanner.c")
                end
                vim.fn.system(cmd)
            end
            compile_local("qbe", "/home/connor/code/qbe/tree-sitter-qbe")
            compile_local("lang", "/home/connor/code/tree-sitter/tree-sitter-lang")
            -- roc: source dir missing; restore it then add a compile_local() call.

            -- ── Highlighting is core's job now; enable per buffer.
            --    The main branch dropped auto_install, so download any
            --    missing-but-available parser ourselves, then start. ───
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(ev)
                    local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
                    if pcall(vim.treesitter.start, ev.buf, lang) then return end
                    if not vim.tbl_contains(ts.get_available(), lang)
                        or vim.tbl_contains(ts.get_installed(), lang) then
                        return
                    end
                    ts.install(lang):await(function(err)
                        if err then
                            vim.notify("treesitter install failed for " .. lang .. ": " .. err,
                                vim.log.levels.WARN)
                        elseif vim.api.nvim_buf_is_valid(ev.buf) then
                            vim.treesitter.start(ev.buf, lang)
                        end
                    end)
                end,
            })
        end,
    },
    -- nvim-treesitter/playground is incompatible with the main branch.
    -- Use the built-ins instead: :InspectTree and :EditQuery
}
