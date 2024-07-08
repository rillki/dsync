module app;

// std
import std.getopt : getopt, defaultGetoptPrinter;

// dsync
import common;

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
            "src|s", "source directory", &opt_src,
            "dst|d", "destination directory", &opt_dst,
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

        // synchronize
        with (DSyncMethod)
        final switch (opt_sync_method)
        {
            case target:
                break;
            case dual:
            case full:
                dsyncLog("unimplemented!");
        }
    }
    catch (Exception e) 
    {
        dsyncLogf("error :: %s\n", e.msg);
    }
}
