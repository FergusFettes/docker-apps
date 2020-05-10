# Docker apps

Here are my docker experiments. Currently I have 3 or 4 goals, in approximate order of when I'll work on them:

1. my-standard-setup: this is a simple docker image containing vim zsh and so on for quickly being able to work nicely in new environments, also serves to document/replace the process I have to go through whenever I do a fresh install
1a. this will be augmented with proper user permissions and probably a jlesage image at some point, and may eventually get updated completely to a xterm gui app (which is a bit rediculous but would be useful for debugging and working on the ones below)
1b. this will also contain experiments w.r.t reverse ssh tunnelling, mosh use and eternal terminal, so this image can be dumped in any machine and hopefully give me some kind of access to it

2. vscode environment for web development (i mostly just think it is a good ide ato learn vscode at some point and want to practice using the jlesage gui images)

3. vlc media player media center so i can stream video and audio over vnc/http and people can all watch the same movie on their own laptops

4. firefox so everyone can watch youtube videos together horrray (just need to connect audio like above, if i do a bit of playing around with pulseaudio these images should be no problem)

5. blender headless renderer afaict i might have genuinly found something that should exist but doesnt yet? once i have completed the obve images i should have enough experience to do this
