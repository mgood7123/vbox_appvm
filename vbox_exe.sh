show_help() {
  echo "usage: vbox_exe.sh \"command [args]\""
  exit
}

. ./help.sh $# 0 show_help

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
(sshpass -P password -p alpine ssh $Q__SSH_OPTS -p $QEMU_PORT alpine@localhost bash -c "$(show_quoted "$@")" 2>&1) | cat
