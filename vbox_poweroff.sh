if [[ ! -e /c/Program\ Files/Oracle/VirtualBox ]] ; then
    echo "VirtualBox not installed at C:\\Program Files\\Oracle\\VirtualBox"
    exit 1
fi

echo "sending poweroff..."
./vbox_exe.sh "sudo poweroff"
echo "sent poweroff"

./vbox_wait_for_ssh_disconnect.sh

echo "waiting for vbox process to exit..."
while /c/Program\ Files/Oracle/VirtualBox/vboxmanage list runningvms | grep -q "XServer-Alpine" ; do sleep 1; done;
sleep 2
echo "vbox process has exited"
rm .VBOX_SSH_PORT
unset VBOX_SSH_PORT
