#!/usr/bin/env bash

container_manager="autodetect"
# We depend on a container manager let's be sure we have it
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
image=$(tr '[:upper:]' '[:lower:]' <<<"$2")
# if no image is selected default to nix image
if [[ $image == "" ]]; then
  image=nixos/nix
fi

case $opt in
-v)
  echo "version 1.0"
  ;;
-t) 
  echo "Temporary $image container with no mounts" 
  ${container_manager} run -it --rm $image
  ;;
-h)
  echo "Temporary $image container with /home/$(id -u -n) mounted inside /home/$(id -u -n)"
  ${container_manager} run -it --rm --mount type=bind,source=/home/$(id -u -n),target=/home/$(id -u -n) $image
  ;;
-p)
  echo "Temporary $image container with $(pwd) mounted inside /work"
  ${container_manager} run -it --rm --mount type=bind,source=$(pwd),target=/work $image
  ;;
"")
  echo "Temporary $image container with $(pwd) mounted inside /work"
  ${container_manager} run -it --rm --mount type=bind,source=$(pwd),target=/work $image
  ;;
*)
  echo "$opt is not a valid option"
  echo ""
  echo "included options are:"
  echo "----------------------------------------------------------------------"
  echo "-t [IMAGE NAME]"
  echo "This will enter a Temporary container with no mounts"
  echo "----------------------------------------------------------------------"
  echo "-h [IMAGE NAME]"
  echo "This will enter a Temporary container with /home/$(id -u -n) mounted"
  echo "inside /home/$(id -u -n)"
  echo "----------------------------------------------------------------------"
  echo "-p [IMAGE NAME]"
  echo "This will enter a Temporary container"
  echo "with $(pwd) mounted inside /work"
  echo "----------------------------------------------------------------------"
  echo "-v will give you the current version"
  echo "----------------------------------------------------------------------"
  echo ""
  echo "The defualt (no option) will enter a Temporary nix container"
  echo "with $(pwd) mounted inside /work"
  echo "----------------------------------------------------------------------"
  ;;
esac
