
## Ratflow desktop
![](https://github.com/ratflow/ratflow-desktop/raw/ratflow-desktop-1.1.x/img/rf_logo.jpg)

 1. [Introduction](#intro)
 1. [Tile up!](#tiles)
 1. [Overcoming i3 limitations](#i3limit)
    1. [Enhanced configuration](#config)
    1. [Profiles](#profiles)
 1. [Ratflow core](#ratflow-core)
 1. [Ratflow look](#ratflow-look)
 1. [Ratflow desktop](#ratflow-desktop)
 1. [The "classic" profile](#classic-profile)
    1. [Workspaces](#workspaces)
    1. [Autoapp](#autoapp)
    1. [Preserve floating state](#floating)
    1. [Key bindings](#bindings)
 1. [Installation](#installation)

<a name="intro"></a>
## Introduction

The Ratflow project is a set of scripts, applications, configs and key bindings that have been used and developed over past years by a bunch of co-workers to do things faster. We would like to share our setup (or as some people may call it - desktop environment) in hope that it will make your work easier.

The idea is to learn before use. Spend some time setting up your battle station, find what suits you best and perform common actions by reflex. Learn your paths and go with the flow.

<a name="tiles"></a>
## Tile up!
We use i3 as window manager. Please see http://i3wm.org to learn more about the goals and features. We also encourage you to watch the excellent Code Cast introduction [here](https://youtu.be/j1I63wGcvU4).

The idea is to cover your whole screen with tiles (windows). Tiles are organized in categorized workspaces. So no, there is no "application bar". You can set it up as you like, nevertheless our package contains the default set described in the "workspaces" section.

<a name="i3limit"></a>
## Overcoming i3 limitations
The i3 window manager uses single config file (usually `~/.config/i3/config`). Unfortunately, there is no way to include another config file or whole directory, but this is where Ratflow comes in.

<a name="config"></a>
### Enhanced configuration

The desktop configuration is read from **multiple files** stored in `config.d` directory. Each file named `<nn>-<config name>`, where `<nn>` is ordering number, will be used as a part of final i3 configuration file - just use the `rfreload` command to reload the configuration. This way you can add or remove key bindings, themes, default applications etc. Try to separate concerns and look at these files as if they were plug-ins, for example:

```
├── config.d
│   ├── 01-global-variables
│   ├── 10-base-workspaces
│   ├── 11-displays
│   ├── 13-wallpaper
│   ├── 20-touchpad
│   ├── 20-keys-wm-navigation
│   ├── 21-keys-multimedia
│   ├── 30-theme-dark-olive
│   ├── 31-conky-bar-dark
│   ├── 90-autostart
```

After you run:

```sh
rfreload
```

the configuration file will be generated in `~/.config/ratflow/config`. Obviously you **shouldn't edit this file**, but you can still use it for diagnostic purposes, especially since `rfreload` will leave notes on the origin of each part.

There is more: inside your configuration files you can now use `${{<command>}}` syntax to run **shell commands** and use their output as a part of configuration file. For example, the `11-displays` configuration file may contain such a snippet:

```sh
set $leftOutput ${{xrandr | grep ' connected' | awk 'NR==1{print $1}'}}
set $rightOutput ${{xrandr | grep ' connected' | awk 'NR==2{print $1}'}}

exec xrandr --output $rightOutput --primary
exec xrandr --output $leftOutput --left-of $rightOutput
```

You can also mute the output and hook some operations to (re)load action. Any subsequent file can be included by simply printing all or part of it:

```
${{cat ~/my_configs/clementine-key-bindings}}
```


<a name="profiles"></a>
### Profiles

The actual location of `config.d` directory is `~/.config/ratflow/profiles/<profile name>/config.d`. It means that it belongs to its profile and you can easily switch between profiles by calling `rfreload --p` or `rfreload --profile` command with a name of the profile you are willing to switch to. For example:

```
rfreload -p john-home-dark
rfreload --profile work-vertical-screen
```

It will just create a symbolic link leading to your profile in `~/.config/ratflow/profiles/current`. Partial configuration files can also be symbolic links leading to some base profile in order to avoid redundancy. If you want more information about your current profile, use:

```
rfreload -i
```


See `rfreload --help` to learn more.

<a name="ratflow-core"></a>
## Ratflow core

The [ratflow-core](https://github.com/ratflow/ratflow-core) package provides `rfreload` script, session initialization mechanism and basic dependencies.

When `/usr/bin/ratflow-desktop` is executed for the first time by specific user (most likely by a login manager such as `SDDM` or `LightDM`), all scripts matching `<nn>-init-<name>` from `/usr/share/ratflow/init` will be executed in lexical order. This way any other package can extend initialization process without editing or replacing existing files.

Basic dependencies are:

* **i3** - tiling window manager,
* **i3blocks** - status line for i3bar that handles clicks, signals and language-agnostic user scripts,
* **x11-xserver-utils** - xrandr, xgamma, xhost etc,
* **feh** - fast, lightweight image viewer,
* **terminator** - terminal emulator,
* **libnotify-bin** - notification sender,
* **dunst** - lightweight notification-daemon,
* **yad** - tool for creating GUI dialogs (used for prompts).

<a name="ratflow-look"></a>
## Ratflow look

The ratflow-look package essentials are now back in ratflow-desktop, that is:

*  fonts,
*  GTK and Qt configurations (backups of all existing files will be made during session initialization),
*  extra Ratflow wallpapers.

<a name="ratflow-desktop"></a>
## Ratflow desktop
This package extends `ratflow-core` by adding  the `classic` profile, extra scripts and third-party applications.  The dependencies are:

* **pcmanfm** - extremely fast and lightweight file manager,
* **compton** - compositor for X11 (for transparency and fading),
* **py3status** - extensible i3status wrapper ([see more](https://py3status.readthedocs.io)) ,
* **osmo** - calendar and task manager,
* **ulauncher** - extensible application launcher,
* **file-roller** - archive manager,
* **howl** - lightweight and customizable general purpose text editor ([see more](https://howl.io)) ,
* **clipit/parcellite** - clipboard manager,
* **network-manager-gnome** - network manager,
* **redshift** - adjusts the color temperature of your screen,
* **screengrab** - crossplatform tool for getting screenshots.

<a name="classic-profile"></a>
## The "classic" profile
This is the default user profile that comes with `ratflow-desktop` package. As for now, profile directory looks like this:

```
classic/
├── autoapp.conf
├── config.d
│   ├── 01-variables
│   ├── 10-workspaces
│   ├── 11-outputs
│   ├── 13-wallpaper
│   ├── 20-keys-apps-core
│   ├── 20-keys-wm
│   ├── 21-always-float
│   ├── 21-keys-apps
│   ├── 21-keys-media
│   ├── 21-keys-session
│   ├── 21-new-workspace
│   ├── 30-theme
│   ├── 31-bar
│   ├── 40-assignments
│   ├── 50-floating
│   ├── 90-exec
│   ├── 91-exec_always
│   └── floating.d
│       ├── Osmo.float
│       ├── screengrab.float
│       └── Yad.float
└── py3status.conf
```

<a name="workspaces"></a>
### Workspaces

By default, workspaces are categorized as follows:

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

Newly created windows will be automatically assigned to these workspaces based on the rules contained in `config.d/40-assignments` file. New workspaces can also be created dynamically using `mod + n` binding.

All the above workspaces are accessible by single key binding. From #1 to #9 it's mod key + 1-9, for #10 it's mod key + 0.

<a name="autoapp"></a>
### Autoapp
Beyond "app to workspace" assignments one can assign generic key binding (`mod + shift + a` by default) to launch different application depending on the current workspace. For example, using `mod + shift + a` on workspace #4 (file manager) will run `pcmanfm`. The same key combination used on workspace #3 (www) may run firefox or vivaldi. The `autoapp` configuration file resides in profile directory and its default content is:

```
{
    "1": "terminator",
    "2": "qtcreator || eclipse || emacs ",
    "3": "firefox",
    "4": "pcmanfm",
    "5": "thunderbird",
    "6": "slack || telegram",
    "7": "kodi",
    "8": "howl || kate || gedit",
    "9": "howl || kate || gedit",
    "0": "clementine",
    "vm": "virtualbox || openxenmanager"
}

```

<a name="floating"></a>
### Preserve floating state
Any window can be put into floating state by `mod + lmb` binding. This won't, however, remember its floating state next time it appears. The "i3 way" would be to investigate X11 window class and edit the config file by adding new rule. As we can now use `rfreload` and its "plugins", all we have to do is to press `mod + shift + f`. This action will make focused window float and it will create `config.d/floating.d/<window class>.float` file with new i3 rule.

<a name="bindings"></a>
### Key bindings

Please see `config.d/<nn>-keys` files for more information on key bindings. Navigation bindings in most part matches default i3 configuration, but some other may come handy on the first touch:

* `mod + [1-9]` - switch current workspace,
* `mod + n` - shows text dialog and creates new workspace with given name,
* `mod + return` - open new terminal,
* `mod + shift + q` - close focused window,
* `mod + d`/`mod + F2` - open application launcher,
* `mod + shift + a` - use the autoapp script to run application assigned to the current workspace,
* `PrtSc` - take a screenshot,
* `control + PrtSc` - take a screenshot of focused window,
* `shift + PrtSc` - take a screenshot of selected area,
* `mod + t` - translate selected text to configured language (default: english to polish),
* `mod + shift + t` -  translate selected text to configured language (default: polish to english),
* `mod + control + PgUp` - increase screen color temperature,
* `mod + control + PgDown` - decrease screen color temperature,
* `mod + control + l` - reset screen color temperature,
* `mod + shift + c` - run `rfreload`,
* `mod + shift + r` - run `rfreload --restart` (restarts i3),
* `mod + c` - show calendar window,
* `mod + shift + f` - put focused window into permanent floating state,
* `mod + tab` - back and forth workspace switch,
* `alt + tab` - run window jumper.

<a name="installation"></a>
## Installation
If you are new to i3wm, please start by reading i3 configuration reference and the contents of
`system/usr/share/ratflow/default/config.d/` files. All you need is essentially to sync the `system` directories off `ratflow-core` and `ratflow-desktop` repositories with root directory of your system.

If you are into customization and you don't want most of the third-party apps in your system - use `ratflow-core` instead of `ratflow-desktop` and edit `core` user profile.

### Ubuntu/Debian packages

Debian/Ubuntu users can try our APT repository as described below. Packages for different distributions can be browsed [here](http://nixlab.in:12080/dists/)

Ubuntu 22.04 (Jammy Jellyfish):

```sh
echo 'deb [trusted=yes arch=all] http://nixlab.in:12080 jammy main' | sudo tee /etc/apt/sources.list.d/nixlab.list
sudo apt update
sudo apt install ratflow-desktop
```

Ubuntu 20.04 (Focal Fossa):

```sh
echo 'deb [trusted=yes arch=all] http://nixlab.in:12080 focal main' | sudo tee /etc/apt/sources.list.d/nixlab.list
sudo apt update
sudo apt install ratflow-desktop
```


### Manual installation

You can also just simply download [ratflow-core](http://github.com/ratflow/ratflow-core) and [ratflow-desktop](http://github.com/ratflow/ratflow-desktop) repositories and run `sudo make install` on both.


Enjoy!
