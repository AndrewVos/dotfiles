['.vimrc', '.vim'].each do |path|
  old = File.expand_path("./#{path}")
  new = File.expand_path("~/#{path}")
  File.symlink old, new
end
