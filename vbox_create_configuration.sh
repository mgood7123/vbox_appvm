if [[ ! -e /c/Program\ Files/Oracle/VirtualBox ]] ; then
    echo "VirtualBox not installed at C:\\Program Files\\Oracle\\VirtualBox"
    exit 1
fi

export PATH="/c/Program Files/Oracle/VirtualBox:$PATH"

if [[ ! -e linux.iso ]] ; then
    curl -L https://mirrors.edge.kernel.org/archlinux/iso/2024.05.01/archlinux-x86_64.iso -o linux.iso
fi

if vboxmanage list vms | grep -q "XServer-Alpine" ; then
    echo "xserver exists"
else
    echo "xserver does not exist, creating configuration"
    echo "starting VirtualBox"
    virtualbox &
    VBOX_PID=$!
    sleep 1
    echo "VirtualBox started"

    vboxmanage createvm --name="XServer-Alpine" --register --ostype="Linux_64"

    vboxmanage modifyvm "XServer-Alpine" --acpi=on
    vboxmanage modifyvm "XServer-Alpine" --ioapic=on
#    vboxmanage modifyvm "XServer-Alpine" --hwvirtex=on # enable [ Intel VT-x | AMD-V ] hardware virtualization extensions
#    vboxmanage modifyvm "XServer-Alpine" --nested-paging=on # enable Nested Paging (requires hardware virtualization extensions)
#    vboxmanage modifyvm "XServer-Alpine" --paravirt-provider=kvm # we target linux which can use kvm virtualization
#    vboxmanage modifyvm "XServer-Alpine" --large-pages=on # requires Nested Paging
#    vboxmanage modifyvm "XServer-Alpine" --nested-hw-virt=on # enable Nested virtualization

    vboxmanage modifyvm "XServer-Alpine" --bios-logo-fade-in=off
    vboxmanage modifyvm "XServer-Alpine" --bios-logo-fade-out=off
    vboxmanage modifyvm "XServer-Alpine" --bios-logo-display-time=0

    vboxmanage modifyvm "XServer-Alpine" --boot1=disk # hdd
    #vboxmanage modifyvm "XServer-Alpine" --boot2=dvd # cdrom
    vboxmanage modifyvm "XServer-Alpine" --boot2=none # no cdrom
    vboxmanage modifyvm "XServer-Alpine" --boot3=none # no floppy boot
    vboxmanage modifyvm "XServer-Alpine" --boot4=none # no net boot
    vboxmanage modifyvm "XServer-Alpine" --firmware=bios # legacy OS's use BIOS and do not know about UEFI
    vboxmanage modifyvm "XServer-Alpine" --firmware=efi # modern OS's use UEFI by default
    vboxmanage modifyvm "XServer-Alpine" --nic1=nat
    vboxmanage modifyvm "XServer-Alpine" --audio-enabled=on
    vboxmanage modifyvm "XServer-Alpine" --audio-in=off
    vboxmanage modifyvm "XServer-Alpine" --audio-out=on
    vboxmanage modifyvm "XServer-Alpine" --graphicscontroller=vmsvga

    if [[ ! -e linux.vdi ]] ; then
        ./vbox_create_image.sh
    fi

    vboxmanage storagectl "XServer-Alpine" --name "SATA Controller" --add sata --controller IntelAHCI --portcount=1 --hostiocache=on --bootable=on
    vboxmanage storageattach "XServer-Alpine" --storagectl "SATA Controller" --port 0 --device 0 --discard=on --type hdd --medium $(pwd)/linux.vdi

    #vboxmanage storagectl "XServer-Alpine" --name "IDE Controller" --add ide
    #vboxmanage storageattach "XServer-Alpine" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium $(pwd)/linux.iso
    echo "configuration created for xserver"
    echo "closing VirtualBox"
    kill $VBOX_PID
fi
