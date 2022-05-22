export function overrideMethodWithFormmethod({ detail: { formSubmission: { fetchRequest, submitter } } }) {
  const formMethod = submitter?.formMethod

  if (formMethod && fetchRequest.body.has("_method")) {
    fetchRequest.body.set("_method", formMethod)
  }
}
