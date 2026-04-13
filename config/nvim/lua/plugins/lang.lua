-- Language support extras for LazyVim
-- Each import enables LSP + treesitter + formatter for that language
return {
  -- TypeScript / JavaScript / React
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- JSON (with SchemaStore for autocompletion)
  { import = "lazyvim.plugins.extras.lang.json" },

  -- Rust (rust-analyzer)
  { import = "lazyvim.plugins.extras.lang.rust" },

  -- Java (jdtls, for Minecraft dev)
  { import = "lazyvim.plugins.extras.lang.java" },

  -- Python (pyright)
  { import = "lazyvim.plugins.extras.lang.python" },

  -- YAML (with SchemaStore)
  { import = "lazyvim.plugins.extras.lang.yaml" },

  -- Markdown
  { import = "lazyvim.plugins.extras.lang.markdown" },

  -- Docker (Dockerfile + docker-compose)
  { import = "lazyvim.plugins.extras.lang.docker" },

  -- Tailwind CSS
  { import = "lazyvim.plugins.extras.lang.tailwind" },
}
