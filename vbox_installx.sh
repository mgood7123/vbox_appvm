./vbox_exe_i.sh "sudo apk add mesa-demos mesa-dri-gallium xorg-server musl-locales udev xterm font-terminus"
./vbox_exe_i.sh "sudo apk add xf86-video-fbdev xf86-video-intel xf86-video-nouveau xf86-video-vesa xf86-video-amdgpu xf86-video-nv xf86-video-vmware"
./vbox_exe_i.sh "sudo apk add xf86-input-evdev xf86-input-libinput xf86-input-mtrack xf86-input-synaptics xf86-input-vmmouse xf86-input-wacom"
./vbox_exe_i.sh "sudo rc-update add udev ; sudo rc-update add udev-postmount ; sudo rc-update add udev-trigger ; sudo rc-update add udev-settle"
./vbox_exe_i.sh "sudo adduser root input ; sudo adduser alpine input"
./vbox_reboot.sh
./vbox_exe_i.sh "sudo X -configure ; sudo mv /root/xorg.conf.new /usr/share/X11/xorg.conf.d/alpine.conf -v"
./vbox_exe_i.sh "sudo apk add fluxbox"
./vbox_exe_i.sh "sudo bash -c \"export LIBGL_ALWAYS_INDIRECT=1; startx /usr/bin/fluxbox\""
./vbox_exe_i.sh
