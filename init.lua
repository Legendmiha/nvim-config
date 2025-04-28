require("set")
require("remap")
require("lazy_init")

local initGroup = vim.api.nvim_create_augroup('init', {})

-- Delete all trailing whitespace at the end of every line in the file.
vim.api.nvim_create_autocmd({"BufWritePre"}, {
    group = initGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = initGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        -- Go to the definition of the thing under cursor (e.g., function, variable)
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        -- Hover popup — shows documentation or type info (e.g., when you hover over a function).
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        -- Search for symbols across the whole project (functions, classes, etc.).
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        -- Show diagnostic message (errors, warnings) in a floating window at cursor.
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float({ focusable = true }) end, opts)
        -- Open a menu for available code actions (like quickfixes, refactors).
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        -- List all references to the symbol under cursor (who uses this function/variable).
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        -- Rename symbol (variable, function, etc.) everywhere it's used.
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        -- Show function signature (parameters info) when you’re typing inside a function call.
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        -- Jump to the next diagnostic (error, warning) below the cursor.
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        -- Jump to the previous diagnostic (above the cursor).
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

-- Open files in same window (no splits)
vim.g.netrw_browse_split = 0
-- Hide the top help banner
vim.g.netrw_banner = 0
-- Make Netrw window 25% of the screen size
vim.g.netrw_winsize = 25
