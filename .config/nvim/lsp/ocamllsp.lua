return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/ocamllsp' },
    filetypes = { 'ocaml', 'menhir', 'ocamlinterface', 'ocamllex', 'reason', 'dune' },
    root_markers = { '.opam', 'esy.json', 'package.json', '.git', 'dune-project', 'dune-workspace' },
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace",
            },
            diagnostics = {
                -- globals = { "vim" },
                disable = {
                    "missing-fields",
                },
            },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME
                },
            },
            telemetry = {
                enable = false
            }
        }
    }
}

-- vim.fn.stdpath('data') . '/mason/bin/lua-language-server'
