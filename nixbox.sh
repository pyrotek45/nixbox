#!/usr/bin/env bash

container_manager="autodetect"
# We depend on a container manager let's be sure we have it
# First we use podman, else docker
case "${container_manager}" in
autodetect)
  if command -v docker >/dev/null; then
    container_manager="docker"
  fi
  ;;
docker)
  container_manager="docker"
  ;;
*)
  printf >&2 "Invalid input %s.\n" "${container_manager}"
  printf >&2 "The available choices are: 'autodetect', 'docker'\n"
  ;;
esac

if ! command -v "${container_manager}" >/dev/null && [ "${dryrun}" -eq 0 ]; then
  # Error: we need docker.
  printf >&2 "Missing dependency: we need a container manager.\n"
  printf >&2 "Please install docker.\n"
  exit 127
fi

opt=$(tr '[:upper:]' '[:lower:]' <<<"$1")
case $opt in
-t)
  echo "Temporary container with no mounts"
  ${container_manager} run -it --rm nixos/nix:master
  ;;
-h)
  echo "Temporary container with /home/$(id -u -n) mounted inside /home/$(id -u -n)"
  ${container_manager} run -it --rm --mount type=bind,source=/home/$(id -u -n),target=/home/$(id -u -n) nixos/nix:master
  ;;
"")
  echo "Temporary container with $(pwd) mounted inside /work"
  ${container_manager} run -it --rm --mount type=bind,source=$(pwd),target=/work nixos/nix:master
  ;;
*)
  echo "$opt is not a valid option"
  echo ""
  echo "included options are:"
  echo "-t This will enter a Temporary container with no mounts"
  echo "-h This will enter a Temporary container with /home/$(id -u -n) mounted inside /home/$(id -u -n)"
  echo ""
  echo "The defualt (no option) will enter a Temporary container with $(pwd) mounted inside /work"
  ;;
esac
