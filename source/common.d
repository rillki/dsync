module common;

import std.stdio : write, writef;

// definitions
enum PROJECT_NAME = "dsync";
enum PROJECT_VERSION = "1.0.0";
enum PROJECT_HELP_HEADER = 
    PROJECT_NAME ~ " version v" ~ PROJECT_VERSION ~ 
    " -- syncing files accross directories and devices.";
enum PROJECT_HELP_FOOTER = `OPTIONS:
    --method=target  ensure the destination folder is a strict copy of the source specified
    --method=dual    synchronize both targets, but do not remove files automatically
    --method=full    synchronize both targets completely (fully automatic)
EXAMPLE:
    dsync --src ~/disk1 --dst ~/disk2 --method target --verbose
`;

/// syncronization method
enum DSyncMethod
{
    /// ensure the destination folder is a strict copy of the source specified  
    target,

    /// synchronize both targets, but do not remove files automatically
    dual,

    /// synchronize both targets completely (fully automatic)
    full,
}

/++ 
 + Custom log function (appends new line at the end by default)
 + Params:
 +   args = arguments
 +/
void dsyncLog(string sep = " ", string end = "\n", string header = PROJECT_NAME, Args...)(Args args) 
{
    write("#", header, " :: ");
    foreach (i, arg; args) write(arg, i < args.length ? sep: "");
    write(end);
}

/++ 
 + Custom log function with formatter
 + Params:
 +   format = formatted output
 +   args = arguments
 +/
void dsyncLogf(string header = PROJECT_NAME, Args...)(in string format, Args args) 
{
    if (header) write("#", header, " :: ");
    writef(format, args);
}

/++ 
 + List all files found in a directory
 + Params:
 +   dir = directory to inspect
 + Returns: an array of file names with absolute path
 +/
// string[] listdir(in string dir) 
// {
//     return dirEntries(dir, SpanMode.shallow)
//         .filter!(a => a.isFile)
//         .map!(a => baseName(a.name))
//         .array;
// }

