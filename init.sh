if [ -f "/home/worker/.bee" ]; then
  TARGET="brew"
  echo "Install DEV Env with LinuxBrew"
else
  TARGET="native"
  echo "Install DEV Env on Linux"
fi
./install_package.sh $TARGET
./install_plugin.sh
