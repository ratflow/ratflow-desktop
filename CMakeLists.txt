cmake_minimum_required(VERSION 3.1.0)

##############################################
########## GENERAL PROJECT SETTINGS ##########
##############################################

project ( ratflow-desktop NONE )
set( VERSION_MAJOR 1 )
set( VERSION_MINOR 0 )
set( VERSION_PATCH 16 )


##############################################



##############################################
################# INSTALLATION ###############
##############################################


set( CMAKE_PROJECT_NAME ratflow-desktop )

###### GET SYSTEM RELEASE ######
set (EXECUTE_COMMAND lsb_release -rs)
execute_process(COMMAND ${EXECUTE_COMMAND} OUTPUT_VARIABLE system_release_raw)

###### REMOVE ENDLINE FROM SYSTEM RELEASE ######
string(LENGTH ${system_release_raw} len)
math(EXPR length "${len} - 1")
string(SUBSTRING ${system_release_raw} 0 ${length} SYSTEM_RELEASE)

###### GET SYSTEM NAME ######
set (EXECUTE_COMMAND lsb_release -cs)
execute_process(COMMAND ${EXECUTE_COMMAND} OUTPUT_VARIABLE system_name_raw)

###### REMOVE ENDLINE FROM SYSTEM NAME ######
string(LENGTH ${system_name_raw} len)
math(EXPR length "${len} - 1")
string(SUBSTRING ${system_name_raw} 0 ${length} SYSTEM_NAME)


###### GENERAL VARIABLES ######
SET(CMAKE_SYSTEM_NAME "${SYSTEM_NAME}-${SYSTEM_RELEASE}")


###### INSTALLATION PATHS ######

SET(MAIN_INSTALLATION_DIR "/usr/share/ratflow")


INSTALL(
  DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/system/etc/
  DESTINATION /etc/
)

INSTALL(
  DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/system/usr/
  DESTINATION /usr/
)

INSTALL(
  PROGRAMS ${CMAKE_CURRENT_SOURCE_DIR}/system/usr/bin/ratflow-session
  DESTINATION /usr/bin/
)

INSTALL(
  PROGRAMS ${CMAKE_CURRENT_SOURCE_DIR}/system/usr/local/bin/translate-shell
  DESTINATION /usr/local/bin/
)

###### CPACK DEB PACKAGE SETTINGS ######

IF(EXISTS "${CMAKE_ROOT}/Modules/CPack.cmake")
INCLUDE(InstallRequiredSystemLibraries)

SET(CPACK_GENERATOR "DEB")
SET(CPACK_SET_DESTDIR "on")

SET(CPACK_PACKAGE_DESCRIPTION "")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "RATFLOW desktop environment")
SET(CPACK_PACKAGE_VENDOR "Łukasz Chodyła")
SET(CPACK_PACKAGE_CONTACT ${CPACK_PACKAGE_VENDOR})
SET(CPACK_DEBIAN_PACKAGE_DEPENDS "lightdm, lightdm-gtk-greeter-settings, i3 (>= 4.10), i3blocks (>= 1.4), compton, rofi (>= 0.15), pcmanfm, file-roller, leafpad, x11-xserver-utils, git-aware-prompt, lxappearance, terminator, keepassx, clipit, network-manager-gnome, feh, redshift, xserver-xorg-input-synaptics, gsimplecal, screengrab, libnotify-bin, gawk, dunst")
SET(CPACK_DEBIAN_PACKAGE_REPLACES "lightdm-gtk-greeter")
SET(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
SET(CPACK_DEBIAN_PACKAGE_SECTION "ratflow")

SET(CPACK_PACKAGE_VERSION_MAJOR "${VERSION_MAJOR}")
SET(CPACK_PACKAGE_VERSION_MINOR "${VERSION_MINOR}")
SET(CPACK_PACKAGE_VERSION_PATCH "${VERSION_PATCH}-${CMAKE_SYSTEM_NAME}")
#SET(CPACK_DEBIAN_ARCHITECTURE ${CMAKE_SYSTEM_PROCESSOR})
SET(CPACK_DEBIAN_ARCHITECTURE "generic")

SET(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}_${VERSION_MAJOR}.${VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}_${CPACK_DEBIAN_ARCHITECTURE}")
SET(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_FILE_NAME}")

SET(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_SOURCE_DIR}/deb/preinst;${CMAKE_SOURCE_DIR}/deb/postinst;${CMAKE_SOURCE_DIR}/deb/prerm;${CMAKE_SOURCE_DIR}/deb/postrm;")

#
# more:
# https://cmake.org/cmake/help/v3.3/module/CPackDeb.html
# https://cmake.org/Wiki/CMake:Packaging_With_CPack
#


#SET(CPACK_COMPONENTS_ALL Libraries ApplicationData)
#set(CPACK_COMPONENTS_ALL_IN_ONE_PACKAGE 1)

INCLUDE(CPack)


ENDIF(EXISTS "${CMAKE_ROOT}/Modules/CPack.cmake")




