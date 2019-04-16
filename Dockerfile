# Use the code-server docker binary
FROM codercom/code-server as coder-binary

FROM ubuntu:18.10 as vscode-env
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
	apt-get install -y curl gnupg libx11-xcb1 libasound2 &&\
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
	install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && \
	sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && \
	apt-get install -y apt-transport-https && \
	apt-get update && apt-get -y install code && \
	# CLI json parser
	sudo apt-get install -y jq

COPY scripts /home/user/scripts
COPY sync.gist /home/user/sync.gist

# This gets user config from gist, parse it and install exts with VSCode
RUN apt-get update && code -v --user-data-dir /home/user/.config/Code && \
  cd /home/user/scripts && \
	sh get-config-from-gist.sh && \
	sh parse-extension-list.sh && \
	sh install-vscode-extensions.sh ../extensions.list

# # The production image for code-server
FROM ubuntu:18.10

RUN apt-get update && apt-get install -y dialog apt-utils && \
	apt-get install -y locales && \
	locale-gen en_US.UTF-8
# Locale Generation
# We unfortunately cannot use update-locale because docker will not use the env variables
# configured in /etc/default/locale so we need to set it manually.
ENV LANG=en_US.UTF-8
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata


# Install dependencies for the scripts
RUN apt-get update && \
	apt-get install -y curl wget gnupg2 ca-certificates sudo && \
	apt-get install -y curl build-essential m4 make git patch ruby zlib1g-dev tcl && \
	apt-get install -y apt-transport-https

# Create a non-root user with username 'user'
RUN useradd -m -s /bin/bash user \
	&& echo 'user ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers \
	&& chown -R user /home/user \
	&& adduser user sudo


ENV DEBIAN_FRONTEND=noninteractive
COPY --from=coder-binary /usr/local/bin/code-server /usr/local/bin/code-server
RUN mkdir -p /home/user/.code-server/User
COPY --from=vscode-env /root/settings.json /home/user/.code-server/User/settings.json
COPY --from=vscode-env /root/.vscode/extensions /home/user/.code-server/extensions


# Install langauge toolchains
USER user

COPY scripts/ /home/user/scripts/

RUN sh /home/user/scripts/install-tools-brew.sh

ENV PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

RUN sudo sh /home/user/scripts/install-tools-cpp.sh
RUN sudo sh /home/user/scripts/install-tools-dev.sh
RUN sudo sh /home/user/scripts/install-tools-dotnet.sh
RUN sudo sh /home/user/scripts/install-tools-golang.sh
RUN sudo sh /home/user/scripts/install-tools-java.sh
RUN sudo sh /home/user/scripts/install-tools-nodejs.sh
RUN sudo sh /home/user/scripts/install-tools-php.sh
RUN sudo sh /home/user/scripts/install-tools-rust.sh
RUN sudo sh /home/user/scripts/install-tools-pyenv.sh
RUN sh /home/user/scripts/install-tools-rubyenv.sh
RUN sh /home/user/scripts/install-tools-swiftenv.sh

EXPOSE 8443
CMD code-server $PWD
