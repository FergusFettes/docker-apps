// 1. Register a FetchEvent listener that sends a custom
//    response for the given request.
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

// 2. Return a custom request object
async function handleRequest(request) {
  return new Response('hello world')
}
