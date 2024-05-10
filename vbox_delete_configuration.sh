if [[ ! -e /c/Program\ Files/Oracle/VirtualBox ]] ; then
    echo "VirtualBox not installed at C:\\Program Files\\Oracle\\VirtualBox"
    exit 1
fi

export PATH="/c/Program Files/Oracle/VirtualBox:$PATH"

if vboxmanage list vms | grep -q "XServer-Alpine" ; then
	vboxmanage unregistervm "XServer-Alpine" --delete-all
    echo "Virtual machine 'XServer-Alpine' is unregistered and destroyed."
fi
