local Lsp = require "utils.lsp"
-- uv tool install pyright@latest
return {
  cmd = { "pyright-langserver", "--stdio" },
  on_attach = Lsp.on_attach,
  filetypes = { "python" },
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        ignore = { "*" },
        typeCheckingMode = "off",
      }
    }
  }
}
