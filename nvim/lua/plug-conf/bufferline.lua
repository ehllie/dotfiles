local function config()
  require("bufferline").setup()
end

return { "akinsho/bufferline.nvim", config = config, tag = "v2.*" }
