return {
    "mfussenegger/nvim-dap",
    dependencies = {
        -- UI panels (scopes, breakpoints, stacks, watches, REPL)
        { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
        -- Inline virtual-text showing variable values next to your code
        "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
        { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "DAP: toggle breakpoint" },
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "DAP: conditional breakpoint" },
        { "<leader>dc", function() require("dap").continue() end,                                             desc = "DAP: continue / start" },
        { "<leader>di", function() require("dap").step_into() end,                                            desc = "DAP: step into" },
        { "<leader>do", function() require("dap").step_over() end,                                            desc = "DAP: step over" },
        { "<leader>dO", function() require("dap").step_out() end,                                             desc = "DAP: step out" },
        { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "DAP: toggle REPL" },
        { "<leader>dl", function() require("dap").run_last() end,                                             desc = "DAP: run last" },
        { "<leader>dt", function() require("dap").terminate() end,                                            desc = "DAP: terminate" },
        { "<leader>du", function() require("dapui").toggle() end,                                             desc = "DAP: toggle UI" },
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup()
        require("nvim-dap-virtual-text").setup()

        -- Open the UI automatically on session start, close it on exit.
        dap.listeners.before.attach.dapui_config = function() dapui.open() end
        dap.listeners.before.launch.dapui_config = function() dapui.open() end
        dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
        dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

        -- Breakpoint sign
        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })

        -- ── Adapters / configurations ──────────────────────────────────
        -- Add per-language adapters here as you need them, e.g. codelldb
        -- for Rust/C (install via :MasonInstall codelldb):
        --
        -- dap.adapters.codelldb = {
        --     type = "server",
        --     port = "${port}",
        --     executable = {
        --         command = vim.fn.exepath("codelldb"),
        --         args = { "--port", "${port}" },
        --     },
        -- }
        -- dap.configurations.rust = {
        --     {
        --         name = "Launch",
        --         type = "codelldb",
        --         request = "launch",
        --         program = function()
        --             return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        --         end,
        --         cwd = "${workspaceFolder}",
        --         stopOnEntry = false,
        --     },
        -- }
    end,
}
