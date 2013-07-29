desc "installs vimfiles"
task :default => [:clone_vundle, :bundle_install, :make_vimproc]

task :clone_vundle do
  vundle_path = File.expand_path(".vim.symlink/bundle/vundle")
  unless Dir.exist?(vundle_path)
    sh "git clone http://github.com/gmarik/vundle.git #{vundle_path}"
  end
end

task :bundle_install do
  sh "vim -c :BundleInstall -c :q -c :q"
end

task :make_vimproc do
  Dir.chdir ".vim.symlink/bundle/vimproc.vim" do
    sh "make -f make_mac.mak"
  end
end
