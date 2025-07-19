<img src="imgs/logo.png" width="64" height="64" align="left"></img>
# Disk synchronization tool 
Syncing files accross directories and devices.

## Usage
```sh
dsync version v1.1.0 -- syncing files accross directories and devices.
-s       --src Required: Source directory.
-d       --dst Required: Destination directory.
-m    --method           Synchronization method. (default: target)
-i --ignore_df           Ignore dot files. (default: false)
-v   --verbose           Verbose level [0 - off, 1 - brief, 2 - detailed]. (default: 1)
-h      --help           This help information.
OPTIONS:
    --method=target Make the destination folder exactly like the source.
                    Extra files in the destination will be deleted.
    --method=dual   Keep both folders in sync. New and changed files are copied both ways.
                    No files are deleted.
EXAMPLE:
    dsync --src ~/disk1 --dst ~/disk2 --method=target --verbose 2
```

## Build
```
dub build
```
The binary will be saved to the `bin` folder.

## LICENSE
All code is licensed under the MIT license.

