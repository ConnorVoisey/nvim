return {
    'navarasu/onedark.nvim',
    config = function()
        require('onedark').setup({
            disable_background = true
        })

        function ColorMyPencils(color)
            color = color or "onedark"
            vim.cmd.colorscheme(color)

            vim.api.nvim_set_hl(0, "Normal", {
                bg = "none"
            })
            vim.api.nvim_set_hl(0, "NormalFloat", {
                bg = "none"
            })

        end

        ColorMyPencils()
    end
}

-- return {
--     'catppuccin/nvim',
--     config = function()
--         vim.cmd.colorscheme "catppuccin"
--         -- require('onedark').setup({
--         --     disable_background = true
--         -- })
--
--         function ColorMyPencils(color)
--             color = color or "catppuccin"
--             vim.cmd.colorscheme(color)
--
--             vim.api.nvim_set_hl(0, "Normal", {
--                 bg = "none"
--             })
--             vim.api.nvim_set_hl(0, "NormalFloat", {
--                 bg = "none"
--             })
--
--         end
--
--         ColorMyPencils()
--     end
-- }
