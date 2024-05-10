function cleanup {
  kill $SSH_AGENT_PID
}

eval $(ssh-agent) > /dev/null
trap cleanup EXIT

sshpass -p alpine -P passphrase ssh-add ssh_key 2> /dev/null

show_quoted() {
  (
    PS4='+'    # reset to default
    exec 2>&1  # send xtrace to stdout
    set -x
    true "$@"
  ) | sed 's/^+*true //'  # remove the xtrace prefix
}

QEMU_PORT=$(cat .VBOX_SSH_PORT)
Q__SSH_OPTS="-o StrictHostKeyChecking=no -o ForwardX11=yes -o ForwardX11Timeout=0 -o ForwardX11Trusted=yes -o XAuthLocation=$(cd ../vcxserv ; pwd)/xauth.exe"
if [ $# -eq 0 ]
  then
    (ssh -q $Q__SSH_OPTS -p $QEMU_PORT alpine@localhost -t bash -i 2>&1) | cat
  else
    (ssh -q $Q__SSH_OPTS -p $QEMU_PORT alpine@localhost -t bash -i -c "$(show_quoted "$@")" 2>&1) | cat
fi
