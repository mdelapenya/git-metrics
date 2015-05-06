The main purpose of this repo is to create scripts to gather some interesting metrics for any git repo.

# git-repo-stats.sh

It reads the GIT history of a project in the current branch, collecting three metrics of each commit on the history: number of lines added, number of lines deleted, and number of files modified.

At the end, it creates a CSV file where each line represents those metrics for each commit.

To execute it, copy the script to the repo you want to gather metrics for, checkout the branch you prefer, and execute the shell script:

./git-repo-stats.sh

There is also a R language script to plot the statistics in R format. You can execute it using R commands, but you'll need to install ggplot2 dependency before, using *library("ggplot2")* command.