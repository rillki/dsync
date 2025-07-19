module rk.sync.dual;

import rk.sync.target : TargetSync;

/// Dual synchronization mode.
struct DualSync
{
    string src, dst;
    ubyte verbose = 0;
    bool ignore_df = false;
    private immutable strictCopy = false;

    /// Define and configure synchronization targets.
    this(in string src, in string dst, in ubyte verbose, in bool ignore_df)
    {
        this.src = src;
        this.dst = dst;
        this.verbose = verbose;
        this.ignore_df = ignore_df;
    }

    /// Synchronize the destination directory with the source.
    void synchronize() 
    {
        TargetSync(src, dst, verbose, ignore_df, strictCopy).synchronize();
        TargetSync(dst, src, verbose, ignore_df, strictCopy).synchronize();
    }
}
