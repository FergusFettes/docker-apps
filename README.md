# Docker apps

Here are my docker experiments. Currently I have 3 or 4 goals, in approximate order of when I'll work on them:

## CLI apps

1.  my-standard-setup: this is a simple docker image containing vim zsh and so on for quickly being able to work nicely in new environments, also serves to document/replace the process I have to go through whenever I do a fresh install.

COMPLETE: available at [ffettes/cli](https://hub.docker.com/r/ffettes/cli) 
however I need to make an upgraded version using the jlesage s6 baseimage so i can make it much smaller

also need to make an ARM version for the raspi

2. a small extension of the simple command line environment for getting access to remote machines behind firewalls using eternal-terminal reverse tunnelling (or just ssh reverse tunnelling if that isnt possible)

3. now I have the basic image, I can make extensions for developing in different languages (aka one with ipython and pip)


## Audio apps

There are already some options for using firefox or chrome inside a docker container, but I havent found one yet that has everything I want. Basically just going to add a puslesaudio server to the [jlesage/firefox](https://hub.docker.com/r/jlesage/firefox) image. This will make it possible to have

1. firefox in a x11 container with a pulseaudio server, so multiple people can watch youtube together and hear the audio at the same time

2. vlc media player media center so i can stream video and audio over vnc/http. this might be easier than the firefox one so I may end up doing it first


## Other

1. vscode environment for web development. not sure if this makes much sense but there is only one way to find out. makeing it easy to install new programming langugages might be hard

2. jupyter lab

3. blender headless renderer afaict i might have genuinly found something that should exist but doesnt yet? once i have completed the above images i should have enough experience to do this
