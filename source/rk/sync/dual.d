module rk.sync.dual;

import rk.sync.target : TargetSync;

/// Dual syncronization mode.
struct DualSync
{
    string src, dst;
    ubyte verbose = 0;
    bool ignore_df = false;
    private immutable strictCopy = false;

    /// Define and configure syncronization targets.
    this(in string src, in string dst, in ubyte verbose, in bool ignore_df)
    {
        this.src = src;
        this.dst = dst;
        this.verbose = verbose;
        this.ignore_df = ignore_df;
    }

    /// Syncronize the destination directory with the source.
    void syncronize() 
    {
        TargetSync(src, dst, verbose, ignore_df, strictCopy).syncronize();
        TargetSync(dst, src, verbose, ignore_df, strictCopy).syncronize();
    }
}
