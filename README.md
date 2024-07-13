<img src="imgs/logo.png" width="64" height="64" align="left"></img>
# Disk synchronization tool
Syncing files accross directories and devices.

## Usage
```
dsync version v1.0.2 -- syncing files accross directories and devices.
-s     --src Required: source directory
-d     --dst Required: destination directory
-m  --method           sync method
-v --verbose           verbose output
-h    --help           This help information.
OPTIONS:
    --method=target  ensure the destination folder is a strict copy of the source specified
    --method=dual    synchronize both targets, but do not remove files automatically
    --method=full    synchronize both targets completely (fully automatic)
EXAMPLE:
    dsync --src ~/disk1 --dst ~/disk2 --method target --verbose
```

## Build
```
dub build
```
The binary will be saved to the `bin` folder.

## LICENSE
All code is licensed under the MIT license.

