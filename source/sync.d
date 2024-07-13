module sync;

// std
import std.conv : to;
import std.file : mkdirRecurse, rmdirRecurse, isDir, isFile, exists, copy, getTimes, remove;
import std.array : array;
import std.string : replace;
import std.datetime : SysTime;
import std.algorithm : filter, canFind;

// dsync
import common;

/++ 
 + Ensure the destination folder is a strict copy of the source specified
 + Params:
 +   src = source directory
 +   dst = destination directory
 +   ignore_df = exclude dot files
 +   verbose = verbose output
 +/
void dsyncTarget(in string src, in string dst, in bool ignore_df, in bool verbose)
{
    // create directory tree for dst
    dsyncCreateDirectoryTree(src, dst, ignore_df, verbose);

    // copy or update files from src to dst
    dsyncCopyUpdateFiles(src, dst, ignore_df, verbose);

    // remove files from destination if they are absent in source
    dsyncRemoveFiles(src, dst, ignore_df, verbose);

    // remove directory tree from dst if absent from src
    dsyncRemoveDirectoryTree(src, dst, ignore_df, verbose);
}

/++ 
 + Synchronize both targets, but do not remove files automatically
 + Params:
 +   src = source directory
 +   dst = destination directory
 +   ignore_df = exclude dot files
 +   verbose = verbose output
 +/
void dsyncDual(in string src, in string dst, in bool ignore_df, in bool verbose)
{
    // create directory tree for dst
    dsyncCreateDirectoryTree(src, dst, ignore_df, verbose);

    // copy or update files from src to dst
    dsyncCopyUpdateFiles(src, dst, ignore_df, verbose);

    // create directory tree for src
    dsyncCreateDirectoryTree(dst, src, ignore_df, verbose);

    // copy or update files from dst to src
    dsyncCopyUpdateFiles(dst, src, ignore_df, verbose);
}

/++ 
 + Synchronize both targets completely (fully automatic)
 + Params:
 +   src = source directory
 +   dst = destination directory
 +   ignore_df = exclude dot files
 +   verbose = verbose output
 +/
void dsyncFull(in string src, in string dst, in bool ignore_df, in bool verbose)
{
    return;
}

/++ 
 + Synchronize both targets over the network in full mode
 + Params:
 +   src = source directory
 +   dst = destination directory
 +   ignore_df = exclude dot files
 +   verbose = verbose output
 +/
void dsyncNet(in string src, in string dst, in bool ignore_df, in bool verbose)
{
    return;
}

/++ 
 + Create directory tree 
 + Params:
 +   src = source directory where the dir tree is copied from
 +   dst = destination directory where the dir tree is created based on source
 +   ignore_df = exclude dot files
 +   verbose = verbose output
 +/
void dsyncCreateDirectoryTree(in string src, in string dst, in bool ignore_df, in bool verbose = false)
{
    // list directories
    auto src_dirs = listdir(src, ignore_df).filter!(a => a.isDir).array;
    auto dst_dirs = listdir(dst, ignore_df).filter!(a => a.isDir).array;

    // iterate over src directory and create dirtree in destination
    foreach (src_dir; src_dirs)
    {
        auto dst_dir = src_dir.replace(src, dst);
        if (!dst_dirs.canFind(dst_dir) && !dst_dir.exists())
        {
            dst_dir.mkdirRecurse();
            if (verbose) dsyncLogf("mkdir <%s>\n", dst_dir);
        }
    }
}

/++ 
 + Remove directory tree from destination if it is not present in the source directory 
 + Params:
 +   src = source directory where the dir tree is copied from
 +   dst = destination directory where the dir tree is created based on source
 +   ignore_df = exclude dot files
 +   verbose = verbose output
 +/
void dsyncRemoveDirectoryTree(in string src, in string dst, in bool ignore_df, in bool verbose = false)
{
    // list directories
    auto src_dirs = listdir(src, ignore_df).filter!(a => a.isDir).array;
    auto dst_dirs = listdir(dst, ignore_df).filter!(a => a.isDir).array;

    // iterate over dst directory and delete dirtree in source
    foreach (dst_dir; dst_dirs)
    {
        auto src_dir = dst_dir.replace(dst, src);
        if (!src_dirs.canFind(src_dir))
        {
            dst_dir.rmdirRecurse();
            if (verbose) dsyncLogf("rmdir <%s>\n", dst_dir);
        }
    }
}

/++ 
 + Copy or update files over directories
 + Params:
 +   src = source directory where files are taken from
 +   dst = destination directory where files are copied to
 +   ignore_df = exclude dot files
 +   verbose = verbose output
 +/
void dsyncCopyUpdateFiles(in string src, in string dst, in bool ignore_df, in bool verbose = false)
{
    // find all files
    auto src_files = listdir(src, ignore_df).filter!(a => a.isFile).array;
    auto dst_files = listdir(dst, ignore_df).filter!(a => a.isFile).array;

    // iterate over src directory and copy/update files to destination
    foreach (src_file; src_files)
    {
        // replace src substring with dst to get destination file location
        auto dst_file = src_file.replace(src, dst);

        // copy file
        if (!dst_files.canFind(dst_file))
        {
            src_file.copy(dst_file);
            if (verbose) 
            {
                dsyncLogf("copy <%s>\n", src_file);
                dsyncLogf(" to  <%s>\n", dst_file);
            }
        }
        else // update file
        {
            // get timestamps
            SysTime src_accessTime, dst_accessTime, src_modificationTime, dst_modificationTime;
            src_file.getTimes(src_accessTime, src_modificationTime);
            dst_file.getTimes(dst_accessTime, dst_modificationTime);

            // check if we need to update the file
            if (src_modificationTime > dst_modificationTime)
            {
                src_file.copy(dst_file);
                if (verbose) dsyncLogf("update <%s>\n", dst_file);
            }
        }
    }
}

/++ 
 + Remove files from destination directory if they are not present in the source directory
 + Params:
 +   src = source directory where files are taken from
 +   dst = destination directory where files are copied to
 +   ignore_df = exclude dot files
 +   verbose = verbose output
 +/
void dsyncRemoveFiles(in string src, in string dst, in bool ignore_df, in bool verbose = false)
{
    // find all files
    auto src_files = listdir(src, ignore_df).filter!(a => a.isFile).array;
    auto dst_files = listdir(dst, ignore_df).filter!(a => a.isFile).array;

    // iterate over src directory and remove files from destination if they are absent in source
    foreach (dst_file; dst_files)
    {
        // replace dst substring with src to get source file location
        auto src_file = dst_file.replace(dst, src);

        // copy file
        if (!src_files.canFind(src_file))
        {
            dst_file.remove();
            if (verbose) dsyncLogf("remove <%s>\n", dst_file);
        }
    }
}

