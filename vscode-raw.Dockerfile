# Pull base image.
FROM ubuntu:18.04

RUN apt update && apt upgrade

RUN apt install -y wget

RUN wget -q https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode.deb

RUN dpkg -i vscode.deb || true

RUN apt -f -y install

RUN dpkg -i vscode.deb

CMD code --user-data-dir /config


