export function extend({ delegate, enableElement, disableElement, linkDisableSelector, formDisableSelector, formSubmitSelector }) {
  const getTurboFrame = (element) => {
    if (element) {
      const frameId = element.getAttribute("data-turbo-frame")
      return frameId ?
        document.querySelector(`turbo-frame#${frameId}:not([disabled])`) :
        element.closest("turbo-frame:not([disabled])")
    }
  }

  delegate(document, linkDisableSelector, "turbo:click", ({ target }) => {
    const frame = getTurboFrame(target)

    if (frame) {
      frame.addEventListener("turbo:before-fetch-response", () => { enableElement(target) }, { once: true })
    }
  })

  delegate(document, formDisableSelector, "click", ({ target: submitter }) => {
    const submit = submitter.type == "submit"
    const form = submitter.form
    const isIdempotent = (submitter.formMethod || form?.method) == "get"
    const frame = getTurboFrame(submitter) || getTurboFrame(form)

    if (submit && form && isIdempotent && frame) {
      frame.addEventListener("turbo:before-fetch-request", () => { disableElement(form) }, { once: true })
      frame.addEventListener("turbo:before-fetch-response", () => { enableElement(form) }, { once: true })
    }
  })

  delegate(document, formSubmitSelector, "turbo:submit-start", ({ detail: { formSubmission: { formElement } } }) => {
    formElement.addEventListener("turbo:submit-end", () => { enableElement(formElement) }, { once: true })
    disableElement(formElement)
  })
}
