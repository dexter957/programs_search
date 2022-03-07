#!/bin/bash


# ----  Functions  ----

#Get the distro function
getDistro()
{
  local os
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    os=$ID_LIKE
  fi
  echo $os
}

getCommand()
{
  local command
  local distro=$1
  case $distro in
    arch)
      command="pacman -Q"
      ;;
    debian)
      command="dpkg -l"
      ;;
    *)
      :
      ;;
  esac
  echo $command
}

# ----  Script Logic  ----

#First check if the user has supplied the script with the search argument
if [ -z $1 ]; then
  echo "Please supply a search argument"
  exit
fi

#Get the distro
OS=$(getDistro)

#Get the command
COMMAND=$(getCommand $OS)

#Now issue the appropriate for your distro command, to list your installed programs
echo "Programs like \"${1}\": "
if [ "$COMMAND" ]; then
  #First list official packages:
  eval "$COMMAND | grep $1"
fi


#Now we attempt searching user files:
#/usr/bin
USR_PATH="/usr/local/bin"
find "$USR_PATH" -type f -executable | grep "$1"


