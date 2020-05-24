addEventListener('fetch', event => {
  event.respondWith(handleRequest(event))
})

const GIT_URL = 'https://github.com/FergusFettes/docker-apps/blob/dev/dockerfiles/config/'
const ZSH_MIN = 'minimal.zsh'
const VIM_MIN = 'minimal.vim'
const TMUX = '.tmux.conf'

async function serveAsset(event) {
  const url = new URL(event.request.url)
  const cache = caches.default
  let response = await cache.match(event.request)
  let file = 'none'

  if (!response) {
    switch (new url.pathname) {
      case "zsh":
        file = ZSH_MIN;
        break;
      case "vim":
        file = VIM_MIN;
        break;
      case "tmux":
        file = TMUX;
        break;
    }
    response = await fetch(`${GIT_URL}${url.pathname}`)
    const headers = { 'cache-control': 'public, max-age=14400' }
    response = new Response(response.body, { ...response, headers })
    event.waitUntil(cache.put(event.request, response.clone()))
  }
  return response
}

async function handleRequest(event) {
  if (event.request.method === 'GET') {
    let response = await serveAsset(event)
    if (response.status > 399) {
      response = new Response(response.statusText, { status: response.status })
    }
    return response
  } else {
    return new Response('Method not allowed', { status: 405 })
  }
}
