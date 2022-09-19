export function encodeMethodIntoRequestBody(event) {
  if (event.target instanceof HTMLFormElement) {
    const { target: form, detail: { fetchOptions } } = event

    form.addEventListener("turbo:submit-start", ({ detail: { formSubmission: { submitter } } }) => {
      const method = (submitter && submitter.formMethod) || (fetchOptions.body && fetchOptions.body.get("_method")) || form.getAttribute("method")

      if (!/get/i.test(method)) {
        if (/post/i.test(method)) {
          fetchOptions.body.delete("_method")
        } else {
          fetchOptions.body.set("_method", method)
        }

        fetchOptions.method = "post"
      }
    }, { once: true })
  }
}
