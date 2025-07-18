module rk.sync.target;

import rk.core.common : log;

/// Target syncronization mode.
struct TargetSync
{
    string src, dst;
    bool ignore_df = false, verbose = false, strictCopy = true;

    /// Syncronize the destination directory with the source.
    void syncronize() 
    {
        createDirectoryTree();
        copyUpdateFiles();

        // destination must be a scrict copy of the source
        if (this.strictCopy)
        {
            removeDirectoryTree();
            removeFiles();
        }
    }

    private void createDirectoryTree()
    {}

    private void removeDirectoryTree()
    {}
    
    private void copyUpdateFiles()
    {}

    private void removeFiles()
    {}
}
