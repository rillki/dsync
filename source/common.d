module common;

// std
import std.file : dirEntries, SpanMode, DirEntry;
import std.array : array;
import std.stdio : write, writef;
import std.algorithm : map;

// definitions
enum PROJECT_NAME = "dsync";
enum PROJECT_VERSION = "1.0.2";
enum PROJECT_HELP_HEADER = 
    PROJECT_NAME ~ " version v" ~ PROJECT_VERSION ~ 
    " -- syncing files accross directories and devices.";
enum PROJECT_HELP_FOOTER = `OPTIONS:
    --method=target  ensure the destination folder is a strict copy of the source specified
    --method=dual    synchronize both targets, but do not remove files automatically
    --method=full    synchronize both targets completely
    --method=net     synchronize both targets over the network in full mode
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

    /// synchronize both targets over the network in full mode 
    net,
}

/++ 
 + Python-like print log function
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
 + C printf-like log function
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
 +   mode = inspection span mode
 + Returns: an array of file names with absolute path
 +/
string[] listdir(in string dir, in SpanMode mode = SpanMode.depth) 
{
    return dirEntries(dir, mode).map!(a => a.name).array;
}

