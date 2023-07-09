local features = require("config.features")

return {
  {
    "mfussenegger/nvim-jdtls",
    enabled = features.java,
    commit = "0261cf5",
  },
}
