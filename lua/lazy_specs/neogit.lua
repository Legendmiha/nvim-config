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
                file_panel = {
                    { "n", "<C-u>", actions.scroll_view(-0.25), { desc = "Scroll up" } },
                    { "n", "<C-d>", actions.scroll_view(0.25), { desc = "Scroll down" } },
                }
            }
        })

        local neogit = require('neogit')
        neogit.setup {}

        vim.keymap.set("n", "<leader>ng", "<cmd>Neogit<CR>")
        vim.keymap.set("n", "<leader>dv", function()
            local view = require("diffview.lib").get_current_view()
            if view then
                -- If Diffview is open, close it
                vim.cmd("DiffviewClose")
            else
                -- If Diffview is not open, open it
                vim.cmd("DiffviewOpen")
            end
        end, { desc = "Toggle Diffview" })
        vim.opt.fillchars:append { diff = "╱" }
    end
}

