local status, ts_install = pcall(require, "nvim-treesitter.install")
if status then
  ts_install.compilers = { "@gcc@/bin/gcc" }
end
