The main purpose of this repo is to create scripts to gather some interesting metrics for any git repo.

# git-repo-stats.sh

It reads the GIT history of a project in the current branch, collecting three metrics of each commit on the history: number of lines added, number of lines deleted, and number of files modified.

At the end, it creates a CSV file where each line represents those metrics for each commit.

To execute it, copy the script to the repo you want to gather metrics for, checkout the branch you prefer, and execute the shell script:

```
$ ./git-repo-stats.sh
```

There is also a R language script to plot the statistics in R format. You can execute it using R commands, but you'll need to install ggplot2 dependency before, using this command on R shell:

```
> library("ggplot2")
```

This is a sample screenshot of how those three series are plotted:

![Sample Commit Statistics](/static/sample.png)

After plotting it, R will display a summary of the statistics:

```
   addedLines      deletedLines   modifiedFiles  
 Min.   : 1.000   Min.   :0.000   Min.   :1.000  
 1st Qu.: 3.000   1st Qu.:0.750   1st Qu.:1.000  
 Median : 5.000   Median :1.000   Median :1.000  
 Mean   : 8.938   Mean   :1.562   Mean   :1.125  
 3rd Qu.: 8.500   3rd Qu.:2.000   3rd Qu.:1.000  
 Max.   :39.000   Max.   :6.000   Max.   :2.000 
 ```