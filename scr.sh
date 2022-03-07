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
echo "The os is ${OS}"

#Get the command
COMMAND=$(getCommand $OS)
#echo "The command to run is ${COMMAND}"

#Now issue the appropriate for your distro command, to list your installed programs
echo "Programs like \"${1}\": "
if [ "$COMMAND" ]; then
  #First list official packages:
  #echo "In official packages:"
  eval "$COMMAND | grep $1"
fi


#Now we attempt searching user files:
#/usr/bin
#echo "In user installation paths"
USR_PATH="/usr/local/bin"
#echo "Possible user path:${USR_PATH}"
find "$USR_PATH" -type f -executable | grep "$1"
