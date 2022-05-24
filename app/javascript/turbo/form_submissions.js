export function overrideMethodWithFormmethod({ detail: { formSubmission: { fetchRequest, submitter } } }) {
  if (submitter && submitter.formMethod && fetchRequest.body.has("_method")) {
    fetchRequest.body.set("_method", submitter.formMethod)
  }
}
