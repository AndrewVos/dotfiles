class Sync
  IGNORE_PACKAGES = File.read("packages/ignore.txt").split
  PACMAN_PACKAGES = File.read("packages/pacman.txt").split
  AUR_PACKAGES = File.read("packages/aur.txt").split

  def sync
    if packages = packages_to_remove
      system "sudo pacman -R " + packages.join(' ')
    end

    if packages = packages_to_add
      system "sudo pacman -S " + packages.join(' ')
    end

    if packages = aur_packages_to_add
      system "yay -S " + packages.join(' ')
    end
  end

  def commonly_installed_packages
    `pacman -Qq -g base-devel`.split
  end

  def explicitly_installed_packages
    `pacman -Qeqt`.split
  end

  def installed_packages
    `pacman -Qq`.split
  end

  def packages_to_remove
    explicitly_installed_packages - (
      PACMAN_PACKAGES +
      AUR_PACKAGES +
      IGNORE_PACKAGES +
      commonly_installed_packages
    )
  end

  def packages_to_add
    PACMAN_PACKAGES.select do |package|
      !installed_packages.includes?(package)
    end
  end

  def aur_packages_to_add
    AUR_PACKAGES.select do |package|
      !installed_packages.includes?(package)
    end
  end
end

Sync.new.sync
