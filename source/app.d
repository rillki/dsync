module app;

import std.file : exists;
import std.stdio : writef;
import std.getopt : getopt, defaultGetoptPrinter, config;

import rk.core.common;
import rk.sync.target : TargetSync;
import rk.sync.dual : DualSync;

void main(string[] args)
{
    if (args.length < 2) 
    {
        log("Incorrect or no commands specified! See '-h' for more information.");
        return;
    }

    // define command line agruments
    string src, dst;
    ubyte verbose = 1;
    bool ignore_df = false;
    auto method = SynchronizationMethod.update;
    
    // parse command line arguemnts
    try
    {
        auto argInfo = getopt(
            args,
            config.required, "src|s", "Source directory.", &src,
            config.required, "dst|d", "Destination directory.", &dst,
            "method|m", "Synchronization method. (default: update)", &method,
            "ignore_df|i", "Ignore dot files. (default: false)", &ignore_df,
            "verbose|v", "Verbose level [0 - off, 1 - brief, 2 - detailed]. (default: 1)", &verbose,
        );

        // display help
        if (argInfo.helpWanted)
        {
            defaultGetoptPrinter(projectHelpHeader, argInfo.options);
            writef("%s", projectHelpFooter);
            return;
        }
    }
    catch (Exception e)
    {
        log("Error:", e.msg);
        return;
    }

    // check if paths exist
    foreach (dir; [src, dst]) if (!exists(dir))
    {
        log("Directory does not exist:", dir);
        return;
    }

    if (verbose)
    {
        log("Synchronizing:");
        log(src);
        log(method == SynchronizationMethod.target ? "↓" : "↕");
        log(dst);
    }

    // choose synchronization method
    with (SynchronizationMethod) final switch (method)
    {
        case target:
            TargetSync(src, dst, verbose, ignore_df).synchronize();
            break;
        case update:
            TargetSync(src, dst, verbose, ignore_df, false).synchronize();
            break;
        case dual:
            DualSync(src, dst, verbose, ignore_df).synchronize();
            break;
    }
    if (verbose) log("All files are up-to-date!");
}