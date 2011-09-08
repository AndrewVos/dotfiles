desc "installs vimfiles"
task :default => [:setup_symlinks, :clone_vundle, :bundle_install, :compile_command_t]

task :setup_symlinks do
  ['.vimrc', '.vim'].each do |path|
    old = File.expand_path("./#{path}")
    new = File.expand_path("~/#{path}")
    File.symlink old, new
  end
end

task :clone_vundle do
  sh "git clone http://github.com/gmarik/vundle.git .vim/bundle/vundle"
end

task :bundle_install do
  sh "vim -c :BundleInstall -c :q -c :q"
end

task :compile_command_t do
  Dir.chdir(".vim/bundle/Command-T/ruby/command-t") do
    sh "ruby extconf.rb"
    sh "make"
  end
end
