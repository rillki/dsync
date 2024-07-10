module sync;

// dsync
import common;

/++ 
 + Ensure the destination folder is a strict copy of the source specified
 + Params:
 +   src = source directory
 +   dst = destination directory
 +   verbose = verbose output
 +/
void dsyncTarget(in string src, in string dst, in bool verbose)
{
    if (verbose) dsyncLog("Starting syncronization process...");

    // list directories
    src_dirs = listdir(src);
    dst_dirs = listdir(dst);

    if (verbose) dsyncLog("All files up-to-date!");
}

/++ 
 + synchronize both targets, but do not remove files automatically
 + Params:
 +   src = source directory
 +   dst = destination directory
 +   verbose = verbose output
 +/
void dsyncDual(in string src, in string dst, in bool verbose)
{
    return;
}

/++ 
 + Synchronize both targets completely (fully automatic)
 + Params:
 +   src = source directory
 +   dst = destination directory
 +   verbose = verbose output
 +/
void dsyncFull(in string src, in string dst, in bool verbose)
{
    return;
}

/++ 
 + Create directory tree 
 + Params:
 +   src = source directory where the dir tree is copied from
 +   dst = destination directory where the dir tree is created based in source
 +/
void dsyncCreateDirectoryTree(in string src, in string dst)
{
    return;
}

