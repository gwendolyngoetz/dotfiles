local setup_dap = function()
    require("dap").configurations.scala = {
        {
            type = "scala",
            request = "launch",
            name = "RunOrTest",
            metals = {
                runType = "runOrTestFile",
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
            },
        },
        {
            type = "scala",
            request = "launch",
            name = "Test Target",
            metals = {
                runType = "testTarget",
            },
        },
    }
end

return {
    {
        "scalameta/nvim-metals",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        ft = { "scala", "sbt", "java" },
        opts = function()
            local metals_config = require("metals").bare_config()

            metals_config.settings = {
                serverVersion = "latest.release",
                sbtScript = "sbt",
                showImplicitArguments = true,
                superMethodLensesEnabled = true,
                showInferredType = true,
                excludedPackages = {
                    "akka.actor.typed.javadsl",
                    "org.apache.pekko.actor.typed.javadsl",
                    "com.github.swagger.akka.javadsl",
                    "com.github.swagger.pekko.javadsl"
                },
            }

            metals_config.on_attach = function()
                require("metals").setup_dap()
            end

            return metals_config
        end,
        config = function(self, metals_config)
            local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            metals_config.capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

            setup_dap()

            vim.api.nvim_create_autocmd("FileType", {
                pattern = self.ft,
                callback = function()
                    require("metals").initialize_or_attach(metals_config)
                end,
                group = nvim_metals_group,
            })
        end


    },
}
