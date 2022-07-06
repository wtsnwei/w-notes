vagrant() {
  if [[ $1 == "ssh" ]]; then
    BOX=default
    if [[ ! -z "$2" ]]; then
      BOX=$2
    fi
    command vagrant ssh-config > vagrant-ssh-config && ssh -A -F vagrant-ssh-config $BOX
  else
    command vagrant "$@"
  fi
}