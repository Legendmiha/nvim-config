return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    hide_during_completion = false,
                    debounce = 25,
                    keymap = {
                        accept = false,
                        accept_word = false,
                        accept_line = "<C-y>",
                        next = false,
                        prev = false,
                        dismiss = false,
                    },
                },
                filetypes = {
                    ["*"] = true,
                },
                -- only needed if using nodejs version < 20
                copilot_node_command = '/home/legendmiha/.local/share/mise/installs/node/25.2.1/bin/node'
            })
        end,
    },
}

