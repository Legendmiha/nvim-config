return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
      require("nvim-treesitter").install {
          "vimdoc", "javascript", "typescript", "lua",
          "jsdoc", "bash", "python", "tsx", "json",
      }
      require("nvim-treesitter").setup {
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
                  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
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
      }

      vim.api.nvim_create_autocmd('FileType', {
          callback = function(ev)
              local lang = vim.treesitter.language.get_lang(ev.match)
              if lang and pcall(vim.treesitter.language.inspect, lang) then
                  vim.treesitter.start(ev.buf, lang)
                  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
              end
          end
      })
  end
}
