### Install docker-color-output
```
wget 
```


### Install docker-color-output
```
cp docker-color-output-linux-amd64 /usr/local/bin/docker-color-ouput
chmod +x /usr/local/bin/docker-color-ouput
```

### Create docker color commands
```
cp dockercolor_aliases.sh ~/.docker_color_settings
```

### Add docker color commads to ~/.bashrc
```
if [ -f ~/.docker_color_settings ]; then
    . ~/.docker_color_settings
fi
```