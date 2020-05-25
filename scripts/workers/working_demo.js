addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

const GIT_URL = "https://raw.githubusercontent.com/fergusfettes/docker-apps/dev/dockerfiles/config/"
const ZSH_MIN = 'minimal.zsh'
const VIM_MIN = 'minimal.vim'
const TMUX = '.tmux.conf'

async function handleRequest(request) {
  const url = new URL(request.url)
  let file = 'string'
  switch (url.pathname) {
    case "/zsh":
      file = ZSH_MIN;
      break;
    case "/vim":
      file = VIM_MIN;
      break;
    case "/tmux":
      file = TMUX;
      break;
  }

  return new Response(`${GIT_URL}${file}`)
}
