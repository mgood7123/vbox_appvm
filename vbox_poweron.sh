if [[ ! -e /c/Program\ Files/Oracle/VirtualBox ]] ; then
    echo "VirtualBox not installed at C:\\Program Files\\Oracle\\VirtualBox"
    exit 1
fi

export PATH="/c/Program Files/Oracle/VirtualBox:$PATH"

vbox_boot_linux__func() {
	echo "booting linux..."
	./vbox_start.sh
	echo "booted linux"
	./vbox_wait_for_ssh_connect.sh
}

if vboxmanage list vms | grep -q "XServer-Alpine" ; then
    vbox_boot_linux__func
  else
    ./vbox_create_configuration.sh
	vbox_boot_linux__func
fi

