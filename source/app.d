module app;

import std.file : exists;
import std.stdio : writef;
import std.getopt : getopt, defaultGetoptPrinter, config;
import common;

void main(string[] args)
{
    if (args.length < 2) 
    {
        log("Incorrect or no commands specified! See '-h' for more information.");
        return;
    }

    // define command line agruments
    string src, dst;
    bool verbose = false, ignore_df = false;
    auto method = SyncronizationMethod.target;
    
    // parse command line arguemnts
    try
    {
        auto argInfo = getopt(
            args,
            config.required, "src|s", "Source directory.", &src,
            config.required, "dst|d", "Destination directory.", &dst,
            "method|m", "Syncronization method.", &method,
            "ignore_df|i", "Ignore dot files.", &ignore_df,
            "verbose|v", "Verbose output.", &verbose,
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
    }

    // check if paths exist
    foreach (dir; [src, dst]) if (!exists(dir))
    {
        log("Directory does not exist:", dir);
        return;
    }

    if (verbose)
    {
        log("Syncronizing:");
        log(src);
        log(method == SyncronizationMethod.target ? "↓" : "↕");
        log(dst);
    }

    // choose syncronization method
    with (SyncronizationMethod) final switch (method)
    {
        case target:
        case dual:
    }
    if (verbose) log("All files are up-to-date!");
}