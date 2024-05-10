if [[ ! -e /c/Program\ Files/Oracle/VirtualBox ]] ; then
    echo "VirtualBox not installed at C:\\Program Files\\Oracle\\VirtualBox"
    exit 1
fi

BOOTED="BOOTED"
echo "waiting for ssh connection to be terminated..."
while [ "$BOOTED" == "BOOTED" ]
  do
    BOOTED=$(./vbox_exe.sh "cat /BOOTED" | grep BOOTED)
done
echo "ssh connection terminated"
