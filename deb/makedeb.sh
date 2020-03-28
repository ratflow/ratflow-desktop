#!/bin/bash
## $SCRIPT_NAME v$SCRIPT_VERSION
##
## Create ratflow deb package
##
## Usage: $SCRIPT_FILENAME [options]
##
## Options:
##   -s, --system <name>       System name
##   -a, --arch <arch>         System architecture (auto if not provided)
##   -h, --help    	       Display this message.
##   -v, --version 	       Display script version.
##

#===========================================


SCRIPT_NAME=makedeb
SCRIPT_FILENAME=$(basename "$0")
SCRIPT_VERSION=0.1.0
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -e          # exit on command errors (so you MUST handle exit codes properly!)
set -o pipefail # capture fail exit codes in piped commands
#set -x         # execution tracing debug messages

#===========================================


function usage {
  [ "$*" ] && echo "$0: $*"
  sed -n '/^##/,/^$/s/^## \{0,1\}//p' "$SCRIPT_DIR/$SCRIPT_FILENAME" |
      sed "s/\$SCRIPT_NAME/$SCRIPT_NAME/g" |
      sed "s/\$SCRIPT_FILENAME/$SCRIPT_FILENAME/g" |
      sed "s/\$SCRIPT_VERSION/$SCRIPT_VERSION/g"
      
  exit 2
} 2>/dev/null


targetSystem=''
debSubdir=''
cacheDir="$SCRIPT_DIR/cache-`date +%s`"
repoDir="$SCRIPT_DIR/.."
rootSrcDir="$repoDir/system"
pkgArchitecture=$(dpkg --print-architecture)

function main {

    if [ $# -eq 0 ]; then
	usage;
    fi
    
    while [ $# -gt 0 ]; do
	case $1 in
	    ('-h'|'--help')
		usage 2>&1;;
            ('-v'|'--version')
                echo "$SCRIPT_NAME v$SCRIPT_VERSION"
                exit 0;;
	    ('-s'|'--system')
		shift
		if [ $# -eq 0 ]; then
		    usage;
		fi
		targetSystem="$1";;
	    ('-a'|'--arch')
		shift
		pkgArchitecture="$1";;
	    ('--')
		shift
		break;;
	    ('-'*)
		echo -e "\n$0 $1: unknown option. Use --help to learn more.\n"
		exit 3
		break;;
	esac
	
	shift
    done

    run
}

#===========================================


function run {
    debSubdir="$SCRIPT_DIR/$targetSystem"
    
    if [ ! -d "$debSubdir" ]; then
	echo "Directory not found: $debSubdir"
	exit 1
    fi
	
    initializeCache
    createPackage
    cleanCache
}

function initializeCache {

    echo "Creating cache"
    
    mkdir -p "$cacheDir"
    pushd "$cacheDir"
    echo "#!/bin/bash

cp -r \"$rootSrcDir/\"* /

    " >> install.sh
    chmod +x install.sh
    popd
}

function createPackage {
    echo "Creating package"

    cp common/description-pak "$cacheDir/"
    cp common/postinstall-pak "$cacheDir/"
    . config
    pushd "$cacheDir"

    checkinstall \
	--install=no \
	--fstrans=yes \
	--requires="`cat $debSubdir/requires`" \
	--conflicts="`cat $debSubdir/conflicts`" \
	--replaces="`cat $debSubdir/replaces`" \
	--pkgversion=$pkgVersion \
	--pkgsource="$pkgSource" \
	--pkgname=$project \
	--pkglicense=$license \
	--maintainer="$maintainer" \
	--pkgarch=$pkgArchitecture \
	--deldesc=no \
	--nodoc \
	--pakdir=.. \
	./install.sh

    popd
}

function cleanCache {
    echo "Cleaning cache"
    rm -r "$cacheDir"
}



#===========================================

main "$@"
 
