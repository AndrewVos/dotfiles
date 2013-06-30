desc "installs vimfiles"
task :default => [:setup_symlinks, :clone_vundle, :bundle_install, :make_vimproc]

task :setup_symlinks do
  Dir.glob(".*.symlink").each do |linkable|
    target = File.expand_path(File.join("~", linkable.gsub(".symlink", "")))

    if File.exist?(target) || File.symlink?(target)
      puts "File already exists: #{target}, overwrite? [y]es, [n]o"
      response = STDIN.gets.chomp.downcase
      next if response == "n"
      if response == "y"
        puts "Overwriting #{target}"
        FileUtils.rm_rf target
      end
    end

    File.symlink File.expand_path(linkable), target
  end
end

task :clone_vundle do
  vundle_path = File.expand_path("~/.vim/bundle/vundle")
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
