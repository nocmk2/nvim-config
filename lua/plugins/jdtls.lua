return {
  {
    "mfussenegger/nvim-jdtls",
    ---@type lspconfig.options.jdtls
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      jdtls = function(opts)
        -- local install_path = require("mason-registry").get_package("jdtls"):get_install_path()
        local jvmArg = "-javaagent:" .. "/Users/nocmk2/.local/share/nvim/mason/packages/jdtls/lombok.jar"
        table.insert(opts.cmd, "--jvm-arg=" .. jvmArg)
        return opts
      end,
    },
  },
}
