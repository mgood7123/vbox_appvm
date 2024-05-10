if [[ ! -e /c/Program\ Files/Oracle/VirtualBox ]] ; then
    echo "VirtualBox not installed at C:\\Program Files\\Oracle\\VirtualBox"
    exit 1
fi

export PATH="/c/Program Files/Oracle/VirtualBox:$PATH"

vboxmanage createmedium disk --size=102800 --format=VDI --variant=standard --filename $(pwd)/linux.vdi
