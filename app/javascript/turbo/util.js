export function observeAttributes(element, attributeFilter, callback) {
  const observer = new MutationObserver((mutations) => {
    mutations.forEach(({ attributeName, target }) => {
      callback(target.getAttribute(attributeName), attributeName)
    })
  })
  observer.observe(element, { attributeFilter })

  attributeFilter.forEach((attributeName) => {
    callback(element.getAttribute(attributeName), attributeName)
  })

  return observer
}
