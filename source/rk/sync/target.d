module rk.sync.target;

import std.file : isDir, 
                  isFile, 
                  exists, 
                  mkdirRecurse, 
                  rmdirRecurse, 
                  copy, 
                  remove, 
                  timeLastModified, 
                  PreserveAttributes;
import std.path : absolutePath;
import std.array : array;
import std.string : replace;
import std.datetime : SysTime, dur;
import std.algorithm : filter;
import std.parallelism : parallel;

import rk.core.asol : listdir;
import rk.core.common : log;

/// Target synchronization mode.
struct TargetSync
{
    string src, dst;
    ubyte verbose = 0;
    bool ignore_df = false, strictCopy = true;

    /// Synchronize the destination directory with the source.
    void synchronize() 
    {
        // get absolute path
        src = absolutePath(src);
        dst = absolutePath(dst);

        if (verbose) log("Synchronizing directory tree...");
        createDirectoryTree();

        if (verbose) log("Copying and updating files...");
        copyUpdateFiles();

        // destination must be a scrict copy of the source
        if (strictCopy)
        {
            if (verbose) log("Removing redundant files...");
            removeFiles();

            if (verbose) log("Removing redundant directories...");
            removeDirectoryTree();
        }
    }

    private void createDirectoryTree()
    {
        // list directories
        auto srcDirs = listdir(src, ignore_df).filter!(a => a.isDir).array;

        // iterate the directory tree in source
        // create the same directory tree in destination
        foreach (dir; srcDirs)
        {
            auto dstDir = dir.replace(src, dst);
            if (!exists(dstDir)) 
            {
                if (verbose > 1) log("\t[  mkdir ]", dstDir);
                mkdirRecurse(dstDir);
            }
        }
    }

    private void removeDirectoryTree()
    {
        // list directories
        auto dstDirs = listdir(dst, ignore_df).filter!(a => a.isDir).array;

        // iterate the directory tree in destination
        // remove the destination directory if it does not exist in source
        foreach (dir; dstDirs)
        {
            auto srcDir = dir.replace(dst, src);
            if (!exists(srcDir))
            {
                if (verbose > 1) log("\t[  rmdir ]", dir);
                rmdirRecurse(dir);
            }
        }
    }
    
    private void copyUpdateFiles()
    {
        // list files
        auto srcFiles = listdir(src, ignore_df).filter!(a => a.isFile).array;

        // iterate over the files in source
        foreach (file; srcFiles.parallel)
        {
            auto dstFile = file.replace(src, dst);

            // copy file to destination if it does not exist
            if (!exists(dstFile))
            {
                if (verbose > 1) log("\t[   copy ]", dstFile);
                file.copy(dstFile);
            }
            else // update file if neccessary
            {
                // get modification time
                SysTime srcModificationTime = file.timeLastModified, 
                        dstModificationTime = dstFile.timeLastModified;

                // update
                if (srcModificationTime > dstModificationTime + dur!"seconds"(1))
                {
                    if (verbose > 1) log("\t[ update ]", dstFile);
                    file.copy(dstFile, PreserveAttributes.yes);
                }
            }
        }
    }

    private void removeFiles()
    {
        // list files
        auto dstFiles = listdir(dst, ignore_df).filter!(a => a.isFile).array;

        // iterate over the files in destination
        foreach (file; dstFiles.parallel)
        {
            auto srcFile = file.replace(dst, src);

            // remove file from destination if it does not exist in source
            if (!exists(srcFile))
            {
                if (verbose > 1) log("\t[ remove ]", file);
                remove(file);
            }
        }
    }
}
