module rk.sync.dual;

import rk.sync.target : TargetSync;

/// Dual syncronization mode.
struct DualSync
{
    string src, dst;
    bool ignore_df = false, verbose = false;
    private immutable strictCopy = false;
    
    this(in string src, in string dst, in bool ignore_df, in bool verbose)
    {
        this.src = src;
        this.dst = dst;
        this.ignore_df = ignore_df;
        this.verbose = verbose;
    }

    /// Syncronize the destination directory with the source.
    void syncronize() 
    {
        TargetSync(src, dst, ignore_df, verbose, this.strictCopy).syncronize();
        TargetSync(dst, src, ignore_df, verbose, this.strictCopy).syncronize();
    }
}
