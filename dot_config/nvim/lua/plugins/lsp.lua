return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    servers = {
      -- pyright will be automatically installed with mason and loaded with lspconfig
      -- pyright = {},

      lua_ls = {},
      zls = {},
      texlab = {
        settings = {
          texlab = {
            auxDirectory = ".",
            bibtexFormatter = "texlab",
            build = {
              executable = "tectonic",
              args = {
                "-X",
                "compile",
                "%f",
                "--synctex",
                "--keep-logs",
                "--keep-intermediates"
              },
              forwardSearchAfter = false,
              onSave = true
            },
            chktex = {
              onEdit = false,
              onOpenAndSave = false
            },
            diagnosticsDelay = 300,
            formatterLineLength = 80,
            forwardSearch = {
              executable = "zathura",
              args = { "--synctex-forward", "%l:1:%f", "%p" }
            },
            latexFormatter = "latexindent",
            latexindent = {
              modifyLineBreaks = false
            }
          }
        }
      },
      rust_analyzer = {
        procMacro = { enable = true },
        cargo = { allFeatures = true },
        rustfmt = {
          extraArgs = { "+nightly" },
        },
        checkOnSave = {
          command = "clippy",
          extraArgs = { "--no-deps" },
        },
      },
      clangd = {
        root_dir = function(fname)
          local function upfind(names, start)
            for _, name in ipairs(names) do
              local found = vim.fs.find(name, { path = start, upward = true })[1]
              if found then
                -- For files and for ".git" (which is a dir), return the parent dir
                return vim.fs.dirname(found)
              end
            end
          end

          -- 1) Prefer compilation DB / flags
          local root = upfind({ "compile_commands.json", "compile_flags.txt" }, fname)
          if root then return root end

          -- 2) Build-system markers
          root = upfind({
            "Makefile",
            "configure.ac",
            "configure.in",
            "config.h.in",
            "meson.build",
            "meson_options.txt",
            "build.ninja",
            "CMakeLists.txt",
          }, fname)
          if root then return root end

          -- 3) Git repo root
          local git = vim.fs.find(".git", { path = fname, upward = true })[1]
          if git then return vim.fs.dirname(git) end

          -- 4) Fallback: directory of the file
          return vim.fs.dirname(fname)
        end,
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=never",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
      },
      tinymist = {
        cmd = { "tinymist" },
        filetypes = { "typst" },

        -- ✅ functions go here, NOT inside `settings`
        on_attach = function(client, bufnr)
          vim.api.nvim_create_user_command("OpenPdf", function()
            local filepath = vim.api.nvim_buf_get_name(0)
            if not filepath:match("%.typ$") then return end

            local pdf_path = filepath:gsub("%.typ$", ".pdf")

            -- Check if Zathura exists, then open the PDF detached
            if vim.fn.executable("zathura") == 1 then
              vim.system({ "zathura", pdf_path }, { detach = true })
            else
              vim.notify("Zathura not found in PATH.", vim.log.levels.ERROR)
            end
          end, { desc = "Open compiled PDF in Zathura" })

          -- Pin current file as main
          vim.keymap.set("n", "<leader>tp", function()
            client:exec_cmd({
              title = "pin",
              command = "tinymist.pinMain",
              arguments = { vim.api.nvim_buf_get_name(0) },
            }, { bufnr = bufnr })
          end, { desc = "[T]inymist [P]in", noremap = true, buffer = bufnr })

          -- Unpin
          vim.keymap.set("n", "<leader>tu", function()
            client:exec_cmd({
              title = "unpin",
              command = "tinymist.pinMain",
              arguments = { vim.v.null },
            }, { bufnr = bufnr })
          end, { desc = "[T]inymist [U]npin", noremap = true, buffer = bufnr })
        end,

        -- ✅ JSON-serializable only
        settings = {
          exportPdf = "onSave",       -- "never" | "onSave" | "onType"
          formatterMode = "typstfmt", -- or "typstyle" if you prefer
          semanticTokens = true,
          typstExtraArgs = {},
          ["tinymist"] = {
            formatterMode = "typstfmt", -- or "typstyle" if you prefer
            exportPdf = "onSave",       -- "never" | "onSave" | "onType"
            semanticTokens = true,
            typstExtraArgs = {},
          },
        },
      },
      gopls = {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      },
    },
  },
}
