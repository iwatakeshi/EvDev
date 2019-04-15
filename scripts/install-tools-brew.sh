PATH=/home/user/.linuxbrew/bin:/home/user/.linuxbrew/sbin:$PATH \
    SHELL=/bin/bash
git clone https://github.com/Homebrew/brew /home/user/.linuxbrew/Homebrew \
    && mkdir /home/user/.linuxbrew/bin \
    && ln -s ../Homebrew/bin/brew /home/user/.linuxbrew/bin/ \
    && brew config