if [ -f "/home/worker/.bee" ]; then
  TARGET = "brew"
else
  TARGET = "native"
fi
./install_package.sh $TARGET
./install_plugin.sh
