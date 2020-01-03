RATFLOW
=======

This is ratflow-core extension pack. If you are new to the Ratflow
concept, please read the [ratflow-core](https://github.com/ratflow/ratflow-core) README file.

Apps & tools
----

This package extends Ratflow core components so it can be installed
as complete desktop environment. The default configuration profile
will be extended by new key bindings. Additional apps and tools are:

* sddm - display manager with "slice" greeter theme.

* pcmanfm - light file manager.

* file-roller - archive manager.

* leafpad - simple notepad.

* git-aware-prompt - bash profile modification that displays current
GIT branch in terminal prompt.

* keepassx - password manager and passphrase generator.

* clipit - clipboard manager.

* network-manager-gnome - Ubuntu network manager with system tray icon.

* redshift - display color temperature correction tool.

* screengrab - default screenshot tool.

All original configuration files will be backuped as single copy
with timestamp suffix.

Installation
------------

If you are new to i3wm, please start by reading i3 configuration 
reference and the contents of 
`system/usr/share/ratflow/default/config.d/` files.

Debian/Ubuntu users can try our APT repository as described below. 

Be aware that the ratflow-desktop package will install and reconfigure
SDDM display manager!
  

Ubuntu 18.04 (Bionic Beaver):

```sh
wget -O - http://apt.nixlab.in/public.gpg.key | sudo apt-key add - 
echo "deb http://apt.nixlab.in/ bionic main" | sudo tee /etc/apt/sources.list.d/apt.nixlab.in.list

sudo apt-get update
sudo apt-get install ratflow-desktop
```

Enjoy!

