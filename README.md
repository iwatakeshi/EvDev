## EvDev
LER0ever's Personal Dockerized Development Environment

## Awesomeness included
- Alpine Edge
- Full-Featured EverVim (with all of supported languages) running on latest Neovim
- Preconfigured Tmux and Zsh
- Toolchains for
    - C (clang, lldb, gcc, gdb)
    - Golang
    - Rust (Cargo, Rustc, Racer)
    - Nodejs (Tern, Typescript)
    - Ruby (Rails)
    - Python 2/3
    - C# Mono
    - Lua(jit)
- Full-Featured Spacemacs (on latest emacs)
- FRP

## Usage
#### Build
```
# docker version
docker pull ler0ever/evdev
# put evdev into /usr/local/bin
```

#### Use
```
cd your-workspace
evdev
# Enjoy
```

## [Docker Hub](https://hub.docker.com/r/ler0ever/evdev/)
The image is built daily using cronjob, and automatically push to DockerHub: [LER0ever/EvDev](https://hub.docker.com/r/ler0ever/evdev/), available to everyone.

## License
EvDev is licensed under the term of **Apache 2.0**  
`gitconfig`, `bin`, and `xterm-256color` are from [peterdemartini/pdev](https://github.com/peterdemartini/pdev)
