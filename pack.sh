mkdir VirtualBox-7.0.18.split >/dev/null 2>&1 || true

cd VirtualBox-7.0.18.split

../split_exe/split.exe --split ../VirtualBox-7.0.18 --name VirtualBox-7.0.18 -r --size $((1024*1024*50)) -v
