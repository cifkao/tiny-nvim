local Lsp = require "utils.lsp"
-- uv tool install ruff@latest
return {
  cmd = { "ruff", "server" },
  on_attach = Lsp.on_attach,
  filetypes = { "python" },
  settings = {
    python = { }
  }
}
