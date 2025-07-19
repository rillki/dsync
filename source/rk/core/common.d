module rk.core.common;

/*
 * Common functionality and configurations shared thoughout the project. 
 */

import rk.core.asol;

/// project infomation
enum 
{
    projectName = "dsync",
    projectVersion = "1.1.0",
    projectHelpHeader = 
        projectName ~ " version v" ~ projectVersion ~ 
        " -- syncing files accross directories and devices.",
    projectHelpFooter = `OPTIONS:
    --method=target Make the destination folder exactly like the source.
                    Extra files in the destination will be deleted.
    --method=dual   Keep both folders in sync. New and changed files are copied both ways.
                    No files are deleted.
EXAMPLE:
    dsync --src ~/disk1 --dst ~/disk2 --method=target --verbose
`,
    projectLogHeader = projectName ~ " :: "
}

/// Syncronization method
enum SyncronizationMethod
{
    /// Make the destination folder exactly like the source.
    /// Extra files in the destination will be deleted.
    target,

    /// Keep both folders in sync. New and changed files are copied both ways.
    /// No files are deleted.
    dual,
}

/// Simple logging function + new line. 
auto log(Args...)(Args args) => logPrint!(" ", "\n", projectLogHeader)(args);

/// C printf-like function.
auto logf(Args...)(in string format, Args args) => logPrintf!(projectLogHeader)(format, args);

