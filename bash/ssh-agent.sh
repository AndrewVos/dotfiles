if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
fi
