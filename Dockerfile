# Just use the code-server docker binary
FROM codercom/code-server as coder-binary

FROM ubuntu:18.10 as vscode-env
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
	apt-get install -y curl wget git gnupg2 ca-certificates sudo && \
	apt-get install -y software-properties-common
# Create a non-home/user user with username 'user'
RUN useradd -m -s /bin/bash user \
	&& echo 'user ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers \
	&& chown -R user /home/user \
	&& adduser user sudo

USER user
WORKDIR /home/user/

# Install the actual VSCode to download configs and extensions
RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add - && \
	sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" && \
	sudo apt install -y code && \
	sudo apt-get install -y -f && \
	# VSCode missing deps
	sudo apt-get install -y libx11-xcb1 libasound2 && \
	# CLI json parser
	sudo apt-get install -y jq

COPY scripts /home/user/scripts
COPY sync.gist /home/user/sync.gist

# This gets user config from gist, parse it and install exts with VSCode
RUN sudo apt-get update && code -v --user-data-dir /home/user/.config/Code && \
  cd /home/user/scripts && \
	sh get-config-from-gist.sh && \
	sh parse-extension-list.sh && \
	sh install-vscode-extensions.sh ../extensions.list

# The production image for code-server
FROM ubuntu:18.10
ARG DEBIAN_FRONTEND=noninteractive
COPY --from=coder-binary /usr/local/bin/code-server /usr/local/bin/code-server
RUN mkdir -p /home/user/.code-server/User
COPY --from=vscode-env /home/user/settings.json /home/user/.code-server/User/settings.json
COPY --from=vscode-env /home/user/.vscode/extensions /home/user/.code-server/extensions
COPY scripts /home/user/scripts

RUN sudo apt-get update && \
	sudo apt-get install -y curl wget git gnupg2 ca-certificates sudo && \
	sudo apt-get install -y locales && \
	locale-gen en_US.UTF-8

RUN sudo apt-get install dialog apt-utils -y
# Locale Generation
# We unfortunately cannot use update-locale because docker will not use the env variables
# configured in /etc/default/locale so we need to set it manually.
ENV LANG=en_US.UTF-8

# Install langauge toolchains

COPY scripts/ /home/user/scripts/

RUN sudo sh /home/user/scripts/install-tools-brew.sh
RUN sudo sh -c exec "$SHELL"
RUN sudo sh /home/user/scripts/install-tools-dev.sh
RUN sudo sh /home/user/scripts/install-tools-cpp.sh
RUN sudo sh /home/user/scripts/install-tools-dotnet.sh
RUN sudo sh /home/user/scripts/install-tools-golang.sh
RUN sudo sh /home/user/scripts/install-tools-nodejs.sh
RUN sudo sh /home/user/scripts/install-tools-java.sh
RUN sudo sh /home/user/scripts/install-tools-php.sh
RUN sudo sh /home/user/scripts/install-tools-rust.sh
RUN sudo sh /home/user/scripts/install-tools-pyenv.sh
RUN sudo sh /home/user/scripts/install-tools-rubyenv.sh
RUN sudo sh /home/user/scripts/install-tools-swiftenv.sh

EXPOSE 8443
CMD code-server $PWD
