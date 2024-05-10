if [[ ! -e /c/Program\ Files/Oracle/VirtualBox ]] ; then
    echo "VirtualBox not installed at C:\\Program Files\\Oracle\\VirtualBox"
    exit 1
fi

../vcxserv/vcxsrv.exe ":987" -multiwindow -hostintitle -ignoreinput -compositewm -compositealpha -lesspointer -wgl +extension GLX +extension RENDER +extension COMPOSITE +extension DOUBLE-BUFFER +extension X-Resource +extension DAMAGE +extension SHAPE +extension XFIXES +extension XTEST +extension SECURITY +extension RANDR +extension DPMS +extension XFree86-BigFont +bs +byteswappedclients +iglx &
XSERV_PID=$!
echo "$XSERV_PID" > .XSERV_PID
../vcxserv/xauth add 127.0.0.1:987 . $(mcookie)
DISPLAY=127.0.0.1:987 ./vbox_exe_i.sh bash -c "export LIBGL_ALWAYS_INDIRECT=1 ; bash"
