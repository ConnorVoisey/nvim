return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {'nvim-lua/plenary.nvim'},
    config = function()
        local telescope = require('telescope')
        local builtin = require('telescope.builtin')
        local previewers = require("telescope.previewers")
        local Job = require("plenary.job")

        -- Telescope configuration

        -- Do not preview any file larger than 20K
        -- local new_maker = function(filepath, bufnr, opts)
        --     opts = opts or {}
        --
        --     filepath = vim.fn.expand(filepath)
        --     vim.loop.fs_stat(filepath, function(_, stat)
        --         if not stat then return end
        --         if stat.size > 20000 then
        --             return
        --         else
        --             previewers.buffer_previewer_maker(filepath, bufnr, opts)
        --         end
        --     end)
        -- end

        -- Do not preview binary files
        local new_maker = function(filepath, bufnr, opts)
            filepath = vim.fn.expand(filepath)
            Job:new({
                command = "file",
                args = {"--mime-type", "-b", filepath},
                on_exit = function(j)
                    local mime_type = vim.split(j:result()[1], "/")[1]
                    if mime_type == "text" then
                        previewers.buffer_previewer_maker(filepath, bufnr, opts)
                    else
                        -- maybe we want to write something to the buffer here
                        vim.schedule(function()
                            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {"BINARY"})
                        end)
                    end
                end
            }):sync()
        end

        telescope.setup({
            defaults = {
                buffer_previewer_maker = new_maker
            },
            pickers = {
                find_files = {
                    -- use find_files to show all files (including ignored and hidden files)
                    -- use git_files instead to show all tracked files (respects .gitignore, shows only tracked dotfiles)
                    find_command = {"fdfind", "--type", "f", "--strip-cwd-prefix", "--hidden", "--no-ignore",
                                    "--exclude", "**/.git/*"}
                }
            }
        })

        -- Standard Keymaps

        -- Project files (all files)
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

        -- Project live ripgrep
        vim.keymap.set('n', '<leader>pl', builtin.live_grep, {})

        -- Project ripgrep
        vim.keymap.set('n', '<leader>prg', function()
            builtin.grep_string({
                search = vim.fn.input("Grep > ")
            });
        end)

        -- Git Integration

        -- Project git files (respects git ignore)
        vim.keymap.set('n', '<leader>pg', builtin.git_files, {})

        -- Project git diff
        vim.keymap.set('n', '<leader>pd', builtin.git_status, {})

        -- Project git commits
        vim.keymap.set('n', '<leader>pc', builtin.git_commits, {})

        -- Project git branches
        vim.keymap.set('n', '<leader>pb', builtin.git_branches, {})

        -- Project git stash
        vim.keymap.set('n', '<leader>ps', builtin.git_stash, {})

        -- Other Keymaps

        -- View telescope commands
        vim.keymap.set('n', '<leader>pt', builtin.builtin, {})

        -- View helptags
        vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
    end
}
