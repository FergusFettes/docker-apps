# Docker apps

Here are my docker experiments. Currently I have 3 or 4 goals, in approximate order of when I'll work on them:

Heavily inspired by [jlesage][20] and [woahbase][30].

## CLI apps

1. [my-standard-setup](./dockerfiles/base.Dockerfile): this is a simple docker image containing vim zsh and so on for quickly being able to work nicely in new environments, also serves to document/replace the process I have to go through whenever I do a fresh install.

INITIAL VERSION COMPLETE: available at [ffettes/cli][1].
TODO:
* make an upgraded version using the jlesage s6 baseimage so i can make it much smaller
* make an ARM version for the raspi

2. network-hacker-tool: a small extension of the simple command line environment for getting access to remote machines behind firewalls using eternal-terminal reverse tunnelling (or just ssh reverse tunnelling if that isnt possible)

3. specific images for other small cli tasks/environments (such as for python/javascript)

Since I discovered GNU stow and [dotfiles][11] I have less interest in the project to create the perfect command line, but the images below will be worth attempting at some point.

## Audio apps

There are already some options for using firefox or chrome inside a docker container, but I havent found one yet that has everything I want. Basically just going to add a puslesaudio server to the [jlesage/firefox][21] image. This will make it possible to have

1. firefox in a x11 container with a pulseaudio server, so multiple people can watch youtube together and hear the audio at the same time

2. vlc media player media center so i can stream video and audio over vnc/http. this might be easier than the firefox one so I may end up doing it first


## Other

1. jupyter lab with all my favourite python libraries installed

2. blender headless renderer: afaict i might have genuinly found something that should exist but doesnt yet? once i have completed the above images i should have enough experience to do this

[10]: https://hub.docker.com/r/ffettes/cli
[11]: https://github.com/fergusfettes/dotfiles

[20]: https://github.com/jlesage
[21]: https://hub.docker.com/r/jlesage/firefox

[30]: https://github.com/woahbase
