module app;

// std
import std.file : exists;
import std.getopt : getopt, defaultGetoptPrinter, config;

// dsync
import common;
import sync;

void main(string[] args)
{
    if (args.length < 2) 
    {
        dsyncLog("incorrect or no commands specified! See '-h' for more information.");
        return;
    }

    // define options
    string opt_src;
    string opt_dst;
    bool opt_verbose = false;
    auto opt_sync_method = DSyncMethod.target;

    // parse arguments
    try
    {
        auto argInfo = getopt(
            args,
            config.required, "src|s", "source directory", &opt_src,
            config.required, "dst|d", "destination directory", &opt_dst,
            "method|m", "sync method", &opt_sync_method,
            "verbose|v", "verbose output", &opt_verbose,
        );

        // display help manual
        if (argInfo.helpWanted) 
        {
            defaultGetoptPrinter(PROJECT_HELP_HEADER, argInfo.options);
            dsyncLogf!null(PROJECT_HELP_FOOTER);
            return;
        }

        // validate options
        if (!exists(opt_src))
        {
            dsyncLogf("Source directory <%s> does not exist!\n", opt_src);
            return;
        }
        if (!exists(opt_dst))
        {
            dsyncLogf("Destination directory <%s> does not exist!\n", opt_dst);
            return;
        }

        // synchronize
        if (opt_verbose) dsyncLog("Starting syncronization process...");
        with (DSyncMethod)
        final switch (opt_sync_method)
        {
            case target:
                dsyncTarget(opt_src, opt_dst, opt_verbose);
                break;
            case dual:
                dsyncDual(opt_src, opt_dst, opt_verbose);
                break;
            case full:
            case net:
                dsyncLog("unimplemented!");
        }
        if (opt_verbose) dsyncLog("All files up-to-date!");
    }
    catch (Exception e) 
    {
        dsyncLogf("error :: %s\n", e.msg);
    }
}

