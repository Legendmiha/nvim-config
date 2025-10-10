return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim"
    },
    config = function ()
        local actions = require("diffview.actions")
        require("diffview").setup({
            hooks = {
                diff_buf_read = function()
                    vim.opt_local.wrap = true
                end,
            },
            keymaps = {
                view = {
                    { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" } },
                },
                file_panel = {
                    { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" } },
                    { "n", "<C-u>", actions.scroll_view(-0.25), { desc = "Scroll up" } },
                    { "n", "<C-d>", actions.scroll_view(0.25), { desc = "Scroll down" } },
                }
            }
        })

        local neogit = require('neogit')
        neogit.setup {}

        vim.keymap.set("n", "<leader>ng", "<cmd>Neogit<CR>")
        vim.keymap.set("n", "<leader>dv", "<cmd>DiffviewOpen<CR>")
        vim.opt.fillchars:append { diff = "╱" }
    end
}

