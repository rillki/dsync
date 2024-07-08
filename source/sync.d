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
    return;
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

