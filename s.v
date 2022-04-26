import os
import toml

fn main() {
	module_paths := os.glob('modules/*') or { panic(err) }

	mut packages := []Package{}
	mut aur := []Aur{}
	mut symlinks := []Symlink{}

	for module_path in module_paths {
		module_name := os.base(module_path)

		contents := os.read_file(os.join_path(module_path, 'configuration.toml')) or { panic(err) }
		document := toml.parse_text(contents) or { panic(err) }

		packages << retrieve_packages(document)
		aur << retrieve_aur_packages(document)
		symlinks << retrieve_symlinks(module_name, document)
		services := retrieve_services(document)
		scripts := retrieve_scripts(document)
		groups := retrieve_groups(document)
		lines := retrieve_lines(document)
	}

	packages.execute()
	aur.execute()
	symlinks.execute()
}

struct Package {
	names []string
}

fn (packages []Package) missing() []string {
	mut result := []string{}
	installed := os.execute('pacman -Qq').output.trim('\n').split('\n')

	for package in packages {
		for name in package.names {
			if name !in installed {
				result << name
			}
		}
	}

	return result
}

fn (packages []Package) execute() {
	missing_packages := packages.missing()
	if missing_packages.len > 0 {
		result := os.system('sudo pacman -S ${missing_packages.join(' ')}')
		if result != 0 {
			exit(result)
		}
	}
}

fn (packages []Aur) missing() []string {
	mut result := []string{}
	installed := os.execute('pacman -Qq').output.trim('\n').split('\n')

	for package in packages {
		for name in package.names {
			if name !in installed {
				result << name
			}
		}
	}

	return result
}

fn (aur_packages []Aur) execute() {
	missing_packages := aur_packages.missing()
	if missing_packages.len > 0 {
		result := os.system('yay -S ${missing_packages.join(' ')}')
		if result != 0 {
			exit(result)
		}
	}
}

fn retrieve_packages(document toml.Doc) []Package {
	mut packages := []Package{}

	for top_level_key, top_level_value in document.to_any().as_map() {
		if top_level_key == 'package' {
			for key, value in top_level_value.as_map() {
				packages << Package{
					names: value.value('name').array().as_strings()
				}
			}
		}
	}

	return packages
}

struct Aur {
	names []string
}

fn retrieve_aur_packages(document toml.Doc) []Aur {
	mut aur_packages := []Aur{}

	for top_level_key, top_level_value in document.to_any().as_map() {
		if top_level_key == 'aur' {
			for aur_package in top_level_value.array() {
				aur_packages << Aur{
					names: aur_package.value('name').array().as_strings()
				}
			}
		}
	}

	return aur_packages
}

struct Symlink {
	module_name string
	become      bool
	from        string
	to          string
}

fn (s Symlink) full_from() string {
	return os.expand_tilde_to_home(s.from)
}

fn (s Symlink) full_to() string {
	if s.to.starts_with('/') {
		return s.to
	}
	return os.join_path(os.getwd(), 'modules', s.module_name, 'files', s.to)
}

fn (symlinks []Symlink) execute() {
	mut missing := []Symlink{}

	for symlink in symlinks {
		if os.real_path(symlink.full_from()) != symlink.full_to() {
			missing << symlink
		}
	}

	for symlink in missing {
		if os.is_file(symlink.full_from()) || os.is_link(symlink.full_from()) {
			println('error: file $symlink.full_from() already exists')
			exit(1)
		} else {
			if symlink.become {
				mut process := os.new_process('/usr/bin/sudo')
				process.set_args(['ln', '-s', symlink.full_to(),
					symlink.full_from()])
				process.run()
				process.wait()
			} else {
				os.symlink(symlink.full_to(), symlink.full_from()) or { panic(err) }
			}
		}
	}
}

fn retrieve_symlinks(module_name string, document toml.Doc) []Symlink {
	mut symlinks := []Symlink{}

	for top_level_key, top_level_value in document.to_any().as_map() {
		if top_level_key == 'symlink' {
			for key, value in top_level_value.as_map() {
				symlinks << Symlink{
					module_name: module_name
					become: value.value('become').default_to(false).bool()
					from: value.value('from').string()
					to: value.value('to').string()
				}
			}
		}
	}

	return symlinks
}

struct Service {
	name   string
	enable bool
	start  bool
}

fn retrieve_services(document toml.Doc) []Service {
	mut services := []Service{}

	for top_level_key, top_level_value in document.to_any().as_map() {
		if top_level_key == 'service' {
			for key, value in top_level_value.as_map() {
				services << Service{
					name: value.value('name').string()
					enable: value.value('enable').bool()
					start: value.value('start').bool()
				}
			}
		}
	}

	return services
}

struct Script {
	name string
}

fn retrieve_scripts(document toml.Doc) []Script {
	mut scripts := []Script{}

	for top_level_key, top_level_value in document.to_any().as_map() {
		if top_level_key == 'script' {
			for key, value in top_level_value.as_map() {
				scripts << Script{
					name: value.value('name').string()
				}
			}
		}
	}

	return scripts
}

struct Group {
	user   string
	groups []string
}

fn retrieve_groups(document toml.Doc) []Group {
	mut groups := []Group{}

	for top_level_key, top_level_value in document.to_any().as_map() {
		if top_level_key == 'group' {
			for value in top_level_value.array() {
				groups << Group{
					user: value.value('user').string()
					groups: value.value('groups').array().as_strings()
				}
			}
		}
	}

	return groups
}

struct Line {
	path string
	line string
}

fn retrieve_lines(document toml.Doc) []Line {
	mut lines := []Line{}

	for top_level_key, top_level_value in document.to_any().as_map() {
		if top_level_key == 'line' {
			for line in top_level_value.array() {
				lines << Line{
					path: line.value('path').string()
					line: line.value('line').string()
				}
			}
		}
	}

	return lines
}
