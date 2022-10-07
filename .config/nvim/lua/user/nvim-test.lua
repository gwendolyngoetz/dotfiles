local status_ok, nvim_test = pcall(require, "nvim-test")
if not status_ok then
  return
end

nvim_test.setup {
  term = "toggleterm",
  termOpts = {
    direction = "horizontal",
    width = 40,
    height = 15,
  }
}
