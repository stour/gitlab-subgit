#!/bin/bash

set -e

if [ $1 != "configure-interactive" ]; then

    export KEY_PATH=/opt/subgit-$SUBGIT_VERSION/subgit.key

    # Restart SubGit daemon for any configured repository
    for dir in /var/opt/gitlab/git-data/repositories/*/*
    do
        if [ -d "$dir/subgit" -a -d "$dir/custom_hooks" ]; then

            if [ -f "$KEY_PATH" ]; then
                echo "$0: Registering licence key for repository $dir"
                subgit register --key $KEY_PATH $dir
            fi

            echo "$0: Starting SubGit daemon for repository $dir"
            su -c "export PATH=/opt/subgit-3.2.2/bin/:$PATH && rm -f $dir/subgit/daemon.* && subgit fetch $dir" git

        fi
    done

    # Fixes permissions of Git files
    chown -R git:git /var/opt/gitlab/git-data

    exec "$@"

else
    # Configure SubGit on a GitLab repository interactively
    su git

    export PATH=/opt/subgit-3.2.2/bin/:$PATH

    echo "Enter path of GitLab repository: "
    read GIT_REPO_PATH

    echo "Enter URL of SVN project: "
    echo "WARNING 'subgit configure' command expects that the SVN project has trunk/branches/tags structure"
    read SVN_PROJECT_URL

    echo "$0: subgit configure --layout std $SVN_PROJECT_URL $GIT_REPO_PATH"
    subgit configure --layout std $SVN_PROJECT_URL $GIT_REPO_PATH

    vi $GIT_REPO_PATH/subgit/passwd
    vi $GIT_REPO_PATH/subgit/authors.txt
    vi $GIT_REPO_PATH/subgit/config

    # Initial translation (use 'import' in place of 'install' for a one-time cut over migration)
    echo "$0: subgit install $GIT_REPO_PATH"
    subgit install $GIT_REPO_PATH

    exit
fi
