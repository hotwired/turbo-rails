import type { TurboBeforeFetchRequestEvent, TurboSubmitStartEvent } from '@hotwired/turbo'

export function encodeMethodIntoRequestBody(event: Event) {
  let ev = event as TurboBeforeFetchRequestEvent
  if (ev.target instanceof HTMLFormElement) {
    const { target: form, detail: { fetchOptions } } = ev

    form.addEventListener("turbo:submit-start", ev => {
      const { detail: { formSubmission: { submitter } } } = ev as TurboSubmitStartEvent
      const method = detectSubmitMethod(form, submitter, fetchOptions) || ""

      if (!/get/i.test(method)) {
        const body = fetchOptions.body as FormData | undefined
        if (/post/i.test(method)) {
          body?.delete("_method")
        } else {
          body?.set("_method", method)
        }

        fetchOptions.method = "post"
      }
    }, { once: true })
  }
}

function detectSubmitMethod(form: HTMLElement, submitter: HTMLElement | undefined, fetchOptions: RequestInit): string | null {
  const _submitter = submitter as HTMLInputElement | HTMLButtonElement | undefined
  const body = fetchOptions.body as FormData | undefined
  if (_submitter && _submitter.formMethod) {
    return _submitter.formMethod
  } else if (body?.get("_method")) {
    return body.get("_method") as string | null
  } else {
    return form.getAttribute("method")
  }
}
