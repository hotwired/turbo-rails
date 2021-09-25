(function() {
  if (window.Reflect === undefined || window.customElements === undefined || window.customElements.polyfillWrapFlushCallback) {
    return;
  }
  const BuiltInHTMLElement = HTMLElement;
  const wrapperForTheName = {
    HTMLElement: function HTMLElement() {
      return Reflect.construct(BuiltInHTMLElement, [], this.constructor);
    }
  };
  window.HTMLElement = wrapperForTheName["HTMLElement"];
  HTMLElement.prototype = BuiltInHTMLElement.prototype;
  HTMLElement.prototype.constructor = HTMLElement;
  Object.setPrototypeOf(HTMLElement, BuiltInHTMLElement);
})();

const submittersByForm = new WeakMap;

function findSubmitterFromClickTarget(target) {
  const element = target instanceof Element ? target : target instanceof Node ? target.parentElement : null;
  const candidate = element ? element.closest("input, button") : null;
  return (candidate === null || candidate === void 0 ? void 0 : candidate.type) == "submit" ? candidate : null;
}

function clickCaptured(event) {
  const submitter = findSubmitterFromClickTarget(event.target);
  if (submitter && submitter.form) {
    submittersByForm.set(submitter.form, submitter);
  }
}

(function() {
  if ("submitter" in Event.prototype) return;
  let prototype;
  if ("SubmitEvent" in window && /Apple Computer/.test(navigator.vendor)) {
    prototype = window.SubmitEvent.prototype;
  } else if ("SubmitEvent" in window) {
    return;
  } else {
    prototype = window.Event.prototype;
  }
  addEventListener("click", clickCaptured, true);
  Object.defineProperty(prototype, "submitter", {
    get() {
      if (this.type == "submit" && this.target instanceof HTMLFormElement) {
        return submittersByForm.get(this.target);
      }
    }
  });
})();

var FrameLoadingStyle;

(function(FrameLoadingStyle) {
  FrameLoadingStyle["eager"] = "eager";
  FrameLoadingStyle["lazy"] = "lazy";
})(FrameLoadingStyle || (FrameLoadingStyle = {}));

class FrameElement extends HTMLElement {
  constructor() {
    super();
    this.loaded = Promise.resolve();
    this.delegate = new FrameElement.delegateConstructor(this);
  }
  static get observedAttributes() {
    return [ "disabled", "loading", "src" ];
  }
  connectedCallback() {
    this.delegate.connect();
  }
  disconnectedCallback() {
    this.delegate.disconnect();
  }
  reload() {
    const {src: src} = this;
    this.src = null;
    this.src = src;
  }
  attributeChangedCallback(name) {
    if (name == "loading") {
      this.delegate.loadingStyleChanged();
    } else if (name == "src") {
      this.delegate.sourceURLChanged();
    } else {
      this.delegate.disabledChanged();
    }
  }
  get src() {
    return this.getAttribute("src");
  }
  set src(value) {
    if (value) {
      this.setAttribute("src", value);
    } else {
      this.removeAttribute("src");
    }
  }
  get loading() {
    return frameLoadingStyleFromString(this.getAttribute("loading") || "");
  }
  set loading(value) {
    if (value) {
      this.setAttribute("loading", value);
    } else {
      this.removeAttribute("loading");
    }
  }
  get disabled() {
    return this.hasAttribute("disabled");
  }
  set disabled(value) {
    if (value) {
      this.setAttribute("disabled", "");
    } else {
      this.removeAttribute("disabled");
    }
  }
  get autoscroll() {
    return this.hasAttribute("autoscroll");
  }
  set autoscroll(value) {
    if (value) {
      this.setAttribute("autoscroll", "");
    } else {
      this.removeAttribute("autoscroll");
    }
  }
  get complete() {
    return !this.delegate.isLoading;
  }
  get isActive() {
    return this.ownerDocument === document && !this.isPreview;
  }
  get isPreview() {
    var _a, _b;
    return (_b = (_a = this.ownerDocument) === null || _a === void 0 ? void 0 : _a.documentElement) === null || _b === void 0 ? void 0 : _b.hasAttribute("data-turbo-preview");
  }
}

function frameLoadingStyleFromString(style) {
  switch (style.toLowerCase()) {
   case "lazy":
    return FrameLoadingStyle.lazy;

   default:
    return FrameLoadingStyle.eager;
  }
}

function expandURL(locatable) {
  return new URL(locatable.toString(), document.baseURI);
}

