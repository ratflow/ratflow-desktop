RATFLOW
=======

If you are looking for an easy, intuitive, eye-candy and friendly 
desktop environment - get out and look elsewhere. 

The ratflow project is a set of applications, configs, scripts and 
key bindings that have been developed over the years by a bunch of 
co-workers to do things faster. We would like to share the base of
our setup (or as some may call it - desktop environment) in hope 
that it will make your work easier.

The idea is to learn before use. Spend some time setting up your
battle station, find what suits you best and perform common actions
by reflex. Learn your paths and go with the flow.

Workspaces
----------

We use i3 as window manager. Please see http://i3wm.org to learn
more about the goals and features. The idea is to cover all your
screen with tiles (windows). Tiles are organized in categorized
workspaces. So no, there is no "application bar". You can setup
it as you wish, but our initial workspaces are:

1. terminal emulators,
2. developer tools,
3. web browsers,
4. file managers,
5. e-mail clients,
6. instant messengers,
7. video players,
8. free workspace,
9. free workspace,
10. music players,
11. virtual machines.

Newly created windows will be automatically assigned to these
workspaces based on the rules from configuration file.

All these workspaces are accessible by single key binding. From
#1 to #9 it's mod key + 1-9, for #10 it's mod key + 0 and for #11
it's mod key + alt + v.


Configuration file
------------------

The configuration file is located in ~/.config/ratflow/config. 
This is i3 configuration file. Read more about i3 configuration 
at http://i3wm.org/docs/userguide.html

Apps & tools
----

Here's the initial set of applications that comes with ratflow
installation package. Most of them are used in the default 
configuration file, so even though they are not mandatory, we 
recommend to install them in order to use all key bindings and 
services.

* sddm - display manager with "slice" greeter theme.

* terminator - default terminal emulator that also comes with our
"ratflow-terminator" configuration profile.

* compton - composite manager.

* dmenu-extended - application launcher.

* pcmanfm - light file manager.

* file-roller - archive manager.

* leafpad - simple notepad.

* git-aware-prompt - bash profile modification that displays current
GIT branch in terminal prompt.

* keepassx - password manager and passphrase generator.

* clipit - clipboard manager.

* network-manager-gnome - Ubuntu network manager with system tray icon.

* feh - image viewer used to setup wallpaper images.

* redshift - display color temperature correction tool.

* gsimplecal - simple calendar with UI.

* screengrab - default screenshot tool.

* dunst - notification service.

* yadiff - terminal side-by-side file comparison tool

All original configuration files will be backuped as single copy
with timestamp suffix. Note that some of the apps above are going to 
be replaced by other, more suitable ones. 


Installation
------------

If you are new to i3wm, please start by reading i3 configuration 
reference and the contents of system/usr/share/ratflow/configs/config.

You may want to go through the ratflow config file and setup all
applications manually according to key bindings and autostart section.
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

