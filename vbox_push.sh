show_help() {
  echo "usage: vbox_push.sh src [dest]"
  exit
}

. ./help.sh $# 0 show_help

file_src=$1

if [ $# -gt 1 ]
  then
    file_dst=$2
  else
    file_dst="./"
fi

QEMU_PORT=$(cat .VBOX_SSH_PORT)
Q__SSH_OPTS="-o StrictHostKeyChecking=no"
(sshpass -P password -p alpine rsync --human-readable --inplace --perms --hard-links -r --progress -e "ssh $Q__SSH_OPTS -p $QEMU_PORT" "$file_src" "alpine@localhost:$file_dst" 2>&1) | cat
