return {
  'mrcjkb/rustaceanvim',
  version = '^9',
  -- rustaceanvim lazy-loads itself on the rust filetype.
  lazy = false,
  init = function()
    vim.g.rustaceanvim = {
      server = {
        -- `rust-analyzer` on PATH is the rustup proxy, so each project uses
        -- the rust-analyzer matching its own toolchain (rust-toolchain.toml
        -- aware). Its proc-macro server then matches the rustc that built the
        -- macros. Needs `rustup component add rust-analyzer` per toolchain.
        cmd = { 'rust-analyzer' },
        on_attach = function(_, bufnr)
          -- on_attach runs after LspAttach autocmds, so these override the
          -- generic K / code-action maps from lsp.lua for Rust buffers.
          local opts = { silent = true, buffer = bufnr }
          vim.keymap.set('n', 'K', function() vim.cmd.RustLsp({ 'hover', 'actions' }) end, opts)
          vim.keymap.set('n', '<leader>a', function() vim.cmd.RustLsp('codeAction') end, opts)
        end,
        default_settings = {
          ['rust-analyzer'] = {
            -- Build into target/rust-analyzer so RA never blocks on (or
            -- invalidates) the lock held by your own `cargo build/run/watch`.
            cargo = { targetDir = true },
          },
        },
      },
    }
  end,
}
