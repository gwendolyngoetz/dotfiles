local status_ok, prettyfold = pcall(require, "pretty-fold")
if not status_ok then
  return
end

prettyfold.setup()
