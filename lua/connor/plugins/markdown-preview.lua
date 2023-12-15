return {
    "iamcco/markdown-preview.nvim",
    config = function()
        vim.fn["mkdp#util#install"]()
        vim.keymap.set("n", "<leader>md", "<cmd>MarkdownPreview<CR>");
    end
}
