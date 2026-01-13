# container

## memory usage

Supporting services to start container run uses 120M:

```
procs --insert rss /opt/homebrew/Cellar/container -o "container run" -o containermanagerd --only rss | grep -o '[0-9.]\+' | paste -sd+ - | bc
```

Memory usage of VM running `apt-get update` inside interactive ubuntu:22.04 container is 34M:

```
procs --insert rss VirtualMachine
```

## vs docker

Supporting services to start docker run uses 930M:

```
procs --insert rss --only rss docker | grep -o '[0-9.]\+' | paste -sd+ - | bc
```

Memory usage of VM running `apt-get update` inside interactive ubuntu:22.04 container is 424M:

```
procs --insert rss VirtualMachine
```
