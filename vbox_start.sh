if [[ ! -e /c/Program\ Files/Oracle/VirtualBox ]] ; then
    echo "VirtualBox not installed at C:\\Program Files\\Oracle\\VirtualBox"
    exit 1
fi

export PATH="/c/Program Files/Oracle/VirtualBox:$PATH"

if vboxmanage list runningvms | grep -q "XServer-Alpine" ; then
	echo "XServer-Alpine is already running"
else
    VBOX_SSH_PORT=$(python -c "import socket; s = socket.socket(); s.bind(('', 0)); print(s.getsockname()[1]); s.close();")
    echo "$VBOX_SSH_PORT" > .VBOX_SSH_PORT

    vboxmanage modifyvm "XServer-Alpine" --memory=512 # 256 mb
    #vboxmanage modifyvm "XServer-Alpine" --memory=2560 # 256 mb
    vboxmanage modifyvm "XServer-Alpine" --vram=128 # most graphics cards probably have [ vram >= 128 ] mb of vram
    vboxmanage modifyvm "XServer-Alpine" --cpus=$(nproc)
    vboxmanage modifyvm "XServer-Alpine" --natpf1 delete "ssh-forwarding" >/dev/null 2>&1
    vboxmanage modifyvm "XServer-Alpine" --natpf1 "ssh-forwarding,tcp,,$VBOX_SSH_PORT,,22"
    vboxmanage modifyvm "XServer-Alpine" --accelerate-3d=on # requires Guest Additions to be installed
    vboxmanage modifyvm "XServer-Alpine" --accelerate-2d-video=on # requires Guest Additions to be installed
    vboxmanage modifyvm "XServer-Alpine" --clipboard-mode=bidirectional
    vboxmanage modifyvm "XServer-Alpine" --drag-and-drop=bidirectional
    vboxmanage setextradata "XServer-Alpine" GUI/DefaultCloseAction "Shutdown"
    vboxmanage setextradata "XServer-Alpine" GUI/MenuBar/Enabled "false"
    vboxmanage setextradata "XServer-Alpine" GUI/StatusBar/Enabled "false"
    vboxmanage setextradata "XServer-Alpine" GUI/AutoresizeGuest "true"
    vboxmanage setextradata global GUI/Input/AutoCapture "false"
    vboxmanage storagectl "XServer-Alpine" --name "IDE Controller" --add ide >/dev/null 2>&1
    vboxmanage storageattach "XServer-Alpine" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "C:\\Program Files\\Oracle\\VirtualBox\\VBoxGuestAdditions.iso" >/dev/null 2>&1
    #vboxmanage storageattach "XServer-Alpine" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium $(pwd)/linux.iso
    vboxmanage modifyvm "XServer-Alpine" --boot1=disk # hdd
    #vboxmanage modifyvm "XServer-Alpine" --boot2=none # no cdrom
    #vboxmanage modifyvm "XServer-Alpine" --boot2=dvd # cdrom
    vboxmanage startvm "XServer-Alpine" --type=gui
fi
