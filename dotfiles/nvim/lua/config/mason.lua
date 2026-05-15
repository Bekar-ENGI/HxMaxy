require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
-- servers
local servers = {"vtsls","html","cssls","tailwindcss","vimls","bashls"}
require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_installation = true,
})

-- nvim-cmp capabilities (APPLY TO ALL SERVERS)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

for _, server in ipairs(servers) do
    vim.lsp.config(server, {
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        },
    })
end 

-- This automatically sets up ALL installed servers
for _, server in ipairs(servers) do
    vim.lsp.enable(server)
end

-- LSP keybindings (buffer-local)
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local buf = ev.buf
        local opts = { buffer = buf, silent = true }

        -- Go to
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

        -- Info
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

        -- Actions
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        -- Diagnostics
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
        -- Dynamic formatting with fallback
        vim.keymap.set("n", "<leader>f", function()
            local has_formatting = false
            for _, client in pairs(vim.lsp.get_clients({ buf = buf })) do
                if client.server_capabilities.documentFormattingProvider then
                    has_formatting = true
                    break
                end
            end

            if has_formatting then
                -- Use LSP formatting
                vim.lsp.buf.format({ async = true })
            else
                -- Fallback to native Vim formatting (with cursor preservation)
                local pos = vim.api.nvim_win_get_cursor(0)
                vim.cmd("normal! gg=G")
                vim.api.nvim_win_set_cursor(0, pos)
            end
        end, opts)
    end,
})
