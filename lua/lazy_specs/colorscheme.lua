-- Follow the Omarchy theme: read the active theme's neovim.lua (a LazyVim-style
-- spec) and re-apply it whenever `omarchy theme set` swaps the theme.

local state_dir = vim.fn.expand("~/.local/state/omarchy/current")
local theme_file = state_dir .. "/theme/neovim.lua"
local transparent = true

-- Colorscheme plugins used by stock Omarchy themes, installed up front so
-- switching themes never needs a download. Lazy.nvim loads them on :colorscheme.
local plugins = {
    { "bjarneo/aether.nvim", branch = "v3", name = "aether" },
    { "bjarneo/hackerman.nvim", dependencies = { "aether" } },
    { "catppuccin/nvim", name = "catppuccin" },
    { "EdenEast/nightfox.nvim" },
    { "ellisonleao/gruvbox.nvim" },
    { "ficcdaf/ashen.nvim" },
    { "folke/tokyonight.nvim" },
    { "kepano/flexoki-neovim" },
    { "neanias/everforest-nvim" },
    { "OldJobobo/retro-82.nvim" },
    { "omacom-io/lumon.nvim" },
    { "rebelot/kanagawa.nvim" },
    { "ribru17/bamboo.nvim" },
    { "rose-pine/neovim", name = "rose-pine" },
    { "tahayvr/matteblack.nvim" },
}

-- Returns the theme's plugin specs and the colorscheme name it asks for.
local function read_theme()
    local ok, spec = pcall(dofile, theme_file)
    if not ok or type(spec) ~= "table" then
        return {}, nil
    end
    local specs, colorscheme = {}, nil
    for _, s in ipairs(spec) do
        if type(s) == "table" then
            if s[1] == "LazyVim/LazyVim" then
                colorscheme = s.opts and s.opts.colorscheme
            else
                table.insert(specs, s)
            end
        end
    end
    return specs, colorscheme
end

local function plugin_name(s)
    return s.name or s[1]:match("[^/]+$")
end

local function module_name(s)
    return s.main or plugin_name(s):gsub("%.nvim$", ""):gsub("[-.]?nvim$", ""):gsub("^nvim[-.]", "")
end

local function customize()
    if transparent then
        for _, group in ipairs({ "Normal", "NormalNC", "NormalFloat", "SignColumn", "EndOfBuffer" }) do
            vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = group }), { bg = "none" }))
        end
    end
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = vim.api.nvim_get_hl(0, { name = "Comment", link = false }).fg, bg = "none" })
end

local function apply(reload)
    local specs, colorscheme = read_theme()
    if not colorscheme then
        return
    end
    if reload then
        -- Theme opts (e.g. aether's generated palette) change per theme, so re-run setup.
        for _, s in ipairs(specs) do
            if s.opts then
                pcall(require("lazy").load, { plugins = { plugin_name(s) } })
                local ok, mod = pcall(require, module_name(s))
                if ok and type(mod) == "table" and mod.setup then
                    pcall(mod.setup, s.opts)
                end
            end
        end
    end
    vim.cmd("hi clear")
    local ok, err = pcall(vim.cmd.colorscheme, colorscheme)
    if not ok then
        vim.notify("Omarchy theme: " .. err, vim.log.levels.WARN)
        return
    end
    customize()
end

local function watch()
    local handle = vim.uv.new_fs_event()
    local pending = false
    handle:start(state_dir, {}, function(_, filename)
        if filename ~= "theme.name" or pending then
            return
        end
        pending = true
        vim.defer_fn(function()
            pending = false
            apply(true)
            vim.cmd("redraw!")
        end, 200)
    end)
end

-- Include the active theme's own specs (covers custom themes and aether's opts).
local theme_specs = read_theme()
for _, s in ipairs(theme_specs) do
    table.insert(plugins, s)
end
for _, s in ipairs(plugins) do
    s.lazy = true
end

table.insert(plugins, {
    "omarchy-theme",
    virtual = true,
    lazy = false,
    priority = 1000,
    config = function()
        apply(false)
        watch()

        -- Rounded borders on hover and signature help popups
        local border = "rounded"
        vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
            return vim.lsp.handlers.hover(err, result, ctx, vim.tbl_extend("force", config or {}, { border = border }))
        end
        vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
            return vim.lsp.handlers.signature_help(err, result, ctx, vim.tbl_extend("force", config or {}, { border = border }))
        end
    end,
})

return plugins