function getAnchor(url) {
  let anchorMatch;
  if (url.hash) {
    return url.hash.slice(1);
  } else if (anchorMatch = url.href.match(/#(.*)$/)) {
    return anchorMatch[1];
  }
}

function getExtension(url) {
  return (getLastPathComponent(url).match(/\.[^.]*$/) || [])[0] || "";
}

function isHTML(url) {
  return !!getExtension(url).match(/^(?:|\.(?:htm|html|xhtml))$/);
}

function isPrefixedBy(baseURL, url) {
  const prefix = getPrefix(url);
  return baseURL.href === expandURL(prefix).href || baseURL.href.startsWith(prefix);
}

function getRequestURL(url) {
  const anchor = getAnchor(url);
  return anchor != null ? url.href.slice(0, -(anchor.length + 1)) : url.href;
}

function toCacheKey(url) {
  return getRequestURL(url);
}

function urlsAreEqual(left, right) {
  return expandURL(left).href == expandURL(right).href;
}

function getPathComponents(url) {
  return url.pathname.split("/").slice(1);
}

function getLastPathComponent(url) {
  return getPathComponents(url).slice(-1)[0];
}

function getPrefix(url) {
  return addTrailingSlash(url.origin + url.pathname);
}

function addTrailingSlash(value) {
  return value.endsWith("/") ? value : value + "/";
}

class FetchResponse {
  constructor(response) {
    this.response = response;
  }
  get succeeded() {
    return this.response.ok;
  }
  get failed() {
    return !this.succeeded;
  }
  get clientError() {
    return this.statusCode >= 400 && this.statusCode <= 499;
  }
  get serverError() {
    return this.statusCode >= 500 && this.statusCode <= 599;
  }
  get redirected() {
    return this.response.redirected;
  }
  get location() {
    return expandURL(this.response.url);
  }
  get isHTML() {
    return this.contentType && this.contentType.match(/^(?:text\/([^\s;,]+\b)?html|application\/xhtml\+xml)\b/);
  }
  get statusCode() {
    return this.response.status;
  }
  get contentType() {
    return this.header("Content-Type");
  }
  get responseText() {
    return this.response.clone().text();
  }
  get responseHTML() {
    if (this.isHTML) {
      return this.response.clone().text();
    } else {
      return Promise.resolve(undefined);
    }
  }
  header(name) {
    return this.response.headers.get(name);
  }
}

function dispatch(eventName, {target: target, cancelable: cancelable, detail: detail} = {}) {
  const event = new CustomEvent(eventName, {
    cancelable: cancelable,
    bubbles: true,
    detail: detail
  });
  if (target && target.isConnected) {
    target.dispatchEvent(event);
  } else {
    document.documentElement.dispatchEvent(event);
  }
  return event;
}

function nextAnimationFrame() {
  return new Promise((resolve => requestAnimationFrame((() => resolve()))));
}

function nextEventLoopTick() {
  return new Promise((resolve => setTimeout((() => resolve()), 0)));
}

function nextMicrotask() {
  return Promise.resolve();
}

function parseHTMLDocument(html = "") {
  return (new DOMParser).parseFromString(html, "text/html");
}

function unindent(strings, ...values) {
  const lines = interpolate(strings, values).replace(/^\n/, "").split("\n");
  const match = lines[0].match(/^\s+/);
  const indent = match ? match[0].length : 0;
  return lines.map((line => line.slice(indent))).join("\n");
}

function interpolate(strings, values) {
  return strings.reduce(((result, string, i) => {
    const value = values[i] == undefined ? "" : values[i];
    return result + string + value;
  }), "");
}

function uuid() {
  return Array.apply(null, {
    length: 36
  }).map(((_, i) => {
    if (i == 8 || i == 13 || i == 18 || i == 23) {
      return "-";
    } else if (i == 14) {
      return "4";
    } else if (i == 19) {
      return (Math.floor(Math.random() * 4) + 8).toString(16);
    } else {
      return Math.floor(Math.random() * 15).toString(16);
    }
  })).join("");
}

var FetchMethod;

(function(FetchMethod) {
  FetchMethod[FetchMethod["get"] = 0] = "get";
  FetchMethod[FetchMethod["post"] = 1] = "post";
  FetchMethod[FetchMethod["put"] = 2] = "put";
  FetchMethod[FetchMethod["patch"] = 3] = "patch";
  FetchMethod[FetchMethod["delete"] = 4] = "delete";
})(FetchMethod || (FetchMethod = {}));

function fetchMethodFromString(method) {
  switch (method.toLowerCase()) {
   case "get":
    return FetchMethod.get;

   case "post":
    return FetchMethod.post;

   case "put":
    return FetchMethod.put;

   case "patch":
    return FetchMethod.patch;

   case "delete":
    return FetchMethod.delete;
  }
}

class FetchRequest {
  constructor(delegate, method, location, body = new URLSearchParams, target = null) {
    this.abortController = new AbortController;
    this.resolveRequestPromise = value => {};
    this.delegate = delegate;
    this.method = method;
    this.headers = this.defaultHeaders;
    if (this.isIdempotent) {
      this.url = mergeFormDataEntries(location, [ ...body.entries() ]);
    } else {
      this.body = body;
      this.url = location;
    }
    this.target = target;
  }
  get location() {
    return this.url;
  }
  get params() {
    return this.url.searchParams;
  }
  get entries() {
    return this.body ? Array.from(this.body.entries()) : [];
  }
  cancel() {
    this.abortController.abort();
  }
  async perform() {
    var _a, _b;
    const {fetchOptions: fetchOptions} = this;
    (_b = (_a = this.delegate).prepareHeadersForRequest) === null || _b === void 0 ? void 0 : _b.call(_a, this.headers, this);
    await this.allowRequestToBeIntercepted(fetchOptions);
    try {
      this.delegate.requestStarted(this);
      const response = await fetch(this.url.href, fetchOptions);
      return await this.receive(response);
    } catch (error) {
      if (error.name !== "AbortError") {
        this.delegate.requestErrored(this, error);
        throw error;
      }
    } finally {
      this.delegate.requestFinished(this);
    }
  }
  async receive(response) {
    const fetchResponse = new FetchResponse(response);
    const event = dispatch("turbo:before-fetch-response", {
      cancelable: true,
      detail: {
        fetchResponse: fetchResponse
      },
      target: this.target
    });
    if (event.defaultPrevented) {
      this.delegate.requestPreventedHandlingResponse(this, fetchResponse);
    } else if (fetchResponse.succeeded) {
      this.delegate.requestSucceededWithResponse(this, fetchResponse);
    } else {
      this.delegate.requestFailedWithResponse(this, fetchResponse);
    }
    return fetchResponse;
  }
  get fetchOptions() {
    var _a;
    return {
      method: FetchMethod[this.method].toUpperCase(),
      credentials: "same-origin",
      headers: this.headers,
      redirect: "follow",
      body: this.body,
      signal: this.abortSignal,
      referrer: (_a = this.delegate.referrer) === null || _a === void 0 ? void 0 : _a.href
    };
  }
  get defaultHeaders() {
    return {
      Accept: "text/html, application/xhtml+xml"
    };
  }
  get isIdempotent() {
    return this.method == FetchMethod.get;
  }
  get abortSignal() {
    return this.abortController.signal;
  }
  async allowRequestToBeIntercepted(fetchOptions) {
    const requestInterception = new Promise((resolve => this.resolveRequestPromise = resolve));
    const event = dispatch("turbo:before-fetch-request", {
      cancelable: true,
      detail: {
        fetchOptions: fetchOptions,
        url: this.url.href,
        resume: this.resolveRequestPromise
      },
      target: this.target
    });
    if (event.defaultPrevented) await requestInterception;
  }
}

function mergeFormDataEntries(url, entries) {
  const currentSearchParams = new URLSearchParams(url.search);
  for (const [name, value] of entries) {
    if (value instanceof File) continue;
    if (currentSearchParams.has(name)) {
      currentSearchParams.delete(name);
      url.searchParams.set(name, value);
    } else {
      url.searchParams.append(name, value);
    }
  }
  return url;
}

class AppearanceObserver {
  constructor(delegate, element) {
    this.started = false;
    this.intersect = entries => {
      const lastEntry = entries.slice(-1)[0];
      if (lastEntry === null || lastEntry === void 0 ? void 0 : lastEntry.isIntersecting) {
        this.delegate.elementAppearedInViewport(this.element);
      }
    };
    this.delegate = delegate;
    this.element = element;
    this.intersectionObserver = new IntersectionObserver(this.intersect);
  }
  start() {
    if (!this.started) {
      this.started = true;
      this.intersectionObserver.observe(this.element);
    }
  }
  stop() {
    if (this.started) {
      this.started = false;
      this.intersectionObserver.unobserve(this.element);
    }
  }
}

class StreamMessage {
  constructor(html) {
    this.templateElement = document.createElement("template");
    this.templateElement.innerHTML = html;
  }
  static wrap(message) {
    if (typeof message == "string") {
      return new this(message);
    } else {
      return message;
    }
  }
  get fragment() {
    const fragment = document.createDocumentFragment();
    for (const element of this.foreignElements) {
      fragment.appendChild(document.importNode(element, true));
    }
    return fragment;
  }
  get foreignElements() {
    return this.templateChildren.reduce(((streamElements, child) => {
      if (child.tagName.toLowerCase() == "turbo-stream") {
        return [ ...streamElements, child ];
      } else {
        return streamElements;
      }
    }), []);
  }
  get templateChildren() {
    return Array.from(this.templateElement.content.children);
  }
}

StreamMessage.contentType = "text/vnd.turbo-stream.html";

var FormSubmissionState;

(function(FormSubmissionState) {
  FormSubmissionState[FormSubmissionState["initialized"] = 0] = "initialized";
  FormSubmissionState[FormSubmissionState["requesting"] = 1] = "requesting";
  FormSubmissionState[FormSubmissionState["waiting"] = 2] = "waiting";
  FormSubmissionState[FormSubmissionState["receiving"] = 3] = "receiving";
  FormSubmissionState[FormSubmissionState["stopping"] = 4] = "stopping";
  FormSubmissionState[FormSubmissionState["stopped"] = 5] = "stopped";
})(FormSubmissionState || (FormSubmissionState = {}));

var FormEnctype;

(function(FormEnctype) {
  FormEnctype["urlEncoded"] = "application/x-www-form-urlencoded";
  FormEnctype["multipart"] = "multipart/form-data";
  FormEnctype["plain"] = "text/plain";
})(FormEnctype || (FormEnctype = {}));

function formEnctypeFromString(encoding) {
  switch (encoding.toLowerCase()) {
   case FormEnctype.multipart:
    return FormEnctype.multipart;

   case FormEnctype.plain:
    return FormEnctype.plain;

   default:
    return FormEnctype.urlEncoded;
  }
}

class FormSubmission {
  constructor(delegate, formElement, submitter, mustRedirect = false) {
    this.state = FormSubmissionState.initialized;
    this.delegate = delegate;
    this.formElement = formElement;
    this.submitter = submitter;
    this.formData = buildFormData(formElement, submitter);
    this.fetchRequest = new FetchRequest(this, this.method, this.location, this.body, this.formElement);
    this.mustRedirect = mustRedirect;
  }
  get method() {
    var _a;
    const method = ((_a = this.submitter) === null || _a === void 0 ? void 0 : _a.getAttribute("formmethod")) || this.formElement.getAttribute("method") || "";
    return fetchMethodFromString(method.toLowerCase()) || FetchMethod.get;
  }
  get action() {
    var _a;
    const formElementAction = typeof this.formElement.action === "string" ? this.formElement.action : null;
    return ((_a = this.submitter) === null || _a === void 0 ? void 0 : _a.getAttribute("formaction")) || this.formElement.getAttribute("action") || formElementAction || "";
  }
  get location() {
    return expandURL(this.action);
  }
  get body() {
    if (this.enctype == FormEnctype.urlEncoded || this.method == FetchMethod.get) {
      return new URLSearchParams(this.stringFormData);
    } else {
      return this.formData;
    }
  }
  get enctype() {
    var _a;
    return formEnctypeFromString(((_a = this.submitter) === null || _a === void 0 ? void 0 : _a.getAttribute("formenctype")) || this.formElement.enctype);
  }
  get isIdempotent() {
    return this.fetchRequest.isIdempotent;
  }
  get stringFormData() {
    return [ ...this.formData ].reduce(((entries, [name, value]) => entries.concat(typeof value == "string" ? [ [ name, value ] ] : [])), []);
  }
  async start() {
    const {initialized: initialized, requesting: requesting} = FormSubmissionState;
    if (this.state == initialized) {
      this.state = requesting;
      return this.fetchRequest.perform();
    }
  }
  stop() {
    const {stopping: stopping, stopped: stopped} = FormSubmissionState;
    if (this.state != stopping && this.state != stopped) {
      this.state = stopping;
      this.fetchRequest.cancel();
      return true;
    }
  }
  prepareHeadersForRequest(headers, request) {
    if (!request.isIdempotent) {
      const token = getCookieValue(getMetaContent("csrf-param")) || getMetaContent("csrf-token");
      if (token) {
        headers["X-CSRF-Token"] = token;
      }
      headers["Accept"] = [ StreamMessage.contentType, headers["Accept"] ].join(", ");
    }
  }
  requestStarted(request) {
    this.state = FormSubmissionState.waiting;
    dispatch("turbo:submit-start", {
      target: this.formElement,
      detail: {
        formSubmission: this
      }
    });
    this.delegate.formSubmissionStarted(this);
  }
  requestPreventedHandlingResponse(request, response) {
    this.result = {
      success: response.succeeded,
      fetchResponse: response
    };
  }
  requestSucceededWithResponse(request, response) {
    if (response.clientError || response.serverError) {
      this.delegate.formSubmissionFailedWithResponse(this, response);
    } else if (this.requestMustRedirect(request) && responseSucceededWithoutRedirect(response)) {
      const error = new Error("Form responses must redirect to another location");
      this.delegate.formSubmissionErrored(this, error);
    } else {
      this.state = FormSubmissionState.receiving;
      this.result = {
        success: true,
        fetchResponse: response
      };
      this.delegate.formSubmissionSucceededWithResponse(this, response);
    }
  }
  requestFailedWithResponse(request, response) {
    this.result = {
      success: false,
      fetchResponse: response
    };
    this.delegate.formSubmissionFailedWithResponse(this, response);
  }
  requestErrored(request, error) {
    this.result = {
      success: false,
      error: error
    };
    this.delegate.formSubmissionErrored(this, error);
  }
  requestFinished(request) {
    this.state = FormSubmissionState.stopped;
    dispatch("turbo:submit-end", {
      target: this.formElement,
      detail: Object.assign({
        formSubmission: this
      }, this.result)
    });
    this.delegate.formSubmissionFinished(this);
  }
  requestMustRedirect(request) {
    return !request.isIdempotent && this.mustRedirect;
  }
}

function buildFormData(formElement, submitter) {
  const formData = new FormData(formElement);
  const name = submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("name");
  const value = submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("value");
  if (name && value != null && formData.get(name) != value) {
    formData.append(name, value);
  }
  return formData;
}

function getCookieValue(cookieName) {
  if (cookieName != null) {
    const cookies = document.cookie ? document.cookie.split("; ") : [];
    const cookie = cookies.find((cookie => cookie.startsWith(cookieName)));
    if (cookie) {
      const value = cookie.split("=").slice(1).join("=");
      return value ? decodeURIComponent(value) : undefined;
    }
  }
}

function getMetaContent(name) {
  const element = document.querySelector(`meta[name="${name}"]`);
  return element && element.content;
}

function responseSucceededWithoutRedirect(response) {
  return response.statusCode == 200 && !response.redirected;
}

class Snapshot {
  constructor(element) {
    this.element = element;
  }
  get children() {
    return [ ...this.element.children ];
  }
  hasAnchor(anchor) {
    return this.getElementForAnchor(anchor) != null;
  }
  getElementForAnchor(anchor) {
    return anchor ? this.element.querySelector(`[id='${anchor}'], a[name='${anchor}']`) : null;
  }
  get isConnected() {
    return this.element.isConnected;
  }
  get firstAutofocusableElement() {
    return this.element.querySelector("[autofocus]");
  }
  get permanentElements() {
    return [ ...this.element.querySelectorAll("[id][data-turbo-permanent]") ];
  }
  getPermanentElementById(id) {
    return this.element.querySelector(`#${id}[data-turbo-permanent]`);
  }
  getPermanentElementMapForSnapshot(snapshot) {
    const permanentElementMap = {};
    for (const currentPermanentElement of this.permanentElements) {
      const {id: id} = currentPermanentElement;
      const newPermanentElement = snapshot.getPermanentElementById(id);
      if (newPermanentElement) {
        permanentElementMap[id] = [ currentPermanentElement, newPermanentElement ];
      }
    }
    return permanentElementMap;
  }
}

class FormInterceptor {
  constructor(delegate, element) {
    this.submitBubbled = event => {
      const form = event.target;
      if (form instanceof HTMLFormElement && form.closest("turbo-frame, html") == this.element) {
        const submitter = event.submitter || undefined;
        if (this.delegate.shouldInterceptFormSubmission(form, submitter)) {
          event.preventDefault();
          event.stopImmediatePropagation();
          this.delegate.formSubmissionIntercepted(form, submitter);
        }
      }
    };
    this.delegate = delegate;
    this.element = element;
  }
  start() {
    this.element.addEventListener("submit", this.submitBubbled);
  }
  stop() {
    this.element.removeEventListener("submit", this.submitBubbled);
  }
}

class View {
  constructor(delegate, element) {
    this.resolveRenderPromise = value => {};
    this.resolveInterceptionPromise = value => {};
    this.delegate = delegate;
    this.element = element;
  }
  scrollToAnchor(anchor) {
    const element = this.snapshot.getElementForAnchor(anchor);
    if (element) {
      this.scrollToElement(element);
      this.focusElement(element);
    } else {
      this.scrollToPosition({
        x: 0,
        y: 0
      });
    }
  }
  scrollToAnchorFromLocation(location) {
    this.scrollToAnchor(getAnchor(location));
  }
  scrollToElement(element) {
    element.scrollIntoView();
  }
  focusElement(element) {
    if (element instanceof HTMLElement) {
      if (element.hasAttribute("tabindex")) {
        element.focus();
      } else {
        element.setAttribute("tabindex", "-1");
        element.focus();
        element.removeAttribute("tabindex");
      }
    }
  }
  scrollToPosition({x: x, y: y}) {
    this.scrollRoot.scrollTo(x, y);
  }
  scrollToTop() {
    this.scrollToPosition({
      x: 0,
      y: 0
    });
  }
  get scrollRoot() {
    return window;
  }
  async render(renderer) {
    const {isPreview: isPreview, shouldRender: shouldRender, newSnapshot: snapshot} = renderer;
    if (shouldRender) {
      try {
        this.renderPromise = new Promise((resolve => this.resolveRenderPromise = resolve));
        this.renderer = renderer;
        this.prepareToRenderSnapshot(renderer);
        const renderInterception = new Promise((resolve => this.resolveInterceptionPromise = resolve));
        const immediateRender = this.delegate.allowsImmediateRender(snapshot, this.resolveInterceptionPromise);
        if (!immediateRender) await renderInterception;
        await this.renderSnapshot(renderer);
        this.delegate.viewRenderedSnapshot(snapshot, isPreview);
        this.finishRenderingSnapshot(renderer);
      } finally {
        delete this.renderer;
        this.resolveRenderPromise(undefined);
        delete this.renderPromise;
      }
    } else {
      this.invalidate();
    }
  }
  invalidate() {
    this.delegate.viewInvalidated();
  }
  prepareToRenderSnapshot(renderer) {
    this.markAsPreview(renderer.isPreview);
    renderer.prepareToRender();
  }
  markAsPreview(isPreview) {
    if (isPreview) {
      this.element.setAttribute("data-turbo-preview", "");
    } else {
      this.element.removeAttribute("data-turbo-preview");
    }
  }
  async renderSnapshot(renderer) {
    await renderer.render();
  }
  finishRenderingSnapshot(renderer) {
    renderer.finishRendering();
  }
}

class FrameView extends View {
  invalidate() {
    this.element.innerHTML = "";
  }
  get snapshot() {
    return new Snapshot(this.element);
  }
}

class LinkInterceptor {
  constructor(delegate, element) {
    this.clickBubbled = event => {
      if (this.respondsToEventTarget(event.target)) {
        this.clickEvent = event;
      } else {
        delete this.clickEvent;
      }
    };
    this.linkClicked = event => {
      if (this.clickEvent && this.respondsToEventTarget(event.target) && event.target instanceof Element) {
        if (this.delegate.shouldInterceptLinkClick(event.target, event.detail.url)) {
          this.clickEvent.preventDefault();
          event.preventDefault();
          this.delegate.linkClickIntercepted(event.target, event.detail.url);
        }
      }
      delete this.clickEvent;
    };
    this.willVisit = () => {
      delete this.clickEvent;
    };
    this.delegate = delegate;
    this.element = element;
  }
  start() {
    this.element.addEventListener("click", this.clickBubbled);
    document.addEventListener("turbo:click", this.linkClicked);
    document.addEventListener("turbo:before-visit", this.willVisit);
  }
  stop() {
    this.element.removeEventListener("click", this.clickBubbled);
    document.removeEventListener("turbo:click", this.linkClicked);
    document.removeEventListener("turbo:before-visit", this.willVisit);
  }
  respondsToEventTarget(target) {
    const element = target instanceof Element ? target : target instanceof Node ? target.parentElement : null;
    return element && element.closest("turbo-frame, html") == this.element;
  }
}

class Bardo {
  constructor(permanentElementMap) {
    this.permanentElementMap = permanentElementMap;
  }
  static preservingPermanentElements(permanentElementMap, callback) {
    const bardo = new this(permanentElementMap);
    bardo.enter();
    callback();
    bardo.leave();
  }
  enter() {
    for (const id in this.permanentElementMap) {
      const [, newPermanentElement] = this.permanentElementMap[id];
      this.replaceNewPermanentElementWithPlaceholder(newPermanentElement);
    }
  }
  leave() {
    for (const id in this.permanentElementMap) {
      const [currentPermanentElement] = this.permanentElementMap[id];
      this.replaceCurrentPermanentElementWithClone(currentPermanentElement);
      this.replacePlaceholderWithPermanentElement(currentPermanentElement);
    }
  }
  replaceNewPermanentElementWithPlaceholder(permanentElement) {
    const placeholder = createPlaceholderForPermanentElement(permanentElement);
    permanentElement.replaceWith(placeholder);
  }
  replaceCurrentPermanentElementWithClone(permanentElement) {
    const clone = permanentElement.cloneNode(true);
    permanentElement.replaceWith(clone);
  }
  replacePlaceholderWithPermanentElement(permanentElement) {
    const placeholder = this.getPlaceholderById(permanentElement.id);
    placeholder === null || placeholder === void 0 ? void 0 : placeholder.replaceWith(permanentElement);
  }
  getPlaceholderById(id) {
    return this.placeholders.find((element => element.content == id));
  }
  get placeholders() {
    return [ ...document.querySelectorAll("meta[name=turbo-permanent-placeholder][content]") ];
  }
}

function createPlaceholderForPermanentElement(permanentElement) {
  const element = document.createElement("meta");
  element.setAttribute("name", "turbo-permanent-placeholder");
  element.setAttribute("content", permanentElement.id);
  return element;
}

class Renderer {
  constructor(currentSnapshot, newSnapshot, isPreview) {
    this.currentSnapshot = currentSnapshot;
    this.newSnapshot = newSnapshot;
    this.isPreview = isPreview;
    this.promise = new Promise(((resolve, reject) => this.resolvingFunctions = {
      resolve: resolve,
      reject: reject
    }));
  }
  get shouldRender() {
    return true;
  }
  prepareToRender() {
    return;
  }
  finishRendering() {
    if (this.resolvingFunctions) {
      this.resolvingFunctions.resolve();
      delete this.resolvingFunctions;
    }
  }
  createScriptElement(element) {
    if (element.getAttribute("data-turbo-eval") == "false") {
      return element;
    } else {
      const createdScriptElement = document.createElement("script");
      if (this.cspNonce) {
        createdScriptElement.nonce = this.cspNonce;
      }
      createdScriptElement.textContent = element.textContent;
      createdScriptElement.async = false;
      copyElementAttributes(createdScriptElement, element);
      return createdScriptElement;
    }
  }
  preservingPermanentElements(callback) {
    Bardo.preservingPermanentElements(this.permanentElementMap, callback);
  }
  focusFirstAutofocusableElement() {
    const element = this.connectedSnapshot.firstAutofocusableElement;
    if (elementIsFocusable(element)) {
      element.focus();
    }
  }
  get connectedSnapshot() {
    return this.newSnapshot.isConnected ? this.newSnapshot : this.currentSnapshot;
  }
  get currentElement() {
    return this.currentSnapshot.element;
  }
  get newElement() {
    return this.newSnapshot.element;
  }
  get permanentElementMap() {
    return this.currentSnapshot.getPermanentElementMapForSnapshot(this.newSnapshot);
  }
  get cspNonce() {
    var _a;
    return (_a = document.head.querySelector('meta[name="csp-nonce"]')) === null || _a === void 0 ? void 0 : _a.getAttribute("content");
  }
}

function copyElementAttributes(destinationElement, sourceElement) {
  for (const {name: name, value: value} of [ ...sourceElement.attributes ]) {
    destinationElement.setAttribute(name, value);
  }
}

function elementIsFocusable(element) {
  return element && typeof element.focus == "function";
}

class FrameRenderer extends Renderer {
  get shouldRender() {
    return true;
  }
  async render() {
    await nextAnimationFrame();
    this.preservingPermanentElements((() => {
      this.loadFrameElement();
    }));
    this.scrollFrameIntoView();
    await nextAnimationFrame();
    this.focusFirstAutofocusableElement();
    await nextAnimationFrame();
    this.activateScriptElements();
  }
  loadFrameElement() {
    var _a;
    const destinationRange = document.createRange();
    destinationRange.selectNodeContents(this.currentElement);
    destinationRange.deleteContents();
    const frameElement = this.newElement;
    const sourceRange = (_a = frameElement.ownerDocument) === null || _a === void 0 ? void 0 : _a.createRange();
    if (sourceRange) {
      sourceRange.selectNodeContents(frameElement);
      this.currentElement.appendChild(sourceRange.extractContents());
    }
  }
  scrollFrameIntoView() {
    if (this.currentElement.autoscroll || this.newElement.autoscroll) {
      const element = this.currentElement.firstElementChild;
      const block = readScrollLogicalPosition(this.currentElement.getAttribute("data-autoscroll-block"), "end");
      if (element) {
        element.scrollIntoView({
          block: block
        });
        return true;
      }
    }
    return false;
  }
  activateScriptElements() {
    for (const inertScriptElement of this.newScriptElements) {
      const activatedScriptElement = this.createScriptElement(inertScriptElement);
      inertScriptElement.replaceWith(activatedScriptElement);
    }
  }
  get newScriptElements() {
    return this.currentElement.querySelectorAll("script");
  }
}

function readScrollLogicalPosition(value, defaultValue) {
  if (value == "end" || value == "start" || value == "center" || value == "nearest") {
    return value;
  } else {
    return defaultValue;
  }
}

class ProgressBar {
  constructor() {
    this.hiding = false;
    this.value = 0;
    this.visible = false;
    this.trickle = () => {
      this.setValue(this.value + Math.random() / 100);
    };
    this.stylesheetElement = this.createStylesheetElement();
    this.progressElement = this.createProgressElement();
    this.installStylesheetElement();
    this.setValue(0);
  }
  static get defaultCSS() {
    return unindent`
      .turbo-progress-bar {
        position: fixed;
        display: block;
        top: 0;
        left: 0;
        height: 3px;
        background: #0076ff;
        z-index: 9999;
        transition:
          width ${ProgressBar.animationDuration}ms ease-out,
          opacity ${ProgressBar.animationDuration / 2}ms ${ProgressBar.animationDuration / 2}ms ease-in;
        transform: translate3d(0, 0, 0);
      }
    `;
  }
  show() {
    if (!this.visible) {
      this.visible = true;
      this.installProgressElement();
      this.startTrickling();
    }
  }
  hide() {
    if (this.visible && !this.hiding) {
      this.hiding = true;
      this.fadeProgressElement((() => {
        this.uninstallProgressElement();
        this.stopTrickling();
        this.visible = false;
        this.hiding = false;
      }));
    }
  }
  setValue(value) {
    this.value = value;
    this.refresh();
  }
  installStylesheetElement() {
    document.head.insertBefore(this.stylesheetElement, document.head.firstChild);
  }
  installProgressElement() {
    this.progressElement.style.width = "0";
    this.progressElement.style.opacity = "1";
    document.documentElement.insertBefore(this.progressElement, document.body);
    this.refresh();
  }
  fadeProgressElement(callback) {
    this.progressElement.style.opacity = "0";
    setTimeout(callback, ProgressBar.animationDuration * 1.5);
  }
  uninstallProgressElement() {
    if (this.progressElement.parentNode) {
      document.documentElement.removeChild(this.progressElement);
    }
  }
  startTrickling() {
    if (!this.trickleInterval) {
      this.trickleInterval = window.setInterval(this.trickle, ProgressBar.animationDuration);
    }
  }
  stopTrickling() {
    window.clearInterval(this.trickleInterval);
    delete this.trickleInterval;
  }
  refresh() {
    requestAnimationFrame((() => {
      this.progressElement.style.width = `${10 + this.value * 90}%`;
    }));
  }
  createStylesheetElement() {
    const element = document.createElement("style");
    element.type = "text/css";
    element.textContent = ProgressBar.defaultCSS;
    return element;
  }
  createProgressElement() {
    const element = document.createElement("div");
    element.className = "turbo-progress-bar";
    return element;
  }
}

ProgressBar.animationDuration = 300;

class HeadSnapshot extends Snapshot {
  constructor() {
    super(...arguments);
    this.detailsByOuterHTML = this.children.filter((element => !elementIsNoscript(element))).map((element => elementWithoutNonce(element))).reduce(((result, element) => {
      const {outerHTML: outerHTML} = element;
      const details = outerHTML in result ? result[outerHTML] : {
        type: elementType(element),
        tracked: elementIsTracked(element),
        elements: []
      };
      return Object.assign(Object.assign({}, result), {
        [outerHTML]: Object.assign(Object.assign({}, details), {
          elements: [ ...details.elements, element ]
        })
      });
    }), {});
  }
  get trackedElementSignature() {
    return Object.keys(this.detailsByOuterHTML).filter((outerHTML => this.detailsByOuterHTML[outerHTML].tracked)).join("");
  }
  getScriptElementsNotInSnapshot(snapshot) {
    return this.getElementsMatchingTypeNotInSnapshot("script", snapshot);
  }
  getStylesheetElementsNotInSnapshot(snapshot) {
    return this.getElementsMatchingTypeNotInSnapshot("stylesheet", snapshot);
  }
  getElementsMatchingTypeNotInSnapshot(matchedType, snapshot) {
    return Object.keys(this.detailsByOuterHTML).filter((outerHTML => !(outerHTML in snapshot.detailsByOuterHTML))).map((outerHTML => this.detailsByOuterHTML[outerHTML])).filter((({type: type}) => type == matchedType)).map((({elements: [element]}) => element));
  }
  get provisionalElements() {
    return Object.keys(this.detailsByOuterHTML).reduce(((result, outerHTML) => {
      const {type: type, tracked: tracked, elements: elements} = this.detailsByOuterHTML[outerHTML];
      if (type == null && !tracked) {
        return [ ...result, ...elements ];
      } else if (elements.length > 1) {
        return [ ...result, ...elements.slice(1) ];
      } else {
        return result;
      }
    }), []);
  }
  getMetaValue(name) {
    const element = this.findMetaElementByName(name);
    return element ? element.getAttribute("content") : null;
  }
  findMetaElementByName(name) {
    return Object.keys(this.detailsByOuterHTML).reduce(((result, outerHTML) => {
      const {elements: [element]} = this.detailsByOuterHTML[outerHTML];
      return elementIsMetaElementWithName(element, name) ? element : result;
    }), undefined);
  }
}

function elementType(element) {
  if (elementIsScript(element)) {
    return "script";
  } else if (elementIsStylesheet(element)) {
    return "stylesheet";
  }
}

function elementIsTracked(element) {
  return element.getAttribute("data-turbo-track") == "reload";
}

function elementIsScript(element) {
  const tagName = element.tagName.toLowerCase();
  return tagName == "script";
}

function elementIsNoscript(element) {
  const tagName = element.tagName.toLowerCase();
  return tagName == "noscript";
}

function elementIsStylesheet(element) {
  const tagName = element.tagName.toLowerCase();
  return tagName == "style" || tagName == "link" && element.getAttribute("rel") == "stylesheet";
}

function elementIsMetaElementWithName(element, name) {
  const tagName = element.tagName.toLowerCase();
  return tagName == "meta" && element.getAttribute("name") == name;
}

function elementWithoutNonce(element) {
  if (element.hasAttribute("nonce")) {
    element.setAttribute("nonce", "");
  }
  return element;
}

class PageSnapshot extends Snapshot {
  constructor(element, headSnapshot) {
    super(element);
    this.headSnapshot = headSnapshot;
  }
  static fromHTMLString(html = "") {
    return this.fromDocument(parseHTMLDocument(html));
  }
  static fromElement(element) {
    return this.fromDocument(element.ownerDocument);
  }
  static fromDocument({head: head, body: body}) {
    return new this(body, new HeadSnapshot(head));
  }
  clone() {
    return new PageSnapshot(this.element.cloneNode(true), this.headSnapshot);
  }
  get headElement() {
    return this.headSnapshot.element;
  }
  get rootLocation() {
    var _a;
    const root = (_a = this.getSetting("root")) !== null && _a !== void 0 ? _a : "/";
    return expandURL(root);
  }
  get cacheControlValue() {
    return this.getSetting("cache-control");
  }
  get isPreviewable() {
    return this.cacheControlValue != "no-preview";
  }
  get isCacheable() {
    return this.cacheControlValue != "no-cache";
  }
  get isVisitable() {
    return this.getSetting("visit-control") != "reload";
  }
  getSetting(name) {
    return this.headSnapshot.getMetaValue(`turbo-${name}`);
  }
}

var TimingMetric;

(function(TimingMetric) {
  TimingMetric["visitStart"] = "visitStart";
  TimingMetric["requestStart"] = "requestStart";
  TimingMetric["requestEnd"] = "requestEnd";
  TimingMetric["visitEnd"] = "visitEnd";
})(TimingMetric || (TimingMetric = {}));

var VisitState;

(function(VisitState) {
  VisitState["initialized"] = "initialized";
  VisitState["started"] = "started";
  VisitState["canceled"] = "canceled";
  VisitState["failed"] = "failed";
  VisitState["completed"] = "completed";
})(VisitState || (VisitState = {}));

const defaultOptions = {
  action: "advance",
  historyChanged: false
};

var SystemStatusCode;

(function(SystemStatusCode) {
  SystemStatusCode[SystemStatusCode["networkFailure"] = 0] = "networkFailure";
  SystemStatusCode[SystemStatusCode["timeoutFailure"] = -1] = "timeoutFailure";
  SystemStatusCode[SystemStatusCode["contentTypeMismatch"] = -2] = "contentTypeMismatch";
})(SystemStatusCode || (SystemStatusCode = {}));

class Visit {
  constructor(delegate, location, restorationIdentifier, options = {}) {
    this.identifier = uuid();
    this.timingMetrics = {};
    this.followedRedirect = false;
    this.historyChanged = false;
    this.scrolled = false;
    this.snapshotCached = false;
    this.state = VisitState.initialized;
    this.delegate = delegate;
    this.location = location;
    this.restorationIdentifier = restorationIdentifier || uuid();
    const {action: action, historyChanged: historyChanged, referrer: referrer, snapshotHTML: snapshotHTML, response: response} = Object.assign(Object.assign({}, defaultOptions), options);
    this.action = action;
    this.historyChanged = historyChanged;
    this.referrer = referrer;
    this.snapshotHTML = snapshotHTML;
    this.response = response;
    this.isSamePage = this.delegate.locationWithActionIsSamePage(this.location, this.action);
  }
  get adapter() {
    return this.delegate.adapter;
  }
  get view() {
    return this.delegate.view;
  }
  get history() {
    return this.delegate.history;
  }
  get restorationData() {
    return this.history.getRestorationDataForIdentifier(this.restorationIdentifier);
  }
  get silent() {
    return this.isSamePage;
  }
  start() {
    if (this.state == VisitState.initialized) {
      this.recordTimingMetric(TimingMetric.visitStart);
      this.state = VisitState.started;
      this.adapter.visitStarted(this);
      this.delegate.visitStarted(this);
    }
  }
  cancel() {
    if (this.state == VisitState.started) {
      if (this.request) {
        this.request.cancel();
      }
      this.cancelRender();
      this.state = VisitState.canceled;
    }
  }
  complete() {
    if (this.state == VisitState.started) {
      this.recordTimingMetric(TimingMetric.visitEnd);
      this.state = VisitState.completed;
      this.adapter.visitCompleted(this);
      this.delegate.visitCompleted(this);
      this.followRedirect();
    }
  }
  fail() {
    if (this.state == VisitState.started) {
      this.state = VisitState.failed;
      this.adapter.visitFailed(this);
    }
  }
  changeHistory() {
    var _a;
    if (!this.historyChanged) {
      const actionForHistory = this.location.href === ((_a = this.referrer) === null || _a === void 0 ? void 0 : _a.href) ? "replace" : this.action;
      const method = this.getHistoryMethodForAction(actionForHistory);
      this.history.update(method, this.location, this.restorationIdentifier);
      this.historyChanged = true;
    }
  }
  issueRequest() {
    if (this.hasPreloadedResponse()) {
      this.simulateRequest();
    } else if (this.shouldIssueRequest() && !this.request) {
      this.request = new FetchRequest(this, FetchMethod.get, this.location);
      this.request.perform();
    }
  }
  simulateRequest() {
    if (this.response) {
      this.startRequest();
      this.recordResponse();
      this.finishRequest();
    }
  }
  startRequest() {
    this.recordTimingMetric(TimingMetric.requestStart);
    this.adapter.visitRequestStarted(this);
  }
  recordResponse(response = this.response) {
    this.response = response;
    if (response) {
      const {statusCode: statusCode} = response;
      if (isSuccessful(statusCode)) {
        this.adapter.visitRequestCompleted(this);
      } else {
        this.adapter.visitRequestFailedWithStatusCode(this, statusCode);
      }
    }
  }
  finishRequest() {
    this.recordTimingMetric(TimingMetric.requestEnd);
    this.adapter.visitRequestFinished(this);
  }
  loadResponse() {
    if (this.response) {
      const {statusCode: statusCode, responseHTML: responseHTML} = this.response;
      this.render((async () => {
        this.cacheSnapshot();
        if (this.view.renderPromise) await this.view.renderPromise;
        if (isSuccessful(statusCode) && responseHTML != null) {
          await this.view.renderPage(PageSnapshot.fromHTMLString(responseHTML));
          this.adapter.visitRendered(this);
          this.complete();
        } else {
          await this.view.renderError(PageSnapshot.fromHTMLString(responseHTML));
          this.adapter.visitRendered(this);
          this.fail();
        }
      }));
    }
  }
  getCachedSnapshot() {
    const snapshot = this.view.getCachedSnapshotForLocation(this.location) || this.getPreloadedSnapshot();
    if (snapshot && (!getAnchor(this.location) || snapshot.hasAnchor(getAnchor(this.location)))) {
      if (this.action == "restore" || snapshot.isPreviewable) {
        return snapshot;
      }
    }
  }
  getPreloadedSnapshot() {
    if (this.snapshotHTML) {
      return PageSnapshot.fromHTMLString(this.snapshotHTML);
    }
  }
  hasCachedSnapshot() {
    return this.getCachedSnapshot() != null;
  }
  loadCachedSnapshot() {
    const snapshot = this.getCachedSnapshot();
    if (snapshot) {
      const isPreview = this.shouldIssueRequest();
      this.render((async () => {
        this.cacheSnapshot();
        if (this.isSamePage) {
          this.adapter.visitRendered(this);
        } else {
          if (this.view.renderPromise) await this.view.renderPromise;
          await this.view.renderPage(snapshot, isPreview);
          this.adapter.visitRendered(this);
          if (!isPreview) {
            this.complete();
          }
        }
      }));
    }
  }
  followRedirect() {
    if (this.redirectedToLocation && !this.followedRedirect) {
      this.adapter.visitProposedToLocation(this.redirectedToLocation, {
        action: "replace",
        response: this.response
      });
      this.followedRedirect = true;
    }
  }
  goToSamePageAnchor() {
    if (this.isSamePage) {
      this.render((async () => {
        this.cacheSnapshot();
        this.adapter.visitRendered(this);
      }));
    }
  }
  requestStarted() {
    this.startRequest();
  }
  requestPreventedHandlingResponse(request, response) {}
  async requestSucceededWithResponse(request, response) {
    const responseHTML = await response.responseHTML;
    if (responseHTML == undefined) {
      this.recordResponse({
        statusCode: SystemStatusCode.contentTypeMismatch
      });
    } else {
      this.redirectedToLocation = response.redirected ? response.location : undefined;
      this.recordResponse({
        statusCode: response.statusCode,
        responseHTML: responseHTML
      });
    }
  }
  async requestFailedWithResponse(request, response) {
    const responseHTML = await response.responseHTML;
    if (responseHTML == undefined) {
      this.recordResponse({
        statusCode: SystemStatusCode.contentTypeMismatch
      });
    } else {
      this.recordResponse({
        statusCode: response.statusCode,
        responseHTML: responseHTML
      });
    }
  }
  requestErrored(request, error) {
    this.recordResponse({
      statusCode: SystemStatusCode.networkFailure
    });
  }
  requestFinished() {
    this.finishRequest();
  }
  performScroll() {
    if (!this.scrolled) {
      if (this.action == "restore") {
        this.scrollToRestoredPosition() || this.scrollToAnchor() || this.view.scrollToTop();
      } else {
        this.scrollToAnchor() || this.view.scrollToTop();
      }
      if (this.isSamePage) {
        this.delegate.visitScrolledToSamePageLocation(this.view.lastRenderedLocation, this.location);
      }
      this.scrolled = true;
    }
  }
  scrollToRestoredPosition() {
    const {scrollPosition: scrollPosition} = this.restorationData;
    if (scrollPosition) {
      this.view.scrollToPosition(scrollPosition);
      return true;
    }
  }
  scrollToAnchor() {
    const anchor = getAnchor(this.location);
    if (anchor != null) {
      this.view.scrollToAnchor(anchor);
      return true;
    }
  }
  recordTimingMetric(metric) {
    this.timingMetrics[metric] = (new Date).getTime();
  }
  getTimingMetrics() {
    return Object.assign({}, this.timingMetrics);
  }
  getHistoryMethodForAction(action) {
    switch (action) {
     case "replace":
      return history.replaceState;

     case "advance":
     case "restore":
      return history.pushState;
    }
  }
  hasPreloadedResponse() {
    return typeof this.response == "object";
  }
  shouldIssueRequest() {
    if (this.isSamePage) {
      return false;
    } else if (this.action == "restore") {
      return !this.hasCachedSnapshot();
    } else {
      return true;
    }
  }
  cacheSnapshot() {
    if (!this.snapshotCached) {
      this.view.cacheSnapshot();
      this.snapshotCached = true;
    }
  }
  async render(callback) {
    this.cancelRender();
    await new Promise((resolve => {
      this.frame = requestAnimationFrame((() => resolve()));
    }));
    await callback();
    delete this.frame;
    this.performScroll();
  }
  cancelRender() {
    if (this.frame) {
      cancelAnimationFrame(this.frame);
      delete this.frame;
    }
  }
}

function isSuccessful(statusCode) {
  return statusCode >= 200 && statusCode < 300;
}

class BrowserAdapter {
  constructor(session) {
    this.progressBar = new ProgressBar;
    this.showProgressBar = () => {
      this.progressBar.show();
    };
    this.session = session;
  }
  visitProposedToLocation(location, options) {
    this.navigator.startVisit(location, uuid(), options);
  }
  visitStarted(visit) {
    visit.issueRequest();
    visit.changeHistory();
    visit.goToSamePageAnchor();
    visit.loadCachedSnapshot();
  }
  visitRequestStarted(visit) {
    this.progressBar.setValue(0);
    if (visit.hasCachedSnapshot() || visit.action != "restore") {
      this.showVisitProgressBarAfterDelay();
    } else {
      this.showProgressBar();
    }
  }
  visitRequestCompleted(visit) {
    visit.loadResponse();
  }
  visitRequestFailedWithStatusCode(visit, statusCode) {
    switch (statusCode) {
     case SystemStatusCode.networkFailure:
     case SystemStatusCode.timeoutFailure:
     case SystemStatusCode.contentTypeMismatch:
      return this.reload();

     default:
      return visit.loadResponse();
    }
  }
  visitRequestFinished(visit) {
    this.progressBar.setValue(1);
    this.hideVisitProgressBar();
  }
  visitCompleted(visit) {}
  pageInvalidated() {
    this.reload();
  }
  visitFailed(visit) {}
  visitRendered(visit) {}
  formSubmissionStarted(formSubmission) {
    this.progressBar.setValue(0);
    this.showFormProgressBarAfterDelay();
  }
  formSubmissionFinished(formSubmission) {
    this.progressBar.setValue(1);
    this.hideFormProgressBar();
  }
  showVisitProgressBarAfterDelay() {
    this.visitProgressBarTimeout = window.setTimeout(this.showProgressBar, this.session.progressBarDelay);
  }
  hideVisitProgressBar() {
    this.progressBar.hide();
    if (this.visitProgressBarTimeout != null) {
      window.clearTimeout(this.visitProgressBarTimeout);
      delete this.visitProgressBarTimeout;
    }
  }
  showFormProgressBarAfterDelay() {
    if (this.formProgressBarTimeout == null) {
      this.formProgressBarTimeout = window.setTimeout(this.showProgressBar, this.session.progressBarDelay);
    }
  }
  hideFormProgressBar() {
    this.progressBar.hide();
    if (this.formProgressBarTimeout != null) {
      window.clearTimeout(this.formProgressBarTimeout);
      delete this.formProgressBarTimeout;
    }
  }
  reload() {
    window.location.reload();
  }
  get navigator() {
    return this.session.navigator;
  }
}

class CacheObserver {
  constructor() {
    this.started = false;
  }
  start() {
    if (!this.started) {
      this.started = true;
      addEventListener("turbo:before-cache", this.removeStaleElements, false);
    }
  }
  stop() {
    if (this.started) {
      this.started = false;
      removeEventListener("turbo:before-cache", this.removeStaleElements, false);
    }
  }
  removeStaleElements() {
    const staleElements = [ ...document.querySelectorAll('[data-turbo-cache="false"]') ];
    for (const element of staleElements) {
      element.remove();
    }
  }
}

class FormSubmitObserver {
  constructor(delegate) {
    this.started = false;
    this.submitCaptured = () => {
      removeEventListener("submit", this.submitBubbled, false);
      addEventListener("submit", this.submitBubbled, false);
    };
    this.submitBubbled = event => {
      if (!event.defaultPrevented) {
        const form = event.target instanceof HTMLFormElement ? event.target : undefined;
        const submitter = event.submitter || undefined;
        if (form) {
          const method = (submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("formmethod")) || form.method;
          if (method != "dialog" && this.delegate.willSubmitForm(form, submitter)) {
            event.preventDefault();
            this.delegate.formSubmitted(form, submitter);
          }
        }
      }
    };
    this.delegate = delegate;
  }
  start() {
    if (!this.started) {
      addEventListener("submit", this.submitCaptured, true);
      this.started = true;
    }
  }
  stop() {
    if (this.started) {
      removeEventListener("submit", this.submitCaptured, true);
      this.started = false;
    }
  }
}

class FrameRedirector {
  constructor(element) {
    this.element = element;
    this.linkInterceptor = new LinkInterceptor(this, element);
    this.formInterceptor = new FormInterceptor(this, element);
  }
  start() {
    this.linkInterceptor.start();
    this.formInterceptor.start();
  }
  stop() {
    this.linkInterceptor.stop();
    this.formInterceptor.stop();
  }
  shouldInterceptLinkClick(element, url) {
    return this.shouldRedirect(element);
  }
  linkClickIntercepted(element, url) {
    const frame = this.findFrameElement(element);
    if (frame) {
      frame.setAttribute("reloadable", "");
      frame.src = url;
    }
  }
  shouldInterceptFormSubmission(element, submitter) {
    return this.shouldRedirect(element, submitter);
  }
  formSubmissionIntercepted(element, submitter) {
    const frame = this.findFrameElement(element, submitter);
    if (frame) {
      frame.removeAttribute("reloadable");
      frame.delegate.formSubmissionIntercepted(element, submitter);
    }
  }
  shouldRedirect(element, submitter) {
    const frame = this.findFrameElement(element, submitter);
    return frame ? frame != element.closest("turbo-frame") : false;
  }
  findFrameElement(element, submitter) {
    const id = (submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("data-turbo-frame")) || element.getAttribute("data-turbo-frame");
    if (id && id != "_top") {
      const frame = this.element.querySelector(`#${id}:not([disabled])`);
      if (frame instanceof FrameElement) {
        return frame;
      }
    }
  }
}

class History {
  constructor(delegate) {
    this.restorationIdentifier = uuid();
    this.restorationData = {};
    this.started = false;
    this.pageLoaded = false;
    this.onPopState = event => {
      if (this.shouldHandlePopState()) {
        const {turbo: turbo} = event.state || {};
        if (turbo) {
          this.location = new URL(window.location.href);
          const {restorationIdentifier: restorationIdentifier} = turbo;
          this.restorationIdentifier = restorationIdentifier;
          this.delegate.historyPoppedToLocationWithRestorationIdentifier(this.location, restorationIdentifier);
        }
      }
    };
    this.onPageLoad = async event => {
      await nextMicrotask();
      this.pageLoaded = true;
    };
    this.delegate = delegate;
  }
  start() {
    if (!this.started) {
      addEventListener("popstate", this.onPopState, false);
      addEventListener("load", this.onPageLoad, false);
      this.started = true;
      this.replace(new URL(window.location.href));
    }
  }
  stop() {
    if (this.started) {
      removeEventListener("popstate", this.onPopState, false);
      removeEventListener("load", this.onPageLoad, false);
      this.started = false;
    }
  }
  push(location, restorationIdentifier) {
    this.update(history.pushState, location, restorationIdentifier);
  }
  replace(location, restorationIdentifier) {
    this.update(history.replaceState, location, restorationIdentifier);
  }
  update(method, location, restorationIdentifier = uuid()) {
    const state = {
      turbo: {
        restorationIdentifier: restorationIdentifier
      }
    };
    method.call(history, state, "", location.href);
    this.location = location;
    this.restorationIdentifier = restorationIdentifier;
  }
  getRestorationDataForIdentifier(restorationIdentifier) {
    return this.restorationData[restorationIdentifier] || {};
  }
  updateRestorationData(additionalData) {
    const {restorationIdentifier: restorationIdentifier} = this;
    const restorationData = this.restorationData[restorationIdentifier];
    this.restorationData[restorationIdentifier] = Object.assign(Object.assign({}, restorationData), additionalData);
  }
  assumeControlOfScrollRestoration() {
    var _a;
    if (!this.previousScrollRestoration) {
      this.previousScrollRestoration = (_a = history.scrollRestoration) !== null && _a !== void 0 ? _a : "auto";
      history.scrollRestoration = "manual";
    }
  }
  relinquishControlOfScrollRestoration() {
    if (this.previousScrollRestoration) {
      history.scrollRestoration = this.previousScrollRestoration;
      delete this.previousScrollRestoration;
    }
  }
  shouldHandlePopState() {
    return this.pageIsLoaded();
  }
  pageIsLoaded() {
    return this.pageLoaded || document.readyState == "complete";
  }
}

class LinkClickObserver {
  constructor(delegate) {
    this.started = false;
    this.clickCaptured = () => {
      removeEventListener("click", this.clickBubbled, false);
      addEventListener("click", this.clickBubbled, false);
    };
    this.clickBubbled = event => {
      if (this.clickEventIsSignificant(event)) {
        const target = event.composedPath && event.composedPath()[0] || event.target;
        const link = this.findLinkFromClickTarget(target);
        if (link) {
          const location = this.getLocationForLink(link);
          if (this.delegate.willFollowLinkToLocation(link, location)) {
            event.preventDefault();
            this.delegate.followedLinkToLocation(link, location);
          }
        }
      }
    };
    this.delegate = delegate;
  }
  start() {
    if (!this.started) {
      addEventListener("click", this.clickCaptured, true);
      this.started = true;
    }
  }
  stop() {
    if (this.started) {
      removeEventListener("click", this.clickCaptured, true);
      this.started = false;
    }
  }
  clickEventIsSignificant(event) {
    return !(event.target && event.target.isContentEditable || event.defaultPrevented || event.which > 1 || event.altKey || event.ctrlKey || event.metaKey || event.shiftKey);
  }
  findLinkFromClickTarget(target) {
    if (target instanceof Element) {
      return target.closest("a[href]:not([target^=_]):not([download])");
    }
  }
  getLocationForLink(link) {
    return expandURL(link.getAttribute("href") || "");
  }
}

function isAction(action) {
  return action == "advance" || action == "replace" || action == "restore";
}

class Navigator {
  constructor(delegate) {
    this.delegate = delegate;
  }
  proposeVisit(location, options = {}) {
    if (this.delegate.allowsVisitingLocationWithAction(location, options.action)) {
      this.delegate.visitProposedToLocation(location, options);
    }
  }
  startVisit(locatable, restorationIdentifier, options = {}) {
    this.stop();
    this.currentVisit = new Visit(this, expandURL(locatable), restorationIdentifier, Object.assign({
      referrer: this.location
    }, options));
    this.currentVisit.start();
  }
  submitForm(form, submitter) {
    this.stop();
    this.formSubmission = new FormSubmission(this, form, submitter, true);
    if (this.formSubmission.isIdempotent) {
      this.proposeVisit(this.formSubmission.fetchRequest.url, {
        action: this.getActionForFormSubmission(this.formSubmission)
      });
    } else {
      this.formSubmission.start();
    }
  }
  stop() {
    if (this.formSubmission) {
      this.formSubmission.stop();
      delete this.formSubmission;
    }
    if (this.currentVisit) {
      this.currentVisit.cancel();
      delete this.currentVisit;
    }
  }
  get adapter() {
    return this.delegate.adapter;
  }
  get view() {
    return this.delegate.view;
  }
  get history() {
    return this.delegate.history;
  }
  formSubmissionStarted(formSubmission) {
    if (typeof this.adapter.formSubmissionStarted === "function") {
      this.adapter.formSubmissionStarted(formSubmission);
    }
  }
  async formSubmissionSucceededWithResponse(formSubmission, fetchResponse) {
    if (formSubmission == this.formSubmission) {
      const responseHTML = await fetchResponse.responseHTML;
      if (responseHTML) {
        if (formSubmission.method != FetchMethod.get) {
          this.view.clearSnapshotCache();
        }
        const {statusCode: statusCode} = fetchResponse;
        const visitOptions = {
          response: {
            statusCode: statusCode,
            responseHTML: responseHTML
          }
        };
        this.proposeVisit(fetchResponse.location, visitOptions);
      }
    }
  }
  async formSubmissionFailedWithResponse(formSubmission, fetchResponse) {
    const responseHTML = await fetchResponse.responseHTML;
    if (responseHTML) {
      const snapshot = PageSnapshot.fromHTMLString(responseHTML);
      if (fetchResponse.serverError) {
        await this.view.renderError(snapshot);
      } else {
        await this.view.renderPage(snapshot);
      }
      this.view.scrollToTop();
      this.view.clearSnapshotCache();
    }
  }
  formSubmissionErrored(formSubmission, error) {
    console.error(error);
  }
  formSubmissionFinished(formSubmission) {
    if (typeof this.adapter.formSubmissionFinished === "function") {
      this.adapter.formSubmissionFinished(formSubmission);
    }
  }
  visitStarted(visit) {
    this.delegate.visitStarted(visit);
  }
  visitCompleted(visit) {
    this.delegate.visitCompleted(visit);
  }
  locationWithActionIsSamePage(location, action) {
    const anchor = getAnchor(location);
    const currentAnchor = getAnchor(this.view.lastRenderedLocation);
    const isRestorationToTop = action === "restore" && typeof anchor === "undefined";
    return action !== "replace" && getRequestURL(location) === getRequestURL(this.view.lastRenderedLocation) && (isRestorationToTop || anchor != null && anchor !== currentAnchor);
  }
  visitScrolledToSamePageLocation(oldURL, newURL) {
    this.delegate.visitScrolledToSamePageLocation(oldURL, newURL);
  }
  get location() {
    return this.history.location;
  }
  get restorationIdentifier() {
    return this.history.restorationIdentifier;
  }
  getActionForFormSubmission(formSubmission) {
    const {formElement: formElement, submitter: submitter} = formSubmission;
    const action = (submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("data-turbo-action")) || formElement.getAttribute("data-turbo-action");
    return isAction(action) ? action : "advance";
  }
}

var PageStage;

(function(PageStage) {
  PageStage[PageStage["initial"] = 0] = "initial";
  PageStage[PageStage["loading"] = 1] = "loading";
  PageStage[PageStage["interactive"] = 2] = "interactive";
  PageStage[PageStage["complete"] = 3] = "complete";
})(PageStage || (PageStage = {}));

class PageObserver {
  constructor(delegate) {
    this.stage = PageStage.initial;
    this.started = false;
    this.interpretReadyState = () => {
      const {readyState: readyState} = this;
      if (readyState == "interactive") {
        this.pageIsInteractive();
      } else if (readyState == "complete") {
        this.pageIsComplete();
      }
    };
    this.pageWillUnload = () => {
      this.delegate.pageWillUnload();
    };
    this.delegate = delegate;
  }
  start() {
    if (!this.started) {
      if (this.stage == PageStage.initial) {
        this.stage = PageStage.loading;
      }
      document.addEventListener("readystatechange", this.interpretReadyState, false);
      addEventListener("pagehide", this.pageWillUnload, false);
      this.started = true;
    }
  }
  stop() {
    if (this.started) {
      document.removeEventListener("readystatechange", this.interpretReadyState, false);
      removeEventListener("pagehide", this.pageWillUnload, false);
      this.started = false;
    }
  }
  pageIsInteractive() {
    if (this.stage == PageStage.loading) {
      this.stage = PageStage.interactive;
      this.delegate.pageBecameInteractive();
    }
  }
  pageIsComplete() {
    this.pageIsInteractive();
    if (this.stage == PageStage.interactive) {
      this.stage = PageStage.complete;
      this.delegate.pageLoaded();
    }
  }
  get readyState() {
    return document.readyState;
  }
}

class ScrollObserver {
  constructor(delegate) {
    this.started = false;
    this.onScroll = () => {
      this.updatePosition({
        x: window.pageXOffset,
        y: window.pageYOffset
      });
    };
    this.delegate = delegate;
  }
  start() {
    if (!this.started) {
      addEventListener("scroll", this.onScroll, false);
      this.onScroll();
      this.started = true;
    }
  }
  stop() {
    if (this.started) {
      removeEventListener("scroll", this.onScroll, false);
      this.started = false;
    }
  }
  updatePosition(position) {
    this.delegate.scrollPositionChanged(position);
  }
}

class StreamObserver {
  constructor(delegate) {
    this.sources = new Set;
    this.started = false;
    this.inspectFetchResponse = event => {
      const response = fetchResponseFromEvent(event);
      if (response && fetchResponseIsStream(response)) {
        event.preventDefault();
        this.receiveMessageResponse(response);
      }
    };
    this.receiveMessageEvent = event => {
      if (this.started && typeof event.data == "string") {
        this.receiveMessageHTML(event.data);
      }
    };
    this.delegate = delegate;
  }
  start() {
    if (!this.started) {
      this.started = true;
      addEventListener("turbo:before-fetch-response", this.inspectFetchResponse, false);
    }
  }
  stop() {
    if (this.started) {
      this.started = false;
      removeEventListener("turbo:before-fetch-response", this.inspectFetchResponse, false);
    }
  }
  connectStreamSource(source) {
    if (!this.streamSourceIsConnected(source)) {
      this.sources.add(source);
      source.addEventListener("message", this.receiveMessageEvent, false);
    }
  }
  disconnectStreamSource(source) {
    if (this.streamSourceIsConnected(source)) {
      this.sources.delete(source);
      source.removeEventListener("message", this.receiveMessageEvent, false);
    }
  }
  streamSourceIsConnected(source) {
    return this.sources.has(source);
  }
  async receiveMessageResponse(response) {
    const html = await response.responseHTML;
    if (html) {
      this.receiveMessageHTML(html);
    }
  }
  receiveMessageHTML(html) {
    this.delegate.receivedMessageFromStream(new StreamMessage(html));
  }
}

function fetchResponseFromEvent(event) {
  var _a;
  const fetchResponse = (_a = event.detail) === null || _a === void 0 ? void 0 : _a.fetchResponse;
  if (fetchResponse instanceof FetchResponse) {
    return fetchResponse;
  }
}

function fetchResponseIsStream(response) {
  var _a;
  const contentType = (_a = response.contentType) !== null && _a !== void 0 ? _a : "";
  return contentType.startsWith(StreamMessage.contentType);
}

class ErrorRenderer extends Renderer {
  async render() {
    this.replaceHeadAndBody();
    this.activateScriptElements();
  }
  replaceHeadAndBody() {
    const {documentElement: documentElement, head: head, body: body} = document;
    documentElement.replaceChild(this.newHead, head);
    documentElement.replaceChild(this.newElement, body);
  }
  activateScriptElements() {
    for (const replaceableElement of this.scriptElements) {
      const parentNode = replaceableElement.parentNode;
      if (parentNode) {
        const element = this.createScriptElement(replaceableElement);
        parentNode.replaceChild(element, replaceableElement);
      }
    }
  }
  get newHead() {
    return this.newSnapshot.headSnapshot.element;
  }
  get scriptElements() {
    return [ ...document.documentElement.querySelectorAll("script") ];
  }
}

class PageRenderer extends Renderer {
  get shouldRender() {
    return this.newSnapshot.isVisitable && this.trackedElementsAreIdentical;
  }
  prepareToRender() {
    this.mergeHead();
  }
  async render() {
    this.replaceBody();
  }
  finishRendering() {
    super.finishRendering();
    if (!this.isPreview) {
      this.focusFirstAutofocusableElement();
    }
  }
  get currentHeadSnapshot() {
    return this.currentSnapshot.headSnapshot;
  }
  get newHeadSnapshot() {
    return this.newSnapshot.headSnapshot;
  }
  get newElement() {
    return this.newSnapshot.element;
  }
  mergeHead() {
    this.copyNewHeadStylesheetElements();
    this.copyNewHeadScriptElements();
    this.removeCurrentHeadProvisionalElements();
    this.copyNewHeadProvisionalElements();
  }
  replaceBody() {
    this.preservingPermanentElements((() => {
      this.activateNewBody();
      this.assignNewBody();
    }));
  }
  get trackedElementsAreIdentical() {
    return this.currentHeadSnapshot.trackedElementSignature == this.newHeadSnapshot.trackedElementSignature;
  }
  copyNewHeadStylesheetElements() {
    for (const element of this.newHeadStylesheetElements) {
      document.head.appendChild(element);
    }
  }
  copyNewHeadScriptElements() {
    for (const element of this.newHeadScriptElements) {
      document.head.appendChild(this.createScriptElement(element));
    }
  }
  removeCurrentHeadProvisionalElements() {
    for (const element of this.currentHeadProvisionalElements) {
      document.head.removeChild(element);
    }
  }
  copyNewHeadProvisionalElements() {
    for (const element of this.newHeadProvisionalElements) {
      document.head.appendChild(element);
    }
  }
  activateNewBody() {
    document.adoptNode(this.newElement);
    this.activateNewBodyScriptElements();
  }
  activateNewBodyScriptElements() {
    for (const inertScriptElement of this.newBodyScriptElements) {
      const activatedScriptElement = this.createScriptElement(inertScriptElement);
      inertScriptElement.replaceWith(activatedScriptElement);
    }
  }
  assignNewBody() {
    if (document.body && this.newElement instanceof HTMLBodyElement) {
      document.body.replaceWith(this.newElement);
    } else {
      document.documentElement.appendChild(this.newElement);
    }
  }
  get newHeadStylesheetElements() {
    return this.newHeadSnapshot.getStylesheetElementsNotInSnapshot(this.currentHeadSnapshot);
  }
  get newHeadScriptElements() {
    return this.newHeadSnapshot.getScriptElementsNotInSnapshot(this.currentHeadSnapshot);
  }
  get currentHeadProvisionalElements() {
    return this.currentHeadSnapshot.provisionalElements;
  }
  get newHeadProvisionalElements() {
    return this.newHeadSnapshot.provisionalElements;
  }
  get newBodyScriptElements() {
    return this.newElement.querySelectorAll("script");
  }
}

class SnapshotCache {
  constructor(size) {
    this.keys = [];
    this.snapshots = {};
    this.size = size;
  }
  has(location) {
    return toCacheKey(location) in this.snapshots;
  }
  get(location) {
    if (this.has(location)) {
      const snapshot = this.read(location);
      this.touch(location);
      return snapshot;
    }
  }
  put(location, snapshot) {
    this.write(location, snapshot);
    this.touch(location);
    return snapshot;
  }
  clear() {
    this.snapshots = {};
  }
  read(location) {
    return this.snapshots[toCacheKey(location)];
  }
  write(location, snapshot) {
    this.snapshots[toCacheKey(location)] = snapshot;
  }
  touch(location) {
    const key = toCacheKey(location);
    const index = this.keys.indexOf(key);
    if (index > -1) this.keys.splice(index, 1);
    this.keys.unshift(key);
    this.trim();
  }
  trim() {
    for (const key of this.keys.splice(this.size)) {
      delete this.snapshots[key];
    }
  }
}

class PageView extends View {
  constructor() {
    super(...arguments);
    this.snapshotCache = new SnapshotCache(10);
    this.lastRenderedLocation = new URL(location.href);
  }
  renderPage(snapshot, isPreview = false) {
    const renderer = new PageRenderer(this.snapshot, snapshot, isPreview);
    return this.render(renderer);
  }
  renderError(snapshot) {
    const renderer = new ErrorRenderer(this.snapshot, snapshot, false);
    return this.render(renderer);
  }
  clearSnapshotCache() {
    this.snapshotCache.clear();
  }
  async cacheSnapshot() {
    if (this.shouldCacheSnapshot) {
      this.delegate.viewWillCacheSnapshot();
      const {snapshot: snapshot, lastRenderedLocation: location} = this;
      await nextEventLoopTick();
      this.snapshotCache.put(location, snapshot.clone());
    }
  }
  getCachedSnapshotForLocation(location) {
    return this.snapshotCache.get(location);
  }
  get snapshot() {
    return PageSnapshot.fromElement(this.element);
  }
  get shouldCacheSnapshot() {
    return this.snapshot.isCacheable;
  }
}

class Session {
  constructor() {
    this.navigator = new Navigator(this);
    this.history = new History(this);
    this.view = new PageView(this, document.documentElement);
    this.adapter = new BrowserAdapter(this);
    this.pageObserver = new PageObserver(this);
    this.cacheObserver = new CacheObserver;
    this.linkClickObserver = new LinkClickObserver(this);
    this.formSubmitObserver = new FormSubmitObserver(this);
    this.scrollObserver = new ScrollObserver(this);
    this.streamObserver = new StreamObserver(this);
    this.frameRedirector = new FrameRedirector(document.documentElement);
    this.drive = true;
    this.enabled = true;
    this.progressBarDelay = 500;
    this.started = false;
  }
  start() {
    if (!this.started) {
      this.pageObserver.start();
      this.cacheObserver.start();
      this.linkClickObserver.start();
      this.formSubmitObserver.start();
      this.scrollObserver.start();
      this.streamObserver.start();
      this.frameRedirector.start();
      this.history.start();
      this.started = true;
      this.enabled = true;
    }
  }
  disable() {
    this.enabled = false;
  }
  stop() {
    if (this.started) {
      this.pageObserver.stop();
      this.cacheObserver.stop();
      this.linkClickObserver.stop();
      this.formSubmitObserver.stop();
      this.scrollObserver.stop();
      this.streamObserver.stop();
      this.frameRedirector.stop();
      this.history.stop();
      this.started = false;
    }
  }
  registerAdapter(adapter) {
    this.adapter = adapter;
  }
  visit(location, options = {}) {
    this.navigator.proposeVisit(expandURL(location), options);
  }
  connectStreamSource(source) {
    this.streamObserver.connectStreamSource(source);
  }
  disconnectStreamSource(source) {
    this.streamObserver.disconnectStreamSource(source);
  }
  renderStreamMessage(message) {
    document.documentElement.appendChild(StreamMessage.wrap(message).fragment);
  }
  clearCache() {
    this.view.clearSnapshotCache();
  }
  setProgressBarDelay(delay) {
    this.progressBarDelay = delay;
  }
  get location() {
    return this.history.location;
  }
  get restorationIdentifier() {
    return this.history.restorationIdentifier;
  }
  historyPoppedToLocationWithRestorationIdentifier(location, restorationIdentifier) {
    if (this.enabled) {
      this.navigator.startVisit(location, restorationIdentifier, {
        action: "restore",
        historyChanged: true
      });
    } else {
      this.adapter.pageInvalidated();
    }
  }
  scrollPositionChanged(position) {
    this.history.updateRestorationData({
      scrollPosition: position
    });
  }
  willFollowLinkToLocation(link, location) {
    return this.elementDriveEnabled(link) && this.locationIsVisitable(location) && this.applicationAllowsFollowingLinkToLocation(link, location);
  }
  followedLinkToLocation(link, location) {
    const action = this.getActionForLink(link);
    this.convertLinkWithMethodClickToFormSubmission(link) || this.visit(location.href, {
      action: action
    });
  }
  convertLinkWithMethodClickToFormSubmission(link) {
    var _a;
    const linkMethod = link.getAttribute("data-turbo-method");
    if (linkMethod) {
      const form = document.createElement("form");
      form.method = linkMethod;
      form.action = link.getAttribute("href") || "undefined";
      form.hidden = true;
      (_a = link.parentNode) === null || _a === void 0 ? void 0 : _a.insertBefore(form, link);
      return dispatch("submit", {
        cancelable: true,
        target: form
      });
    } else {
      return false;
    }
  }
  allowsVisitingLocationWithAction(location, action) {
    return this.locationWithActionIsSamePage(location, action) || this.applicationAllowsVisitingLocation(location);
  }
  visitProposedToLocation(location, options) {
    extendURLWithDeprecatedProperties(location);
    this.adapter.visitProposedToLocation(location, options);
  }
  visitStarted(visit) {
    extendURLWithDeprecatedProperties(visit.location);
    if (!visit.silent) {
      this.notifyApplicationAfterVisitingLocation(visit.location, visit.action);
    }
  }
  visitCompleted(visit) {
    this.notifyApplicationAfterPageLoad(visit.getTimingMetrics());
  }
  locationWithActionIsSamePage(location, action) {
    return this.navigator.locationWithActionIsSamePage(location, action);
  }
  visitScrolledToSamePageLocation(oldURL, newURL) {
    this.notifyApplicationAfterVisitingSamePageLocation(oldURL, newURL);
  }
  willSubmitForm(form, submitter) {
    return this.elementDriveEnabled(form) && (!submitter || this.elementDriveEnabled(submitter));
  }
  formSubmitted(form, submitter) {
    this.navigator.submitForm(form, submitter);
  }
  pageBecameInteractive() {
    this.view.lastRenderedLocation = this.location;
    this.notifyApplicationAfterPageLoad();
  }
  pageLoaded() {
    this.history.assumeControlOfScrollRestoration();
  }
  pageWillUnload() {
    this.history.relinquishControlOfScrollRestoration();
  }
  receivedMessageFromStream(message) {
    this.renderStreamMessage(message);
  }
  viewWillCacheSnapshot() {
    var _a;
    if (!((_a = this.navigator.currentVisit) === null || _a === void 0 ? void 0 : _a.silent)) {
      this.notifyApplicationBeforeCachingSnapshot();
    }
  }
  allowsImmediateRender({element: element}, resume) {
    const event = this.notifyApplicationBeforeRender(element, resume);
    return !event.defaultPrevented;
  }
  viewRenderedSnapshot(snapshot, isPreview) {
    this.view.lastRenderedLocation = this.history.location;
    this.notifyApplicationAfterRender();
  }
  viewInvalidated() {
    this.adapter.pageInvalidated();
  }
  frameLoaded(frame) {
    this.notifyApplicationAfterFrameLoad(frame);
  }
  frameRendered(fetchResponse, frame) {
    this.notifyApplicationAfterFrameRender(fetchResponse, frame);
  }
  applicationAllowsFollowingLinkToLocation(link, location) {
    const event = this.notifyApplicationAfterClickingLinkToLocation(link, location);
    return !event.defaultPrevented;
  }
  applicationAllowsVisitingLocation(location) {
    const event = this.notifyApplicationBeforeVisitingLocation(location);
    return !event.defaultPrevented;
  }
  notifyApplicationAfterClickingLinkToLocation(link, location) {
    return dispatch("turbo:click", {
      target: link,
      detail: {
        url: location.href
      },
      cancelable: true
    });
  }
  notifyApplicationBeforeVisitingLocation(location) {
    return dispatch("turbo:before-visit", {
      detail: {
        url: location.href
      },
      cancelable: true
    });
  }
  notifyApplicationAfterVisitingLocation(location, action) {
    return dispatch("turbo:visit", {
      detail: {
        url: location.href,
        action: action
      }
    });
  }
  notifyApplicationBeforeCachingSnapshot() {
    return dispatch("turbo:before-cache");
  }
  notifyApplicationBeforeRender(newBody, resume) {
    return dispatch("turbo:before-render", {
      detail: {
        newBody: newBody,
        resume: resume
      },
      cancelable: true
    });
  }
  notifyApplicationAfterRender() {
    return dispatch("turbo:render");
  }
  notifyApplicationAfterPageLoad(timing = {}) {
    return dispatch("turbo:load", {
      detail: {
        url: this.location.href,
        timing: timing
      }
    });
  }
  notifyApplicationAfterVisitingSamePageLocation(oldURL, newURL) {
    dispatchEvent(new HashChangeEvent("hashchange", {
      oldURL: oldURL.toString(),
      newURL: newURL.toString()
    }));
  }
  notifyApplicationAfterFrameLoad(frame) {
    return dispatch("turbo:frame-load", {
      target: frame
    });
  }
  notifyApplicationAfterFrameRender(fetchResponse, frame) {
    return dispatch("turbo:frame-render", {
      detail: {
        fetchResponse: fetchResponse
      },
      target: frame,
      cancelable: true
    });
  }
  elementDriveEnabled(element) {
    const container = element === null || element === void 0 ? void 0 : element.closest("[data-turbo]");
    if (this.drive) {
      if (container) {
        return container.getAttribute("data-turbo") != "false";
      } else {
        return true;
      }
    } else {
      if (container) {
        return container.getAttribute("data-turbo") == "true";
      } else {
        return false;
      }
    }
  }
  getActionForLink(link) {
    const action = link.getAttribute("data-turbo-action");
    return isAction(action) ? action : "advance";
  }
  locationIsVisitable(location) {
    return isPrefixedBy(location, this.snapshot.rootLocation) && isHTML(location);
  }
  get snapshot() {
    return this.view.snapshot;
  }
}

function extendURLWithDeprecatedProperties(url) {
  Object.defineProperties(url, deprecatedLocationPropertyDescriptors);
}

const deprecatedLocationPropertyDescriptors = {
  absoluteURL: {
    get() {
      return this.toString();
    }
  }
};

const session = new Session;

const {navigator: navigator$1} = session;

function start() {
  session.start();
}

function registerAdapter(adapter) {
  session.registerAdapter(adapter);
}

function visit(location, options) {
  session.visit(location, options);
}

function connectStreamSource(source) {
  session.connectStreamSource(source);
}

function disconnectStreamSource(source) {
  session.disconnectStreamSource(source);
}

function renderStreamMessage(message) {
  session.renderStreamMessage(message);
}

function clearCache() {
  session.clearCache();
}

function setProgressBarDelay(delay) {
  session.setProgressBarDelay(delay);
}

var Turbo = Object.freeze({
  __proto__: null,
  navigator: navigator$1,
  session: session,
  PageRenderer: PageRenderer,
  PageSnapshot: PageSnapshot,
  start: start,
  registerAdapter: registerAdapter,
  visit: visit,
  connectStreamSource: connectStreamSource,
  disconnectStreamSource: disconnectStreamSource,
  renderStreamMessage: renderStreamMessage,
  clearCache: clearCache,
  setProgressBarDelay: setProgressBarDelay
});

class FrameController {
  constructor(element) {
    this.resolveVisitPromise = () => {};
    this.connected = false;
    this.hasBeenLoaded = false;
    this.settingSourceURL = false;
    this.element = element;
    this.view = new FrameView(this, this.element);
    this.appearanceObserver = new AppearanceObserver(this, this.element);
    this.linkInterceptor = new LinkInterceptor(this, this.element);
    this.formInterceptor = new FormInterceptor(this, this.element);
  }
  connect() {
    if (!this.connected) {
      this.connected = true;
      this.reloadable = false;
      if (this.loadingStyle == FrameLoadingStyle.lazy) {
        this.appearanceObserver.start();
      }
      this.linkInterceptor.start();
      this.formInterceptor.start();
      this.sourceURLChanged();
    }
  }
  disconnect() {
    if (this.connected) {
      this.connected = false;
      this.appearanceObserver.stop();
      this.linkInterceptor.stop();
      this.formInterceptor.stop();
    }
  }
  disabledChanged() {
    if (this.loadingStyle == FrameLoadingStyle.eager) {
      this.loadSourceURL();
    }
  }
  sourceURLChanged() {
    if (this.loadingStyle == FrameLoadingStyle.eager || this.hasBeenLoaded) {
      this.loadSourceURL();
    }
  }
  loadingStyleChanged() {
    if (this.loadingStyle == FrameLoadingStyle.lazy) {
      this.appearanceObserver.start();
    } else {
      this.appearanceObserver.stop();
      this.loadSourceURL();
    }
  }
  async loadSourceURL() {
    if (!this.settingSourceURL && this.enabled && this.isActive && (this.reloadable || this.sourceURL != this.currentURL)) {
      const previousURL = this.currentURL;
      this.currentURL = this.sourceURL;
      if (this.sourceURL) {
        try {
          this.element.loaded = this.visit(this.sourceURL);
          this.appearanceObserver.stop();
          await this.element.loaded;
          this.hasBeenLoaded = true;
          session.frameLoaded(this.element);
        } catch (error) {
          this.currentURL = previousURL;
          throw error;
        }
      }
    }
  }
  async loadResponse(fetchResponse) {
    if (fetchResponse.redirected) {
      this.sourceURL = fetchResponse.response.url;
    }
    try {
      const html = await fetchResponse.responseHTML;
      if (html) {
        const {body: body} = parseHTMLDocument(html);
        const snapshot = new Snapshot(await this.extractForeignFrameElement(body));
        const renderer = new FrameRenderer(this.view.snapshot, snapshot, false);
        if (this.view.renderPromise) await this.view.renderPromise;
        await this.view.render(renderer);
        session.frameRendered(fetchResponse, this.element);
      }
    } catch (error) {
      console.error(error);
      this.view.invalidate();
    }
  }
  elementAppearedInViewport(element) {
    this.loadSourceURL();
  }
  shouldInterceptLinkClick(element, url) {
    if (element.hasAttribute("data-turbo-method")) {
      return false;
    } else {
      return this.shouldInterceptNavigation(element);
    }
  }
  linkClickIntercepted(element, url) {
    this.reloadable = true;
    this.navigateFrame(element, url);
  }
  shouldInterceptFormSubmission(element, submitter) {
    return this.shouldInterceptNavigation(element, submitter);
  }
  formSubmissionIntercepted(element, submitter) {
    if (this.formSubmission) {
      this.formSubmission.stop();
    }
    this.reloadable = false;
    this.formSubmission = new FormSubmission(this, element, submitter);
    if (this.formSubmission.fetchRequest.isIdempotent) {
      this.navigateFrame(element, this.formSubmission.fetchRequest.url.href, submitter);
    } else {
      const {fetchRequest: fetchRequest} = this.formSubmission;
      this.prepareHeadersForRequest(fetchRequest.headers, fetchRequest);
      this.formSubmission.start();
    }
  }
  prepareHeadersForRequest(headers, request) {
    headers["Turbo-Frame"] = this.id;
  }
  requestStarted(request) {
    this.element.setAttribute("busy", "");
  }
  requestPreventedHandlingResponse(request, response) {
    this.resolveVisitPromise();
  }
  async requestSucceededWithResponse(request, response) {
    await this.loadResponse(response);
    this.resolveVisitPromise();
  }
  requestFailedWithResponse(request, response) {
    console.error(response);
    this.resolveVisitPromise();
  }
  requestErrored(request, error) {
    console.error(error);
    this.resolveVisitPromise();
  }
  requestFinished(request) {
    this.element.removeAttribute("busy");
  }
  formSubmissionStarted(formSubmission) {
    const frame = this.findFrameElement(formSubmission.formElement);
    frame.setAttribute("busy", "");
  }
  formSubmissionSucceededWithResponse(formSubmission, response) {
    const frame = this.findFrameElement(formSubmission.formElement, formSubmission.submitter);
    frame.delegate.loadResponse(response);
  }
  formSubmissionFailedWithResponse(formSubmission, fetchResponse) {
    this.element.delegate.loadResponse(fetchResponse);
  }
  formSubmissionErrored(formSubmission, error) {
    console.error(error);
  }
  formSubmissionFinished(formSubmission) {
    const frame = this.findFrameElement(formSubmission.formElement);
    frame.removeAttribute("busy");
  }
  allowsImmediateRender(snapshot, resume) {
    return true;
  }
  viewRenderedSnapshot(snapshot, isPreview) {}
  viewInvalidated() {}
  async visit(url) {
    const request = new FetchRequest(this, FetchMethod.get, expandURL(url), undefined, this.element);
    return new Promise((resolve => {
      this.resolveVisitPromise = () => {
        this.resolveVisitPromise = () => {};
        resolve();
      };
      request.perform();
    }));
  }
  navigateFrame(element, url, submitter) {
    const frame = this.findFrameElement(element, submitter);
    frame.setAttribute("reloadable", "");
    frame.src = url;
  }
  findFrameElement(element, submitter) {
    var _a;
    const id = (submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("data-turbo-frame")) || element.getAttribute("data-turbo-frame") || this.element.getAttribute("target");
    return (_a = getFrameElementById(id)) !== null && _a !== void 0 ? _a : this.element;
  }
  async extractForeignFrameElement(container) {
    let element;
    const id = CSS.escape(this.id);
    try {
      if (element = activateElement(container.querySelector(`turbo-frame#${id}`), this.currentURL)) {
        return element;
      }
      if (element = activateElement(container.querySelector(`turbo-frame[src][recurse~=${id}]`), this.currentURL)) {
        await element.loaded;
        return await this.extractForeignFrameElement(element);
      }
      console.error(`Response has no matching <turbo-frame id="${id}"> element`);
    } catch (error) {
      console.error(error);
    }
    return new FrameElement;
  }
  shouldInterceptNavigation(element, submitter) {
    const id = (submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("data-turbo-frame")) || element.getAttribute("data-turbo-frame") || this.element.getAttribute("target");
    if (!this.enabled || id == "_top") {
      return false;
    }
    if (id) {
      const frameElement = getFrameElementById(id);
      if (frameElement) {
        return !frameElement.disabled;
      }
    }
    if (!session.elementDriveEnabled(element)) {
      return false;
    }
    if (submitter && !session.elementDriveEnabled(submitter)) {
      return false;
    }
    return true;
  }
  get id() {
    return this.element.id;
  }
  get enabled() {
    return !this.element.disabled;
  }
  get sourceURL() {
    if (this.element.src) {
      return this.element.src;
    }
  }
  get reloadable() {
    const frame = this.findFrameElement(this.element);
    return frame.hasAttribute("reloadable");
  }
  set reloadable(value) {
    const frame = this.findFrameElement(this.element);
    if (value) {
      frame.setAttribute("reloadable", "");
    } else {
      frame.removeAttribute("reloadable");
    }
  }
  set sourceURL(sourceURL) {
    this.settingSourceURL = true;
    this.element.src = sourceURL !== null && sourceURL !== void 0 ? sourceURL : null;
    this.currentURL = this.element.src;
    this.settingSourceURL = false;
  }
  get loadingStyle() {
    return this.element.loading;
  }
  get isLoading() {
    return this.formSubmission !== undefined || this.resolveVisitPromise() !== undefined;
  }
  get isActive() {
    return this.element.isActive && this.connected;
  }
}

function getFrameElementById(id) {
  if (id != null) {
    const element = document.getElementById(id);
    if (element instanceof FrameElement) {
      return element;
    }
  }
}

function activateElement(element, currentURL) {
  if (element) {
    const src = element.getAttribute("src");
    if (src != null && currentURL != null && urlsAreEqual(src, currentURL)) {
      throw new Error(`Matching <turbo-frame id="${element.id}"> element has a source URL which references itself`);
    }
    if (element.ownerDocument !== document) {
      element = document.importNode(element, true);
    }
    if (element instanceof FrameElement) {
      element.connectedCallback();
      return element;
    }
  }
}

const StreamActions = {
  after() {
    this.targetElements.forEach((e => {
      var _a;
      return (_a = e.parentElement) === null || _a === void 0 ? void 0 : _a.insertBefore(this.templateContent, e.nextSibling);
    }));
  },
  append() {
    this.removeDuplicateTargetChildren();
    this.targetElements.forEach((e => e.append(this.templateContent)));
  },
  before() {
    this.targetElements.forEach((e => {
      var _a;
      return (_a = e.parentElement) === null || _a === void 0 ? void 0 : _a.insertBefore(this.templateContent, e);
    }));
  },
  prepend() {
    this.removeDuplicateTargetChildren();
    this.targetElements.forEach((e => e.prepend(this.templateContent)));
  },
  remove() {
    this.targetElements.forEach((e => e.remove()));
  },
  replace() {
    this.targetElements.forEach((e => e.replaceWith(this.templateContent)));
  },
  update() {
    this.targetElements.forEach((e => {
      e.innerHTML = "";
      e.append(this.templateContent);
    }));
  }
};

class StreamElement extends HTMLElement {
  async connectedCallback() {
    try {
      await this.render();
    } catch (error) {
      console.error(error);
    } finally {
      this.disconnect();
    }
  }
  async render() {
    var _a;
    return (_a = this.renderPromise) !== null && _a !== void 0 ? _a : this.renderPromise = (async () => {
      if (this.dispatchEvent(this.beforeRenderEvent)) {
        await nextAnimationFrame();
        this.performAction();
      }
    })();
  }
  disconnect() {
    try {
      this.remove();
    } catch (_a) {}
  }
  removeDuplicateTargetChildren() {
    this.duplicateChildren.forEach((c => c.remove()));
  }
  get duplicateChildren() {
    var _a;
    const existingChildren = this.targetElements.flatMap((e => [ ...e.children ])).filter((c => !!c.id));
    const newChildrenIds = [ ...(_a = this.templateContent) === null || _a === void 0 ? void 0 : _a.children ].filter((c => !!c.id)).map((c => c.id));
    return existingChildren.filter((c => newChildrenIds.includes(c.id)));
  }
  get performAction() {
    if (this.action) {
      const actionFunction = StreamActions[this.action];
      if (actionFunction) {
        return actionFunction;
      }
      this.raise("unknown action");
    }
    this.raise("action attribute is missing");
  }
  get targetElements() {
    if (this.target) {
      return this.targetElementsById;
    } else if (this.targets) {
      return this.targetElementsByQuery;
    } else {
      this.raise("target or targets attribute is missing");
    }
  }
  get templateContent() {
    return this.templateElement.content.cloneNode(true);
  }
  get templateElement() {
    if (this.firstElementChild instanceof HTMLTemplateElement) {
      return this.firstElementChild;
    }
    this.raise("first child element must be a <template> element");
  }
  get action() {
    return this.getAttribute("action");
  }
  get target() {
    return this.getAttribute("target");
  }
  get targets() {
    return this.getAttribute("targets");
  }
  raise(message) {
    throw new Error(`${this.description}: ${message}`);
  }
  get description() {
    var _a, _b;
    return (_b = ((_a = this.outerHTML.match(/<[^>]+>/)) !== null && _a !== void 0 ? _a : [])[0]) !== null && _b !== void 0 ? _b : "<turbo-stream>";
  }
  get beforeRenderEvent() {
    return new CustomEvent("turbo:before-stream-render", {
      bubbles: true,
      cancelable: true
    });
  }
  get targetElementsById() {
    var _a;
    const element = (_a = this.ownerDocument) === null || _a === void 0 ? void 0 : _a.getElementById(this.target);
    if (element !== null) {
      return [ element ];
    } else {
      return [];
    }
  }
  get targetElementsByQuery() {
    var _a;
    const elements = (_a = this.ownerDocument) === null || _a === void 0 ? void 0 : _a.querySelectorAll(this.targets);
    if (elements.length !== 0) {
      return Array.prototype.slice.call(elements);
    } else {
      return [];
    }
  }
}

FrameElement.delegateConstructor = FrameController;

customElements.define("turbo-frame", FrameElement);

customElements.define("turbo-stream", StreamElement);

(() => {
  let element = document.currentScript;
  if (!element) return;
  if (element.hasAttribute("data-turbo-suppress-warning")) return;
  while (element = element.parentElement) {
    if (element == document.body) {
      return console.warn(unindent`
        You are loading Turbo from a <script> element inside the <body> element. This is probably not what you meant to do!

        Load your application’s JavaScript bundle inside the <head> element instead. <script> elements in <body> are evaluated with each page change.

        For more information, see: https://turbo.hotwired.dev/handbook/building#working-with-script-elements

        ——
        Suppress this warning by adding a "data-turbo-suppress-warning" attribute to: %s
      `, element.outerHTML);
    }
  }
})();

window.Turbo = Turbo;

start();

var turbo_es2017Esm = Object.freeze({
  __proto__: null,
  PageRenderer: PageRenderer,
  PageSnapshot: PageSnapshot,
  clearCache: clearCache,
  connectStreamSource: connectStreamSource,
  disconnectStreamSource: disconnectStreamSource,
  navigator: navigator$1,
  registerAdapter: registerAdapter,
  renderStreamMessage: renderStreamMessage,
  session: session,
  setProgressBarDelay: setProgressBarDelay,
  start: start,
  visit: visit
});

let consumer;

async function getConsumer() {
  return consumer || setConsumer(createConsumer().then(setConsumer));
}

function setConsumer(newConsumer) {
  return consumer = newConsumer;
}

async function createConsumer() {
  const {createConsumer: createConsumer} = await Promise.resolve().then((function() {
    return index;
  }));
  return createConsumer();
}

async function subscribeTo(channel, mixin) {
  const {subscriptions: subscriptions} = await getConsumer();
  return subscriptions.create(channel, mixin);
}

var cable = Object.freeze({
  __proto__: null,
  getConsumer: getConsumer,
  setConsumer: setConsumer,
  createConsumer: createConsumer,
  subscribeTo: subscribeTo
});

class TurboCableStreamSourceElement extends HTMLElement {
  async connectedCallback() {
    connectStreamSource(this);
    this.subscription = await subscribeTo(this.channel, {
      received: this.dispatchMessageEvent.bind(this)
    });
  }
  disconnectedCallback() {
    disconnectStreamSource(this);
    if (this.subscription) this.subscription.unsubscribe();
  }
  dispatchMessageEvent(data) {
    const event = new MessageEvent("message", {
      data: data
    });
    return this.dispatchEvent(event);
  }
  get channel() {
    const channel = this.getAttribute("channel");
    const signed_stream_name = this.getAttribute("signed-stream-name");
    return {
      channel: channel,
      signed_stream_name: signed_stream_name
    };
  }
}

customElements.define("turbo-cable-stream-source", TurboCableStreamSourceElement);

var adapters = {
  logger: self.console,
  WebSocket: self.WebSocket
};

var logger = {
  log(...messages) {
    if (this.enabled) {
      messages.push(Date.now());
      adapters.logger.log("[ActionCable]", ...messages);
    }
  }
};

const now = () => (new Date).getTime();

const secondsSince = time => (now() - time) / 1e3;

const clamp = (number, min, max) => Math.max(min, Math.min(max, number));

class ConnectionMonitor {
  constructor(connection) {
    this.visibilityDidChange = this.visibilityDidChange.bind(this);
    this.connection = connection;
    this.reconnectAttempts = 0;
  }
  start() {
    if (!this.isRunning()) {
      this.startedAt = now();
      delete this.stoppedAt;
      this.startPolling();
      addEventListener("visibilitychange", this.visibilityDidChange);
      logger.log(`ConnectionMonitor started. pollInterval = ${this.getPollInterval()} ms`);
    }
  }
  stop() {
    if (this.isRunning()) {
      this.stoppedAt = now();
      this.stopPolling();
      removeEventListener("visibilitychange", this.visibilityDidChange);
      logger.log("ConnectionMonitor stopped");
    }
  }
  isRunning() {
    return this.startedAt && !this.stoppedAt;
  }
  recordPing() {
    this.pingedAt = now();
  }
  recordConnect() {
    this.reconnectAttempts = 0;
    this.recordPing();
    delete this.disconnectedAt;
    logger.log("ConnectionMonitor recorded connect");
  }
  recordDisconnect() {
    this.disconnectedAt = now();
    logger.log("ConnectionMonitor recorded disconnect");
  }
  startPolling() {
    this.stopPolling();
    this.poll();
  }
  stopPolling() {
    clearTimeout(this.pollTimeout);
  }
  poll() {
    this.pollTimeout = setTimeout((() => {
      this.reconnectIfStale();
      this.poll();
    }), this.getPollInterval());
  }
  getPollInterval() {
    const {min: min, max: max, multiplier: multiplier} = this.constructor.pollInterval;
    const interval = multiplier * Math.log(this.reconnectAttempts + 1);
    return Math.round(clamp(interval, min, max) * 1e3);
  }
  reconnectIfStale() {
    if (this.connectionIsStale()) {
      logger.log(`ConnectionMonitor detected stale connection. reconnectAttempts = ${this.reconnectAttempts}, pollInterval = ${this.getPollInterval()} ms, time disconnected = ${secondsSince(this.disconnectedAt)} s, stale threshold = ${this.constructor.staleThreshold} s`);
      this.reconnectAttempts++;
      if (this.disconnectedRecently()) {
        logger.log("ConnectionMonitor skipping reopening recent disconnect");
      } else {
        logger.log("ConnectionMonitor reopening");
        this.connection.reopen();
      }
    }
  }
  connectionIsStale() {
    return secondsSince(this.pingedAt ? this.pingedAt : this.startedAt) > this.constructor.staleThreshold;
  }
  disconnectedRecently() {
    return this.disconnectedAt && secondsSince(this.disconnectedAt) < this.constructor.staleThreshold;
  }
  visibilityDidChange() {
    if (document.visibilityState === "visible") {
      setTimeout((() => {
        if (this.connectionIsStale() || !this.connection.isOpen()) {
          logger.log(`ConnectionMonitor reopening stale connection on visibilitychange. visibilityState = ${document.visibilityState}`);
          this.connection.reopen();
        }
      }), 200);
    }
  }
}

ConnectionMonitor.pollInterval = {
  min: 3,
  max: 30,
  multiplier: 5
};

ConnectionMonitor.staleThreshold = 6;

var INTERNAL = {
  message_types: {
    welcome: "welcome",
    disconnect: "disconnect",
    ping: "ping",
    confirmation: "confirm_subscription",
    rejection: "reject_subscription"
  },
  disconnect_reasons: {
    unauthorized: "unauthorized",
    invalid_request: "invalid_request",
    server_restart: "server_restart"
  },
  default_mount_path: "/cable",
  protocols: [ "actioncable-v1-json", "actioncable-unsupported" ]
};

const {message_types: message_types, protocols: protocols} = INTERNAL;

const supportedProtocols = protocols.slice(0, protocols.length - 1);

const indexOf = [].indexOf;

class Connection {
  constructor(consumer) {
    this.open = this.open.bind(this);
    this.consumer = consumer;
    this.subscriptions = this.consumer.subscriptions;
    this.monitor = new ConnectionMonitor(this);
    this.disconnected = true;
  }
  send(data) {
    if (this.isOpen()) {
      this.webSocket.send(JSON.stringify(data));
      return true;
    } else {
      return false;
    }
  }
  open() {
    if (this.isActive()) {
      logger.log(`Attempted to open WebSocket, but existing socket is ${this.getState()}`);
      return false;
    } else {
      logger.log(`Opening WebSocket, current state is ${this.getState()}, subprotocols: ${protocols}`);
      if (this.webSocket) {
        this.uninstallEventHandlers();
      }
      this.webSocket = new adapters.WebSocket(this.consumer.url, protocols);
      this.installEventHandlers();
      this.monitor.start();
      return true;
    }
  }
  close({allowReconnect: allowReconnect} = {
    allowReconnect: true
  }) {
    if (!allowReconnect) {
      this.monitor.stop();
    }
    if (this.isActive()) {
      return this.webSocket.close();
    }
  }
  reopen() {
    logger.log(`Reopening WebSocket, current state is ${this.getState()}`);
    if (this.isActive()) {
      try {
        return this.close();
      } catch (error) {
        logger.log("Failed to reopen WebSocket", error);
      } finally {
        logger.log(`Reopening WebSocket in ${this.constructor.reopenDelay}ms`);
        setTimeout(this.open, this.constructor.reopenDelay);
      }
    } else {
      return this.open();
    }
  }
  getProtocol() {
    if (this.webSocket) {
      return this.webSocket.protocol;
    }
  }
  isOpen() {
    return this.isState("open");
  }
  isActive() {
    return this.isState("open", "connecting");
  }
  isProtocolSupported() {
    return indexOf.call(supportedProtocols, this.getProtocol()) >= 0;
  }
  isState(...states) {
    return indexOf.call(states, this.getState()) >= 0;
  }
  getState() {
    if (this.webSocket) {
      for (let state in adapters.WebSocket) {
        if (adapters.WebSocket[state] === this.webSocket.readyState) {
          return state.toLowerCase();
        }
      }
    }
    return null;
  }
  installEventHandlers() {
    for (let eventName in this.events) {
      const handler = this.events[eventName].bind(this);
      this.webSocket[`on${eventName}`] = handler;
    }
  }
  uninstallEventHandlers() {
    for (let eventName in this.events) {
      this.webSocket[`on${eventName}`] = function() {};
    }
  }
}

Connection.reopenDelay = 500;

Connection.prototype.events = {
  message(event) {
    if (!this.isProtocolSupported()) {
      return;
    }
    const {identifier: identifier, message: message, reason: reason, reconnect: reconnect, type: type} = JSON.parse(event.data);
    switch (type) {
     case message_types.welcome:
      this.monitor.recordConnect();
      return this.subscriptions.reload();

     case message_types.disconnect:
      logger.log(`Disconnecting. Reason: ${reason}`);
      return this.close({
        allowReconnect: reconnect
      });

     case message_types.ping:
      return this.monitor.recordPing();

     case message_types.confirmation:
      return this.subscriptions.notify(identifier, "connected");

     case message_types.rejection:
      return this.subscriptions.reject(identifier);

     default:
      return this.subscriptions.notify(identifier, "received", message);
    }
  },
  open() {
    logger.log(`WebSocket onopen event, using '${this.getProtocol()}' subprotocol`);
    this.disconnected = false;
    if (!this.isProtocolSupported()) {
      logger.log("Protocol is unsupported. Stopping monitor and disconnecting.");
      return this.close({
        allowReconnect: false
      });
    }
  },
  close(event) {
    logger.log("WebSocket onclose event");
    if (this.disconnected) {
      return;
    }
    this.disconnected = true;
    this.monitor.recordDisconnect();
    return this.subscriptions.notifyAll("disconnected", {
      willAttemptReconnect: this.monitor.isRunning()
    });
  },
  error() {
    logger.log("WebSocket onerror event");
  }
};

const extend = function(object, properties) {
  if (properties != null) {
    for (let key in properties) {
      const value = properties[key];
      object[key] = value;
    }
  }
  return object;
};

class Subscription {
  constructor(consumer, params = {}, mixin) {
    this.consumer = consumer;
    this.identifier = JSON.stringify(params);
    extend(this, mixin);
  }
  perform(action, data = {}) {
    data.action = action;
    return this.send(data);
  }
  send(data) {
    return this.consumer.send({
      command: "message",
      identifier: this.identifier,
      data: JSON.stringify(data)
    });
  }
  unsubscribe() {
    return this.consumer.subscriptions.remove(this);
  }
}

class Subscriptions {
  constructor(consumer) {
    this.consumer = consumer;
    this.subscriptions = [];
  }
  create(channelName, mixin) {
    const channel = channelName;
    const params = typeof channel === "object" ? channel : {
      channel: channel
    };
    const subscription = new Subscription(this.consumer, params, mixin);
    return this.add(subscription);
  }
  add(subscription) {
    this.subscriptions.push(subscription);
    this.consumer.ensureActiveConnection();
    this.notify(subscription, "initialized");
    this.sendCommand(subscription, "subscribe");
    return subscription;
  }
  remove(subscription) {
    this.forget(subscription);
    if (!this.findAll(subscription.identifier).length) {
      this.sendCommand(subscription, "unsubscribe");
    }
    return subscription;
  }
  reject(identifier) {
    return this.findAll(identifier).map((subscription => {
      this.forget(subscription);
      this.notify(subscription, "rejected");
      return subscription;
    }));
  }
  forget(subscription) {
    this.subscriptions = this.subscriptions.filter((s => s !== subscription));
    return subscription;
  }
  findAll(identifier) {
    return this.subscriptions.filter((s => s.identifier === identifier));
  }
  reload() {
    return this.subscriptions.map((subscription => this.sendCommand(subscription, "subscribe")));
  }
  notifyAll(callbackName, ...args) {
    return this.subscriptions.map((subscription => this.notify(subscription, callbackName, ...args)));
  }
  notify(subscription, callbackName, ...args) {
    let subscriptions;
    if (typeof subscription === "string") {
      subscriptions = this.findAll(subscription);
    } else {
      subscriptions = [ subscription ];
    }
    return subscriptions.map((subscription => typeof subscription[callbackName] === "function" ? subscription[callbackName](...args) : undefined));
  }
  sendCommand(subscription, command) {
    const {identifier: identifier} = subscription;
    return this.consumer.send({
      command: command,
      identifier: identifier
    });
  }
}

class Consumer {
  constructor(url) {
    this._url = url;
    this.subscriptions = new Subscriptions(this);
    this.connection = new Connection(this);
  }
  get url() {
    return createWebSocketURL(this._url);
  }
  send(data) {
    return this.connection.send(data);
  }
  connect() {
    return this.connection.open();
  }
  disconnect() {
    return this.connection.close({
      allowReconnect: false
    });
  }
  ensureActiveConnection() {
    if (!this.connection.isActive()) {
      return this.connection.open();
    }
  }
}

function createWebSocketURL(url) {
  if (typeof url === "function") {
    url = url();
  }
  if (url && !/^wss?:/i.test(url)) {
    const a = document.createElement("a");
    a.href = url;
    a.href = a.href;
    a.protocol = a.protocol.replace("http", "ws");
    return a.href;
  } else {
    return url;
  }
}

function createConsumer$1(url = getConfig("url") || INTERNAL.default_mount_path) {
  return new Consumer(url);
}

function getConfig(name) {
  const element = document.head.querySelector(`meta[name='action-cable-${name}']`);
  if (element) {
    return element.getAttribute("content");
  }
}

var index = Object.freeze({
  __proto__: null,
  Connection: Connection,
  ConnectionMonitor: ConnectionMonitor,
  Consumer: Consumer,
  INTERNAL: INTERNAL,
  Subscription: Subscription,
  Subscriptions: Subscriptions,
  adapters: adapters,
  createWebSocketURL: createWebSocketURL,
  logger: logger,
  createConsumer: createConsumer$1,
  getConfig: getConfig
});

export { turbo_es2017Esm as Turbo, cable };
