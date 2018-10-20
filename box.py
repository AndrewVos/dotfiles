#!/usr/bin/env python3

class ExecutableAction:
    def __init__(self, command):
        self.command = command

    def do(self):
        print('execute -> ' + self.command)

class PacmanAction:
    def __init__(self):
        self.packages = []

    def add_package(self, package):
        self.packages.append(package)

    def do(self):
        print(['pacman', '-S'] + self.packages)

class Box:
    def __init__(self):
        self.installed_pacman_packages = None
        self.pacman_action = None
        self.actions = []

    def commit(self):
        for action in self.actions:
            action.do()

    def always(self, command):
        action = ExecutableAction(command)
        self.actions.append(action)

    def executable(self, executable, command):
        import shutil

        found = shutil.which(executable)
        if not found:
            action = ExecutableAction(command)
            self.actions.append(action)

    def pacman(self, package):
        if self.installed_pacman_packages == None:
            output = self.stdout(['pacman', '-Q'])
            self.installed_pacman_packages = list(
                map(lambda line: line.split(' ')[0], output.split('\n'))
            )

        if not package in self.installed_pacman_packages:
            if self.pacman_action == None:
                self.pacman_action = PacmanAction()
                self.actions.append(self.pacman_action)

            self.pacman_action.add_package(package)

    def stdout(self, arguments):
        import subprocess
        return subprocess.check_output(arguments).decode('utf-8')

    def stderr(self, arguments):
        import subprocess
        process = subprocess.Popen(
            arguments,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        _, stderr = process.communicate()
        return stderr.decode('utf-8')

box = Box()

# Yaourt
box.executable(
    'yaourt',
    command="""
        git clone https://aur.archlinux.org/package-query.git
        cd package-query
        makepkg -si
        cd ..
        git clone https://aur.archlinux.org/yaourt.git
        cd yaourt
        makepkg -si
        cd ..
    """
)

# Upgrade
box.always('sudo pacman -Syu')
box.always('yaourt --noconfirm -Syua')

# Dependencies
box.pacman('git')
box.pacman('curl')
box.pacman('wget')
box.pacman('make')
box.pacman('openssh')
box.pacman('bash-completion')
box.pacman('sl')
box.pacman('hello')

# Databases

# fix this after_install

box.pacman(
        'postgresql'
        # after_install="""
        #   sudo su postgres -c "initdb --locale $LANG -E UTF8 -D /var/lib/postgres/data"
        #   sudo systemctl start postgresql.service
        #   sudo systemctl enable postgresql.service
        #   sudo su postgres -c "createuser -s $USER"
        # """
        )
box.pacman('redis')

# Languages
# box.yaourt('nvm')

# YAOURT SHOULD NEVER DO AN OUTDATED CHECK, BECAUSE yaourt should always ALWAYS
# do a full upgrade. Same as pacman.
box.commit()
