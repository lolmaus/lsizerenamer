Renames all level-one subdirectories within a given directory, so that every subfolder's name contains its size.

Tested on a Linux system only.

Contains no checks and error tracking. :(

Example folder structure after usage:

* Target Directory
  * G 2012-02-08 17;05;01 (Full) [439.972GB]
  * H 2012-02-09 04;54;29 (Full) [403.897GB]

Usage:
ruby lsizerenamer.rb "/home/user/folder"