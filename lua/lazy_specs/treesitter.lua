return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "vimdoc", "javascript", "typescript", "lua",
      "jsdoc", "bash", "python", "tsx", "json",
    },
    sync_install = false,
    auto_install = true,
    indent = {
      enable = true,
    },
    highlight = {
      enable = true,
      disable = function(lang, buf)
        if lang == "html" then
          return true
        end
        local max_filesize = 200 * 1024 -- 200 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          vim.notify(
            "File larger than 200KB, Treesitter disabled for performance",
            vim.log.levels.WARN,
            { title = "Treesitter" }
          )
          return true
        end
      end,
      additional_vim_regex_highlighting = { "markdown" },
    },
  },
  config = function(_, opts)
    -- Lazy passes `opts` here automatically
    require("nvim-treesitter.configs").setup(opts)
    -- 🔽 custom parser
    local parser_config =
      require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.templ = {
      install_info = {
        url = "https://github.com/vrischmann/tree-sitter-templ.git",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "master",
      },
    }
    vim.treesitter.language.register("templ", "templ")
  end,
}
