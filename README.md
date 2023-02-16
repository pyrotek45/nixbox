# nixbox

simple docker wrapper for nix container.

# How to use

simply type
```
nixbox
```

to get started. without any options, the default behavior will create a temporary container with your
current workin directory mounted in a folder called work. the container will be of a nixos image.

other options are

```
nixbox -t
```

-t will enter a container with no mounts.

```
nixbox -p
```

-p this is the default behavior, this will open a container with the current working directory in a folder called work.


```
nixbox -h
```

-h this will open a container with the home mounted inside the container.

# Other images

the default image is nixos, but you can use any image from docker.

```
nixbox -t ubuntu
```

give it a shot!

