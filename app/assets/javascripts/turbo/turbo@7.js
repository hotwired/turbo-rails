/******/ (function(modules) { // webpackBootstrap
/******/ 	// install a JSONP callback for chunk loading
/******/ 	function webpackJsonpCallback(data) {
/******/ 		var chunkIds = data[0];
/******/ 		var moreModules = data[1];
/******/
/******/
/******/ 		// add "moreModules" to the modules object,
/******/ 		// then flag all "chunkIds" as loaded and fire callback
/******/ 		var moduleId, chunkId, i = 0, resolves = [];
/******/ 		for(;i < chunkIds.length; i++) {
/******/ 			chunkId = chunkIds[i];
/******/ 			if(Object.prototype.hasOwnProperty.call(installedChunks, chunkId) && installedChunks[chunkId]) {
/******/ 				resolves.push(installedChunks[chunkId][0]);
/******/ 			}
/******/ 			installedChunks[chunkId] = 0;
/******/ 		}
/******/ 		for(moduleId in moreModules) {
/******/ 			if(Object.prototype.hasOwnProperty.call(moreModules, moduleId)) {
/******/ 				modules[moduleId] = moreModules[moduleId];
/******/ 			}
/******/ 		}
/******/ 		if(parentJsonpFunction) parentJsonpFunction(data);
/******/
/******/ 		while(resolves.length) {
/******/ 			resolves.shift()();
/******/ 		}
/******/
/******/ 	};
/******/
/******/
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// object to store loaded and loading chunks
/******/ 	// undefined = chunk not loaded, null = chunk preloaded/prefetched
/******/ 	// Promise = chunk loading, 0 = chunk loaded
/******/ 	var installedChunks = {
/******/ 		6: 0
/******/ 	};
/******/
/******/
/******/
/******/ 	// script path function
/******/ 	function jsonpScriptSrc(chunkId) {
/******/ 		return __webpack_require__.p + "js/" + ({"4":"smoothscroll-polyfill"}[chunkId]||chunkId) + "-" + {"4":"a9d03a0e125caf728eb1"}[chunkId] + ".chunk.js"
/******/ 	}
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/ 	// This file contains only the entry chunk.
/******/ 	// The chunk loading function for additional chunks
/******/ 	__webpack_require__.e = function requireEnsure(chunkId) {
/******/ 		var promises = [];
/******/
/******/
/******/ 		// JSONP chunk loading for javascript
/******/
/******/ 		var installedChunkData = installedChunks[chunkId];
/******/ 		if(installedChunkData !== 0) { // 0 means "already installed".
/******/
/******/ 			// a Promise means "currently loading".
/******/ 			if(installedChunkData) {
/******/ 				promises.push(installedChunkData[2]);
/******/ 			} else {
/******/ 				// setup Promise in chunk cache
/******/ 				var promise = new Promise(function(resolve, reject) {
/******/ 					installedChunkData = installedChunks[chunkId] = [resolve, reject];
/******/ 				});
/******/ 				promises.push(installedChunkData[2] = promise);
/******/
/******/ 				// start chunk loading
/******/ 				var script = document.createElement('script');
/******/ 				var onScriptComplete;
/******/
/******/ 				script.charset = 'utf-8';
/******/ 				script.timeout = 120;
/******/ 				if (__webpack_require__.nc) {
/******/ 					script.setAttribute("nonce", __webpack_require__.nc);
/******/ 				}
/******/ 				script.src = jsonpScriptSrc(chunkId);
/******/
/******/ 				// create error before stack unwound to get useful stacktrace later
/******/ 				var error = new Error();
/******/ 				onScriptComplete = function (event) {
/******/ 					// avoid mem leaks in IE.
/******/ 					script.onerror = script.onload = null;
/******/ 					clearTimeout(timeout);
/******/ 					var chunk = installedChunks[chunkId];
/******/ 					if(chunk !== 0) {
/******/ 						if(chunk) {
/******/ 							var errorType = event && (event.type === 'load' ? 'missing' : event.type);
/******/ 							var realSrc = event && event.target && event.target.src;
/******/ 							error.message = 'Loading chunk ' + chunkId + ' failed.\n(' + errorType + ': ' + realSrc + ')';
/******/ 							error.name = 'ChunkLoadError';
/******/ 							error.type = errorType;
/******/ 							error.request = realSrc;
/******/ 							chunk[1](error);
/******/ 						}
/******/ 						installedChunks[chunkId] = undefined;
/******/ 					}
/******/ 				};
/******/ 				var timeout = setTimeout(function(){
/******/ 					onScriptComplete({ type: 'timeout', target: script });
/******/ 				}, 120000);
/******/ 				script.onerror = script.onload = onScriptComplete;
/******/ 				document.head.appendChild(script);
/******/ 			}
/******/ 		}
/******/ 		return Promise.all(promises);
/******/ 	};
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/packs/";
/******/
/******/ 	// on error function for async loading
/******/ 	__webpack_require__.oe = function(err) { console.error(err); throw err; };
/******/
/******/ 	var jsonpArray = window["webpackJsonp"] = window["webpackJsonp"] || [];
/******/ 	var oldJsonpFunction = jsonpArray.push.bind(jsonpArray);
/******/ 	jsonpArray.push = webpackJsonpCallback;
/******/ 	jsonpArray = jsonpArray.slice();
/******/ 	for(var i = 0; i < jsonpArray.length; i++) webpackJsonpCallback(jsonpArray[i]);
/******/ 	var parentJsonpFunction = oldJsonpFunction;
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 92);
/******/ })
/************************************************************************/
/******/ ({

/***/ 0:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";

// EXPORTS
__webpack_require__.d(__webpack_exports__, "l", function() { return /* reexport */ request_helpers_request; });
__webpack_require__.d(__webpack_exports__, "n", function() { return /* reexport */ subscribeTo; });
__webpack_require__.d(__webpack_exports__, "g", function() { return /* reexport */ getCableConsumer; });
__webpack_require__.d(__webpack_exports__, "d", function() { return /* reexport */ debounce; });
__webpack_require__.d(__webpack_exports__, "i", function() { return /* reexport */ isMobile; });
__webpack_require__.d(__webpack_exports__, "h", function() { return /* reexport */ isIosApp; });
__webpack_require__.d(__webpack_exports__, "j", function() { return /* reexport */ isMobileApp; });
__webpack_require__.d(__webpack_exports__, "k", function() { return /* reexport */ nextFrame; });
__webpack_require__.d(__webpack_exports__, "e", function() { return /* reexport */ delay; });
__webpack_require__.d(__webpack_exports__, "m", function() { return /* reexport */ scrollToElement; });
__webpack_require__.d(__webpack_exports__, "c", function() { return /* reexport */ current; });
__webpack_require__.d(__webpack_exports__, "b", function() { return /* reexport */ copyText; });
__webpack_require__.d(__webpack_exports__, "a", function() { return /* reexport */ FocusState; });
__webpack_require__.d(__webpack_exports__, "f", function() { return /* reexport */ escapeRegExp; });

// UNUSED EXPORTS: isIos, isAndroid, isMac, isAndroidApp, nextIdle

// EXTERNAL MODULE: ./app/javascript/lib/http/index.js + 2 modules
var http = __webpack_require__(4);

// CONCATENATED MODULE: ./app/javascript/helpers/request_helpers.js
async function request_helpers_request(method,url,options){const request=new http["a" /* Request */](method,url,options);const response=await request.perform();if(!response.ok)throw new Error(response.statusCode);return request.responseKind=="json"?response.json:response.text;}["get","post","put","delete"].forEach(method=>{request_helpers_request[method]=(...args)=>request_helpers_request(method,...args);});request_helpers_request.getJSON=(url,options={})=>request_helpers_request.get(url,{responseKind:"json",...options});
// EXTERNAL MODULE: ./node_modules/@rails/actioncable/app/assets/javascripts/action_cable.js
var action_cable = __webpack_require__(7);

// CONCATENATED MODULE: ./app/javascript/helpers/cable_helpers.js
function subscribeTo(channelName,mixin){if(isIosApp)return;return getCableConsumer().subscriptions.create(channelName,mixin);}function getCableConsumer(){return Object(action_cable["createConsumer"])();}
// CONCATENATED MODULE: ./app/javascript/helpers/debounce_helpers.js
function debounce(fn,delay=10){let timeoutId=null;return(...args)=>{const callback=()=>fn.apply(this,args);clearTimeout(timeoutId);timeoutId=setTimeout(callback,delay);};}
// CONCATENATED MODULE: ./app/javascript/helpers/platform_helpers.js
const{userAgent}=window.navigator;const isIos=/iPhone|iPad/.test(userAgent);const isAndroid=/Android/.test(userAgent);const isMobile=isIos||isAndroid;const isMac=/Mac/.test(userAgent);const isIosApp=/HEY iOS/.test(userAgent);const isAndroidApp=/Haystack Android/.test(userAgent);const isMobileApp=isIosApp||isAndroidApp;
// CONCATENATED MODULE: ./app/javascript/helpers/timing_helpers.js
function nextFrame(){return new Promise(requestAnimationFrame);}function nextIdle(){return new Promise(window.requestIdleCallback||setTimeout);}function delay(ms=1){return new Promise(resolve=>setTimeout(resolve,ms));}
// CONCATENATED MODULE: ./app/javascript/helpers/scroll_helpers.js
const smoothSupported=("scrollBehavior"in document.documentElement.style);async function scrollToElement(element,{behavior="smooth",block="start",inline="nearest"}={}){if(behavior=="smooth"&&!smoothSupported)await polyfillSmooth();element.scrollIntoView({behavior,block,inline});}let smoothPolyfilled;async function polyfillSmooth(){const{polyfill}=await __webpack_require__.e(/* import() | smoothscroll-polyfill */ 4).then(__webpack_require__.t.bind(null, 128, 7));if(smoothPolyfilled)return;smoothPolyfilled=true;polyfill();}
// CONCATENATED MODULE: ./app/javascript/helpers/current_helpers.js
// On-demand JavaScript objects from "current" HTML <meta> elements. Example:
//
// <meta name="current-identity-id" content="123">
// <meta name="current-identity-time-zone-name" content="Central Time (US & Canada)">
//
// >> current.identity
// => { id: "123", timeZoneName: "Central Time (US & Canada)" }
//
// >> current.foo
// => {}
const current=new Proxy({},{get(target,propertyName){const result={};const prefix="current-"+propertyName+"-";for(const{name,content}of document.head.querySelectorAll("meta[name^="+prefix+"]")){const key=camelize(name.slice(prefix.length));result[key]=content;}return result;}});function camelize(string){return string.replace(/(?:[_-])([a-z0-9])/g,(_,char)=>char.toUpperCase());}
// CONCATENATED MODULE: ./app/javascript/helpers/clipboard_helpers.js
async function copyText(text){if("clipboard"in navigator){try{await navigator.clipboard.writeText(text);return true;}catch{// Android WebView does not support the clipboard API fully and will throw an exception
}}const node=createNode(text);document.body.append(node);const result=copyNode(node);node.remove();return result;}function createNode(text){const node=document.createElement("pre");node.style="width: 1px; height: 1px; position: fixed; top: 50%";node.textContent=text;return node;}function copyNode(node){const selection=document.getSelection();const range=document.createRange();range.selectNodeContents(node);selection.removeAllRanges();selection.addRange(range);return document.execCommand("copy");}
// CONCATENATED MODULE: ./app/javascript/helpers/focus_helpers.js
const EMPTY=[null,null];class FocusState{constructor(){this.stash=focusables=>{this.stack.push([this.pathname,focusables.map(focusable=>focusable==null?void 0:focusable.id)]);};this.restore=()=>{const[pathname,ids]=this.stack.pop()||EMPTY;if(pathname&&this.pathname===pathname){const element=ids.map(id=>document.getElementById(id)).find(element=>!!element);if(element){element.focus();return element;}}};this.stack=[];}get pathname(){return window.location.pathname;}}
// CONCATENATED MODULE: ./app/javascript/helpers/string_helpers.js
function escapeRegExp(string){return string.replace(/[.*+?^${}()|[\]\\]/g,"\\$&");}
// CONCATENATED MODULE: ./app/javascript/helpers/index.js


/***/ }),

/***/ 10:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var page_updater__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(6);
const MIME_TYPE="text/html; page-update";addEventListener("turbolinks:before-fetch-request",acceptPageUpdates);addEventListener("turbolinks:before-fetch-response",handlePageUpdates);function acceptPageUpdates(event){const{headers}=event.data.fetchOptions;headers.Accept=[MIME_TYPE,headers.Accept].join(", ");}function handlePageUpdates(event){var _fetchResponse$conten;const{fetchResponse}=event.data;if((_fetchResponse$conten=fetchResponse.contentType)==null?void 0:_fetchResponse$conten.includes(MIME_TYPE)){event.preventDefault();fetchResponse.responseHTML.then(page_updater__WEBPACK_IMPORTED_MODULE_0__[/* processPageUpdates */ "a"]);}}

/***/ }),

/***/ 11:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var turbolinks__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(3);
/* harmony import */ var helpers__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(0);
class TurboFrameElement extends HTMLElement{static get observedAttributes(){return["src"];}constructor(){super();this.controller=void 0;this.controller=new FrameController(this);}connectedCallback(){this.controller.connect();}disconnectedCallback(){this.controller.disconnect();}attributeChangedCallback(){if(this.src&&this.isActive){const value=this.controller.visit(this.src);Object.defineProperty(this,"loaded",{value,configurable:true});}}formSubmissionIntercepted(element){this.controller.formSubmissionIntercepted(element);}get src(){return this.getAttribute("src");}set src(value){if(value){this.setAttribute("src",value);}else{this.removeAttribute("src");}}get loaded(){return Promise.resolve(undefined);}get disabled(){return this.hasAttribute("disabled");}set disabled(value){if(value){this.setAttribute("disabled","");}else{this.removeAttribute("disabled");}}get autoscroll(){return this.hasAttribute("autoscroll");}set autoscroll(value){if(value){this.setAttribute("autoscroll","");}else{this.removeAttribute("autoscroll");}}get isActive(){return this.ownerDocument===document&&!this.isPreview;}get isPreview(){var _this$ownerDocument,_this$ownerDocument$d;return(_this$ownerDocument=this.ownerDocument)==null?void 0:(_this$ownerDocument$d=_this$ownerDocument.documentElement)==null?void 0:_this$ownerDocument$d.hasAttribute("data-turbolinks-preview");}}class FrameController{constructor(element){this.element=void 0;this.linkInterceptor=void 0;this.formInterceptor=void 0;this.formSubmission=void 0;this.resolveVisitPromise=()=>{};this.element=element;this.linkInterceptor=new LinkInterceptor(this,this.element);this.formInterceptor=new FormInterceptor(this,this.element);}connect(){this.linkInterceptor.start();this.formInterceptor.start();}disconnect(){this.linkInterceptor.stop();this.formInterceptor.stop();}shouldInterceptLinkClick(element,url){return this.shouldInterceptNavigation(element);}linkClickIntercepted(element,url){const frame=this.findFrameElement(element);frame.src=url;}shouldInterceptFormSubmission(element){return this.shouldInterceptNavigation(element);}formSubmissionIntercepted(element){if(this.formSubmission){this.formSubmission.stop();}this.formSubmission=new turbolinks__WEBPACK_IMPORTED_MODULE_0__["FormSubmission"](this,element);this.formSubmission.start();}async visit(url){const location=turbolinks__WEBPACK_IMPORTED_MODULE_0__["Location"].wrap(url);const request=new turbolinks__WEBPACK_IMPORTED_MODULE_0__["FetchRequest"](this,turbolinks__WEBPACK_IMPORTED_MODULE_0__["FetchMethod"].get,location);return new Promise(resolve=>{this.resolveVisitPromise=()=>{this.resolveVisitPromise=()=>{};resolve();};request.perform();});}additionalHeadersForRequest(request){return{"X-Turbo-Frame":this.id};}requestStarted(request){this.element.setAttribute("busy","");}requestPreventedHandlingResponse(request,response){this.resolveVisitPromise();}async requestSucceededWithResponse(request,response){await this.loadResponse(response);this.resolveVisitPromise();}requestFailedWithResponse(request,response){console.error(response);this.resolveVisitPromise();}requestErrored(request,error){console.error(error);this.resolveVisitPromise();}requestFinished(request){this.element.removeAttribute("busy");}formSubmissionStarted(formSubmission){}formSubmissionSucceededWithResponse(formSubmission,response){const frame=this.findFrameElement(formSubmission.formElement);frame.controller.loadResponse(response);}formSubmissionFailedWithResponse(formSubmission,fetchResponse){}formSubmissionErrored(formSubmission,error){}formSubmissionFinished(formSubmission){}findFrameElement(element){var _getFrameElementById;const id=element.getAttribute("data-turbo-frame");return(_getFrameElementById=getFrameElementById(id))!=null?_getFrameElementById:this.element;}async loadResponse(response){const fragment=fragmentFromHTML(await response.responseHTML);const element=await this.extractForeignFrameElement(fragment);if(element){await Object(helpers__WEBPACK_IMPORTED_MODULE_1__[/* nextFrame */ "k"])();this.loadFrameElement(element);this.scrollFrameIntoView(element);await Object(helpers__WEBPACK_IMPORTED_MODULE_1__[/* nextFrame */ "k"])();this.focusFirstAutofocusableElement();}}async extractForeignFrameElement(container){let element;const id=CSS.escape(this.id);if(element=activateElement(container.querySelector("turbo-frame#"+id))){return element;}if(element=activateElement(container.querySelector("turbo-frame[src][recurse~="+id+"]"))){await element.loaded;return await this.extractForeignFrameElement(element);}}loadFrameElement(frameElement){var _frameElement$ownerDo;const destinationRange=document.createRange();destinationRange.selectNodeContents(this.element);destinationRange.deleteContents();const sourceRange=(_frameElement$ownerDo=frameElement.ownerDocument)==null?void 0:_frameElement$ownerDo.createRange();if(sourceRange){sourceRange.selectNodeContents(frameElement);this.element.appendChild(sourceRange.extractContents());}}focusFirstAutofocusableElement(){const element=this.firstAutofocusableElement;if(element){element.focus();return true;}return false;}scrollFrameIntoView(frame){if(this.element.autoscroll||frame.autoscroll){const element=this.element.firstElementChild;const block=readScrollLogicalPosition(this.element.getAttribute("data-autoscroll-block"),"end");if(element){Object(helpers__WEBPACK_IMPORTED_MODULE_1__[/* scrollToElement */ "m"])(element,{block});return true;}}return false;}shouldInterceptNavigation(element){const id=element.getAttribute("data-turbo-frame")||this.element.getAttribute("links-target");if(!this.enabled||id=="top"){return false;}if(id){const frameElement=getFrameElementById(id);if(frameElement){return!frameElement.disabled;}}return true;}get firstAutofocusableElement(){const element=this.element.querySelector("[autofocus]");return element instanceof HTMLElement?element:null;}get id(){return this.element.id;}get enabled(){return!this.element.disabled;}}function getFrameElementById(id){if(id!=null){const element=document.getElementById(id);if(element instanceof TurboFrameElement){return element;}}}function readScrollLogicalPosition(value,defaultValue){if(value=="end"||value=="start"||value=="center"||value=="nearest"){return value;}else{return defaultValue;}}function fragmentFromHTML(html=""){const foreignDocument=document.implementation.createHTMLDocument();return foreignDocument.createRange().createContextualFragment(html);}function activateElement(element){if(element&&element.ownerDocument!==document){element=document.importNode(element,true);}if(element instanceof TurboFrameElement){return element;}}class LinkInterceptor{constructor(delegate,element){this.delegate=void 0;this.element=void 0;this.clickEvent=void 0;this.clickBubbled=event=>{if(this.respondsToEventTarget(event.target)){this.clickEvent=event;}else{delete this.clickEvent;}};this.linkClicked=event=>{if(this.clickEvent&&this.respondsToEventTarget(event.target)){if(this.delegate.shouldInterceptLinkClick(event.target,event.data.url)){this.clickEvent.preventDefault();event.preventDefault();this.delegate.linkClickIntercepted(event.target,event.data.url);}}delete this.clickEvent;};this.willVisit=()=>{delete this.clickEvent;};this.delegate=delegate;this.element=element;}start(){this.element.addEventListener("click",this.clickBubbled);document.addEventListener("turbolinks:click",this.linkClicked);document.addEventListener("turbolinks:before-visit",this.willVisit);}stop(){this.element.removeEventListener("click",this.clickBubbled);document.removeEventListener("turbolinks:click",this.linkClicked);document.removeEventListener("turbolinks:before-visit",this.willVisit);}respondsToEventTarget(target){const element=target instanceof Element?target:target instanceof Node?target.parentElement:null;return element&&element.closest("turbo-frame, html")==this.element;}}class FormInterceptor{constructor(delegate,element){this.delegate=void 0;this.element=void 0;this.submitBubbled=event=>{if(event.target instanceof HTMLFormElement){const form=event.target;if(this.delegate.shouldInterceptFormSubmission(form)){event.preventDefault();event.stopImmediatePropagation();this.delegate.formSubmissionIntercepted(form);}}};this.delegate=delegate;this.element=element;}start(){this.element.addEventListener("submit",this.submitBubbled);}stop(){this.element.removeEventListener("submit",this.submitBubbled);}}class RedirectController{constructor(element){this.element=void 0;this.linkInterceptor=void 0;this.formInterceptor=void 0;this.element=element;this.linkInterceptor=new LinkInterceptor(this,element);this.formInterceptor=new FormInterceptor(this,element);}start(){this.linkInterceptor.start();this.formInterceptor.start();}stop(){this.linkInterceptor.stop();this.formInterceptor.stop();}shouldInterceptLinkClick(element,url){return this.shouldRedirect(element);}linkClickIntercepted(element,url){const frame=this.findFrameElement(element);if(frame){frame.src=url;}}shouldInterceptFormSubmission(element){return this.shouldRedirect(element);}formSubmissionIntercepted(element){const frame=this.findFrameElement(element);if(frame){frame.formSubmissionIntercepted(element);}}shouldRedirect(element){const frame=this.findFrameElement(element);return frame?frame!=element.closest("turbo-frame"):false;}findFrameElement(element){const id=element.getAttribute("data-turbo-frame");if(id&&id!="top"){const frame=this.element.querySelector("#"+id+":not([disabled])");if(frame instanceof TurboFrameElement){return frame;}}}}customElements.define("turbo-frame",TurboFrameElement);new RedirectController(document.documentElement).start();

/***/ }),

/***/ 2:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return getCookie; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "b", function() { return setCookie; });
function getCookie(name){const cookies=document.cookie?document.cookie.split("; "):[];const prefix=encodeURIComponent(name)+"=";const cookie=cookies.find(cookie=>cookie.startsWith(prefix));if(cookie){const value=cookie.split("=").slice(1).join("=");return value?decodeURIComponent(value):undefined;}}const twentyYears=20*365*24*60*60*1000;function setCookie(name,value){const body=[name,value].map(encodeURIComponent).join("=");const expires=new Date(Date.now()+twentyYears).toUTCString();const cookie=body+"; path=/; expires="+expires;document.cookie=cookie;}

/***/ }),

/***/ 3:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
// ESM COMPAT FLAG
__webpack_require__.r(__webpack_exports__);

// EXPORTS
__webpack_require__.d(__webpack_exports__, "Controller", function() { return /* reexport */ controller_Controller; });
__webpack_require__.d(__webpack_exports__, "FetchMethod", function() { return /* reexport */ FetchMethod; });
__webpack_require__.d(__webpack_exports__, "fetchMethodFromString", function() { return /* reexport */ fetchMethodFromString; });
__webpack_require__.d(__webpack_exports__, "FetchRequest", function() { return /* reexport */ fetch_request_FetchRequest; });
__webpack_require__.d(__webpack_exports__, "FetchResponse", function() { return /* reexport */ fetch_response_FetchResponse; });
__webpack_require__.d(__webpack_exports__, "FormSubmissionState", function() { return /* reexport */ FormSubmissionState; });
__webpack_require__.d(__webpack_exports__, "FormSubmission", function() { return /* reexport */ form_submission_FormSubmission; });
__webpack_require__.d(__webpack_exports__, "Location", function() { return /* reexport */ Location; });
__webpack_require__.d(__webpack_exports__, "TimingMetric", function() { return /* reexport */ TimingMetric; });
__webpack_require__.d(__webpack_exports__, "VisitState", function() { return /* reexport */ VisitState; });
__webpack_require__.d(__webpack_exports__, "SystemStatusCode", function() { return /* reexport */ SystemStatusCode; });
__webpack_require__.d(__webpack_exports__, "Visit", function() { return /* reexport */ visit_Visit; });
__webpack_require__.d(__webpack_exports__, "controller", function() { return /* binding */ dist_controller; });
__webpack_require__.d(__webpack_exports__, "supported", function() { return /* binding */ supported; });
__webpack_require__.d(__webpack_exports__, "visit", function() { return /* binding */ dist_visit; });
__webpack_require__.d(__webpack_exports__, "clearCache", function() { return /* binding */ clearCache; });
__webpack_require__.d(__webpack_exports__, "setProgressBarDelay", function() { return /* binding */ setProgressBarDelay; });
__webpack_require__.d(__webpack_exports__, "start", function() { return /* binding */ start; });

// CONCATENATED MODULE: ./node_modules/turbolinks/dist/util.js
function array(values) {
    return Array.prototype.slice.call(values);
}
var closest = (function () {
    var html = document.documentElement;
    var match = html.matches
        || html.webkitMatchesSelector
        || html.msMatchesSelector
        || html.mozMatchesSelector;
    var closest = html.closest || function (selector) {
        var element = this;
        while (element) {
            if (match.call(element, selector)) {
                return element;
            }
            else {
                element = element.parentElement;
            }
        }
    };
    return function (element, selector) {
        return closest.call(element, selector);
    };
})();
function defer(callback) {
    setTimeout(callback, 1);
}
function dispatch(eventName, _a) {
    var _b = _a === void 0 ? {} : _a, target = _b.target, cancelable = _b.cancelable, data = _b.data;
    var event = document.createEvent("Events");
    event.initEvent(eventName, true, cancelable == true);
    event.data = data || {};
    // Fix setting `defaultPrevented` when `preventDefault()` is called
    // http://stackoverflow.com/questions/23349191/event-preventdefault-is-not-working-in-ie-11-for-custom-events
    if (event.cancelable && !preventDefaultSupported) {
        var preventDefault_1 = event.preventDefault;
        event.preventDefault = function () {
            if (!this.defaultPrevented) {
                Object.defineProperty(this, "defaultPrevented", { get: function () { return true; } });
            }
            preventDefault_1.call(this);
        };
    }
    (target || document).dispatchEvent(event);
    return event;
}
var preventDefaultSupported = (function () {
    var event = document.createEvent("Events");
    event.initEvent("test", true, true);
    event.preventDefault();
    return event.defaultPrevented;
})();
function unindent(strings) {
    var values = [];
    for (var _i = 1; _i < arguments.length; _i++) {
        values[_i - 1] = arguments[_i];
    }
    var lines = trimLeft(interpolate(strings, values)).split("\n");
    var match = lines[0].match(/^\s+/);
    var indent = match ? match[0].length : 0;
    return lines.map(function (line) { return line.slice(indent); }).join("\n");
}
function trimLeft(string) {
    return string.replace(/^\n/, "");
}
function interpolate(strings, values) {
    return strings.reduce(function (result, string, i) {
        var value = values[i] == undefined ? "" : values[i];
        return result + string + value;
    }, "");
}
function uuid() {
    return Array.apply(null, { length: 36 }).map(function (_, i) {
        if (i == 8 || i == 13 || i == 18 || i == 23) {
            return "-";
        }
        else if (i == 14) {
            return "4";
        }
        else if (i == 19) {
            return (Math.floor(Math.random() * 4) + 8).toString(16);
        }
        else {
            return Math.floor(Math.random() * 15).toString(16);
        }
    }).join("");
}
//# sourceMappingURL=util.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/progress_bar.js
var __makeTemplateObject = (undefined && undefined.__makeTemplateObject) || function (cooked, raw) {
    if (Object.defineProperty) { Object.defineProperty(cooked, "raw", { value: raw }); } else { cooked.raw = raw; }
    return cooked;
};

var progress_bar_ProgressBar = /** @class */ (function () {
    function ProgressBar() {
        var _this = this;
        this.hiding = false;
        this.value = 0;
        this.visible = false;
        this.trickle = function () {
            _this.setValue(_this.value + Math.random() / 100);
        };
        this.stylesheetElement = this.createStylesheetElement();
        this.progressElement = this.createProgressElement();
        this.installStylesheetElement();
        this.setValue(0);
    }
    Object.defineProperty(ProgressBar, "defaultCSS", {
        get: function () {
            return unindent(templateObject_1 || (templateObject_1 = __makeTemplateObject(["\n      .turbolinks-progress-bar {\n        position: fixed;\n        display: block;\n        top: 0;\n        left: 0;\n        height: 3px;\n        background: #0076ff;\n        z-index: 9999;\n        transition:\n          width ", "ms ease-out,\n          opacity ", "ms ", "ms ease-in;\n        transform: translate3d(0, 0, 0);\n      }\n    "], ["\n      .turbolinks-progress-bar {\n        position: fixed;\n        display: block;\n        top: 0;\n        left: 0;\n        height: 3px;\n        background: #0076ff;\n        z-index: 9999;\n        transition:\n          width ", "ms ease-out,\n          opacity ", "ms ", "ms ease-in;\n        transform: translate3d(0, 0, 0);\n      }\n    "])), ProgressBar.animationDuration, ProgressBar.animationDuration / 2, ProgressBar.animationDuration / 2);
        },
        enumerable: true,
        configurable: true
    });
    ProgressBar.prototype.show = function () {
        if (!this.visible) {
            this.visible = true;
            this.installProgressElement();
            this.startTrickling();
        }
    };
    ProgressBar.prototype.hide = function () {
        var _this = this;
        if (this.visible && !this.hiding) {
            this.hiding = true;
            this.fadeProgressElement(function () {
                _this.uninstallProgressElement();
                _this.stopTrickling();
                _this.visible = false;
                _this.hiding = false;
            });
        }
    };
    ProgressBar.prototype.setValue = function (value) {
        this.value = value;
        this.refresh();
    };
    // Private
    ProgressBar.prototype.installStylesheetElement = function () {
        document.head.insertBefore(this.stylesheetElement, document.head.firstChild);
    };
    ProgressBar.prototype.installProgressElement = function () {
        this.progressElement.style.width = "0";
        this.progressElement.style.opacity = "1";
        document.documentElement.insertBefore(this.progressElement, document.body);
        this.refresh();
    };
    ProgressBar.prototype.fadeProgressElement = function (callback) {
        this.progressElement.style.opacity = "0";
        setTimeout(callback, ProgressBar.animationDuration * 1.5);
    };
    ProgressBar.prototype.uninstallProgressElement = function () {
        if (this.progressElement.parentNode) {
            document.documentElement.removeChild(this.progressElement);
        }
    };
    ProgressBar.prototype.startTrickling = function () {
        if (!this.trickleInterval) {
            this.trickleInterval = window.setInterval(this.trickle, ProgressBar.animationDuration);
        }
    };
    ProgressBar.prototype.stopTrickling = function () {
        window.clearInterval(this.trickleInterval);
        delete this.trickleInterval;
    };
    ProgressBar.prototype.refresh = function () {
        var _this = this;
        requestAnimationFrame(function () {
            _this.progressElement.style.width = 10 + (_this.value * 90) + "%";
        });
    };
    ProgressBar.prototype.createStylesheetElement = function () {
        var element = document.createElement("style");
        element.type = "text/css";
        element.textContent = ProgressBar.defaultCSS;
        return element;
    };
    ProgressBar.prototype.createProgressElement = function () {
        var element = document.createElement("div");
        element.className = "turbolinks-progress-bar";
        return element;
    };
    ProgressBar.animationDuration = 300; /*ms*/
    return ProgressBar;
}());

var templateObject_1;
//# sourceMappingURL=progress_bar.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/location.js
var Location = /** @class */ (function () {
    function Location(url) {
        var linkWithAnchor = document.createElement("a");
        linkWithAnchor.href = url;
        this.absoluteURL = linkWithAnchor.href;
        var anchorLength = linkWithAnchor.hash.length;
        if (anchorLength < 2) {
            this.requestURL = this.absoluteURL;
        }
        else {
            this.requestURL = this.absoluteURL.slice(0, -anchorLength);
            this.anchor = linkWithAnchor.hash.slice(1);
        }
    }
    Object.defineProperty(Location, "currentLocation", {
        get: function () {
            return this.wrap(window.location.toString());
        },
        enumerable: true,
        configurable: true
    });
    Location.wrap = function (locatable) {
        if (typeof locatable == "string") {
            return new this(locatable);
        }
        else if (locatable != null) {
            return locatable;
        }
    };
    Location.prototype.getOrigin = function () {
        return this.absoluteURL.split("/", 3).join("/");
    };
    Location.prototype.getPath = function () {
        return (this.requestURL.match(/\/\/[^/]*(\/[^?;]*)/) || [])[1] || "/";
    };
    Location.prototype.getPathComponents = function () {
        return this.getPath().split("/").slice(1);
    };
    Location.prototype.getLastPathComponent = function () {
        return this.getPathComponents().slice(-1)[0];
    };
    Location.prototype.getExtension = function () {
        return (this.getLastPathComponent().match(/\.[^.]*$/) || [])[0] || "";
    };
    Location.prototype.isHTML = function () {
        return !!this.getExtension().match(/^(?:|\.(?:htm|html|xhtml))$/);
    };
    Location.prototype.isPrefixedBy = function (location) {
        var prefixURL = getPrefixURL(location);
        return this.isEqualTo(location) || stringStartsWith(this.absoluteURL, prefixURL);
    };
    Location.prototype.isEqualTo = function (location) {
        return location && this.absoluteURL === location.absoluteURL;
    };
    Location.prototype.toCacheKey = function () {
        return this.requestURL;
    };
    Location.prototype.toJSON = function () {
        return this.absoluteURL;
    };
    Location.prototype.toString = function () {
        return this.absoluteURL;
    };
    Location.prototype.valueOf = function () {
        return this.absoluteURL;
    };
    return Location;
}());

function getPrefixURL(location) {
    return addTrailingSlash(location.getOrigin() + location.getPath());
}
function addTrailingSlash(url) {
    return stringEndsWith(url, "/") ? url : url + "/";
}
function stringStartsWith(string, prefix) {
    return string.slice(0, prefix.length) === prefix;
}
function stringEndsWith(string, suffix) {
    return string.slice(-suffix.length) === suffix;
}
//# sourceMappingURL=location.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/fetch_response.js

var fetch_response_FetchResponse = /** @class */ (function () {
    function FetchResponse(response) {
        this.response = response;
    }
    Object.defineProperty(FetchResponse.prototype, "succeeded", {
        get: function () {
            return this.response.ok;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(FetchResponse.prototype, "failed", {
        get: function () {
            return !this.succeeded;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(FetchResponse.prototype, "redirected", {
        get: function () {
            return this.response.redirected;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(FetchResponse.prototype, "location", {
        get: function () {
            return Location.wrap(this.response.url);
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(FetchResponse.prototype, "isHTML", {
        get: function () {
            return this.contentType && this.contentType.match(/^text\/html|^application\/xhtml\+xml/);
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(FetchResponse.prototype, "statusCode", {
        get: function () {
            return this.response.status;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(FetchResponse.prototype, "contentType", {
        get: function () {
            return this.header("Content-Type");
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(FetchResponse.prototype, "responseText", {
        get: function () {
            return this.response.text();
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(FetchResponse.prototype, "responseHTML", {
        get: function () {
            if (this.isHTML) {
                return this.response.text();
            }
            else {
                return Promise.resolve(undefined);
            }
        },
        enumerable: true,
        configurable: true
    });
    FetchResponse.prototype.header = function (name) {
        return this.response.headers.get(name);
    };
    return FetchResponse;
}());

//# sourceMappingURL=fetch_response.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/fetch_request.js
var __assign = (undefined && undefined.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
var __awaiter = (undefined && undefined.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (undefined && undefined.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};


var FetchMethod;
(function (FetchMethod) {
    FetchMethod[FetchMethod["get"] = 0] = "get";
    FetchMethod[FetchMethod["post"] = 1] = "post";
    FetchMethod[FetchMethod["put"] = 2] = "put";
    FetchMethod[FetchMethod["patch"] = 3] = "patch";
    FetchMethod[FetchMethod["delete"] = 4] = "delete";
})(FetchMethod || (FetchMethod = {}));
function fetchMethodFromString(method) {
    switch (method.toLowerCase()) {
        case "get": return FetchMethod.get;
        case "post": return FetchMethod.post;
        case "put": return FetchMethod.put;
        case "patch": return FetchMethod.patch;
        case "delete": return FetchMethod.delete;
    }
}
var fetch_request_FetchRequest = /** @class */ (function () {
    function FetchRequest(delegate, method, location, body) {
        this.abortController = new AbortController;
        this.delegate = delegate;
        this.method = method;
        this.location = location;
        this.body = body;
    }
    Object.defineProperty(FetchRequest.prototype, "url", {
        get: function () {
            var url = this.location.absoluteURL;
            var query = this.params.toString();
            if (this.isIdempotent && query.length) {
                return [url, query].join(url.includes("?") ? "&" : "?");
            }
            else {
                return url;
            }
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(FetchRequest.prototype, "params", {
        get: function () {
            return this.entries.reduce(function (params, _a) {
                var name = _a[0], value = _a[1];
                params.append(name, value.toString());
                return params;
            }, new URLSearchParams);
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(FetchRequest.prototype, "entries", {
        get: function () {
            return this.body ? Array.from(this.body.entries()) : [];
        },
        enumerable: true,
        configurable: true
    });
    FetchRequest.prototype.cancel = function () {
        this.abortController.abort();
    };
    FetchRequest.prototype.perform = function () {
        return __awaiter(this, void 0, void 0, function () {
            var fetchOptions, response, error_1;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        fetchOptions = this.fetchOptions;
                        dispatch("turbolinks:before-fetch-request", { data: { fetchOptions: fetchOptions } });
                        _a.label = 1;
                    case 1:
                        _a.trys.push([1, 4, 5, 6]);
                        this.delegate.requestStarted(this);
                        return [4 /*yield*/, fetch(this.url, fetchOptions)];
                    case 2:
                        response = _a.sent();
                        return [4 /*yield*/, this.receive(response)];
                    case 3: return [2 /*return*/, _a.sent()];
                    case 4:
                        error_1 = _a.sent();
                        this.delegate.requestErrored(this, error_1);
                        throw error_1;
                    case 5:
                        this.delegate.requestFinished(this);
                        return [7 /*endfinally*/];
                    case 6: return [2 /*return*/];
                }
            });
        });
    };
    FetchRequest.prototype.receive = function (response) {
        return __awaiter(this, void 0, void 0, function () {
            var fetchResponse, event;
            return __generator(this, function (_a) {
                fetchResponse = new fetch_response_FetchResponse(response);
                event = dispatch("turbolinks:before-fetch-response", { cancelable: true, data: { fetchResponse: fetchResponse } });
                if (event.defaultPrevented) {
                    this.delegate.requestPreventedHandlingResponse(this, fetchResponse);
                }
                else if (fetchResponse.succeeded) {
                    this.delegate.requestSucceededWithResponse(this, fetchResponse);
                }
                else {
                    this.delegate.requestFailedWithResponse(this, fetchResponse);
                }
                return [2 /*return*/, fetchResponse];
            });
        });
    };
    Object.defineProperty(FetchRequest.prototype, "fetchOptions", {
        get: function () {
            return {
                method: FetchMethod[this.method].toUpperCase(),
                credentials: "same-origin",
                headers: this.headers,
                redirect: "follow",
                body: this.isIdempotent ? undefined : this.body,
                signal: this.abortSignal
            };
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(FetchRequest.prototype, "isIdempotent", {
        get: function () {
            return this.method == FetchMethod.get;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(FetchRequest.prototype, "headers", {
        get: function () {
            return __assign({ "Accept": "text/html, application/xhtml+xml" }, this.additionalHeaders);
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(FetchRequest.prototype, "additionalHeaders", {
        get: function () {
            if (typeof this.delegate.additionalHeadersForRequest == "function") {
                return this.delegate.additionalHeadersForRequest(this);
            }
            else {
                return {};
            }
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(FetchRequest.prototype, "abortSignal", {
        get: function () {
            return this.abortController.signal;
        },
        enumerable: true,
        configurable: true
    });
    return FetchRequest;
}());

//# sourceMappingURL=fetch_request.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/head_details.js
var head_details_assign = (undefined && undefined.__assign) || function () {
    head_details_assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return head_details_assign.apply(this, arguments);
};
var __spreadArrays = (undefined && undefined.__spreadArrays) || function () {
    for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;
    for (var r = Array(s), k = 0, i = 0; i < il; i++)
        for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, k++)
            r[k] = a[j];
    return r;
};

var head_details_HeadDetails = /** @class */ (function () {
    function HeadDetails(children) {
        this.detailsByOuterHTML = children.reduce(function (result, element) {
            var _a;
            var outerHTML = element.outerHTML;
            var details = outerHTML in result
                ? result[outerHTML]
                : {
                    type: elementType(element),
                    tracked: elementIsTracked(element),
                    elements: []
                };
            return head_details_assign(head_details_assign({}, result), (_a = {}, _a[outerHTML] = head_details_assign(head_details_assign({}, details), { elements: __spreadArrays(details.elements, [element]) }), _a));
        }, {});
    }
    HeadDetails.fromHeadElement = function (headElement) {
        var children = headElement ? array(headElement.children) : [];
        return new this(children);
    };
    HeadDetails.prototype.getTrackedElementSignature = function () {
        var _this = this;
        return Object.keys(this.detailsByOuterHTML)
            .filter(function (outerHTML) { return _this.detailsByOuterHTML[outerHTML].tracked; })
            .join("");
    };
    HeadDetails.prototype.getScriptElementsNotInDetails = function (headDetails) {
        return this.getElementsMatchingTypeNotInDetails("script", headDetails);
    };
    HeadDetails.prototype.getStylesheetElementsNotInDetails = function (headDetails) {
        return this.getElementsMatchingTypeNotInDetails("stylesheet", headDetails);
    };
    HeadDetails.prototype.getElementsMatchingTypeNotInDetails = function (matchedType, headDetails) {
        var _this = this;
        return Object.keys(this.detailsByOuterHTML)
            .filter(function (outerHTML) { return !(outerHTML in headDetails.detailsByOuterHTML); })
            .map(function (outerHTML) { return _this.detailsByOuterHTML[outerHTML]; })
            .filter(function (_a) {
            var type = _a.type;
            return type == matchedType;
        })
            .map(function (_a) {
            var element = _a.elements[0];
            return element;
        });
    };
    HeadDetails.prototype.getProvisionalElements = function () {
        var _this = this;
        return Object.keys(this.detailsByOuterHTML).reduce(function (result, outerHTML) {
            var _a = _this.detailsByOuterHTML[outerHTML], type = _a.type, tracked = _a.tracked, elements = _a.elements;
            if (type == null && !tracked) {
                return __spreadArrays(result, elements);
            }
            else if (elements.length > 1) {
                return __spreadArrays(result, elements.slice(1));
            }
            else {
                return result;
            }
        }, []);
    };
    HeadDetails.prototype.getMetaValue = function (name) {
        var element = this.findMetaElementByName(name);
        return element
            ? element.getAttribute("content")
            : null;
    };
    HeadDetails.prototype.findMetaElementByName = function (name) {
        var _this = this;
        return Object.keys(this.detailsByOuterHTML).reduce(function (result, outerHTML) {
            var element = _this.detailsByOuterHTML[outerHTML].elements[0];
            return elementIsMetaElementWithName(element, name) ? element : result;
        }, undefined);
    };
    return HeadDetails;
}());

function elementType(element) {
    if (elementIsScript(element)) {
        return "script";
    }
    else if (elementIsStylesheet(element)) {
        return "stylesheet";
    }
}
function elementIsTracked(element) {
    return element.getAttribute("data-turbolinks-track") == "reload";
}
function elementIsScript(element) {
    var tagName = element.tagName.toLowerCase();
    return tagName == "script";
}
function elementIsStylesheet(element) {
    var tagName = element.tagName.toLowerCase();
    return tagName == "style" || (tagName == "link" && element.getAttribute("rel") == "stylesheet");
}
function elementIsMetaElementWithName(element, name) {
    var tagName = element.tagName.toLowerCase();
    return tagName == "meta" && element.getAttribute("name") == name;
}
//# sourceMappingURL=head_details.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/snapshot.js



var snapshot_Snapshot = /** @class */ (function () {
    function Snapshot(headDetails, bodyElement) {
        this.headDetails = headDetails;
        this.bodyElement = bodyElement;
    }
    Snapshot.wrap = function (value) {
        if (value instanceof this) {
            return value;
        }
        else if (typeof value == "string") {
            return this.fromHTMLString(value);
        }
        else {
            return this.fromHTMLElement(value);
        }
    };
    Snapshot.fromHTMLString = function (html) {
        var documentElement = new DOMParser().parseFromString(html, "text/html").documentElement;
        return this.fromHTMLElement(documentElement);
    };
    Snapshot.fromHTMLElement = function (htmlElement) {
        var headElement = htmlElement.querySelector("head");
        var bodyElement = htmlElement.querySelector("body") || document.createElement("body");
        var headDetails = head_details_HeadDetails.fromHeadElement(headElement);
        return new this(headDetails, bodyElement);
    };
    Snapshot.prototype.clone = function () {
        var bodyElement = Snapshot.fromHTMLString(this.bodyElement.outerHTML).bodyElement;
        return new Snapshot(this.headDetails, bodyElement);
    };
    Snapshot.prototype.getRootLocation = function () {
        var root = this.getSetting("root", "/");
        return new Location(root);
    };
    Snapshot.prototype.getCacheControlValue = function () {
        return this.getSetting("cache-control");
    };
    Snapshot.prototype.getElementForAnchor = function (anchor) {
        try {
            return this.bodyElement.querySelector("[id='" + anchor + "'], a[name='" + anchor + "']");
        }
        catch (_a) {
            return null;
        }
    };
    Snapshot.prototype.getPermanentElements = function () {
        return array(this.bodyElement.querySelectorAll("[id][data-turbolinks-permanent]"));
    };
    Snapshot.prototype.getPermanentElementById = function (id) {
        return this.bodyElement.querySelector("#" + id + "[data-turbolinks-permanent]");
    };
    Snapshot.prototype.getPermanentElementsPresentInSnapshot = function (snapshot) {
        return this.getPermanentElements().filter(function (_a) {
            var id = _a.id;
            return snapshot.getPermanentElementById(id);
        });
    };
    Snapshot.prototype.findFirstAutofocusableElement = function () {
        return this.bodyElement.querySelector("[autofocus]");
    };
    Snapshot.prototype.hasAnchor = function (anchor) {
        return this.getElementForAnchor(anchor) != null;
    };
    Snapshot.prototype.isPreviewable = function () {
        return this.getCacheControlValue() != "no-preview";
    };
    Snapshot.prototype.isCacheable = function () {
        return this.getCacheControlValue() != "no-cache";
    };
    Snapshot.prototype.isVisitable = function () {
        return this.getSetting("visit-control") != "reload";
    };
    Snapshot.prototype.getSetting = function (name, defaultValue) {
        var value = this.headDetails.getMetaValue("turbolinks-" + name);
        return value == null ? defaultValue : value;
    };
    return Snapshot;
}());

//# sourceMappingURL=snapshot.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/visit.js
var visit_assign = (undefined && undefined.__assign) || function () {
    visit_assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return visit_assign.apply(this, arguments);
};
var visit_awaiter = (undefined && undefined.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var visit_generator = (undefined && undefined.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};



var TimingMetric;
(function (TimingMetric) {
    TimingMetric["visitStart"] = "visitStart";
    TimingMetric["requestStart"] = "requestStart";
    TimingMetric["requestEnd"] = "requestEnd";
    TimingMetric["visitEnd"] = "visitEnd";
})(TimingMetric || (TimingMetric = {}));
var VisitState;
(function (VisitState) {
    VisitState["initialized"] = "initialized";
    VisitState["started"] = "started";
    VisitState["canceled"] = "canceled";
    VisitState["failed"] = "failed";
    VisitState["completed"] = "completed";
})(VisitState || (VisitState = {}));
var defaultOptions = {
    action: "advance",
    historyChanged: false
};
var SystemStatusCode;
(function (SystemStatusCode) {
    SystemStatusCode[SystemStatusCode["networkFailure"] = 0] = "networkFailure";
    SystemStatusCode[SystemStatusCode["timeoutFailure"] = -1] = "timeoutFailure";
    SystemStatusCode[SystemStatusCode["contentTypeMismatch"] = -2] = "contentTypeMismatch";
})(SystemStatusCode || (SystemStatusCode = {}));
var visit_Visit = /** @class */ (function () {
    function Visit(delegate, location, restorationIdentifier, options) {
        var _this = this;
        if (options === void 0) { options = {}; }
        this.identifier = uuid();
        this.timingMetrics = {};
        this.followedRedirect = false;
        this.historyChanged = false;
        this.scrolled = false;
        this.snapshotCached = false;
        this.state = VisitState.initialized;
        // Scrolling
        this.performScroll = function () {
            if (!_this.scrolled) {
                if (_this.action == "restore") {
                    _this.scrollToRestoredPosition() || _this.scrollToTop();
                }
                else {
                    _this.scrollToAnchor() || _this.scrollToTop();
                }
                _this.scrolled = true;
            }
        };
        this.delegate = delegate;
        this.location = location;
        this.restorationIdentifier = restorationIdentifier || uuid();
        var _a = visit_assign(visit_assign({}, defaultOptions), options), action = _a.action, historyChanged = _a.historyChanged, referrer = _a.referrer, snapshotHTML = _a.snapshotHTML, response = _a.response;
        this.action = action;
        this.historyChanged = historyChanged;
        this.referrer = referrer;
        this.snapshotHTML = snapshotHTML;
        this.response = response;
    }
    Object.defineProperty(Visit.prototype, "adapter", {
        get: function () {
            return this.delegate.adapter;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(Visit.prototype, "view", {
        get: function () {
            return this.delegate.view;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(Visit.prototype, "history", {
        get: function () {
            return this.delegate.history;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(Visit.prototype, "restorationData", {
        get: function () {
            return this.history.getRestorationDataForIdentifier(this.restorationIdentifier);
        },
        enumerable: true,
        configurable: true
    });
    Visit.prototype.start = function () {
        if (this.state == VisitState.initialized) {
            this.recordTimingMetric(TimingMetric.visitStart);
            this.state = VisitState.started;
            this.adapter.visitStarted(this);
            this.delegate.visitStarted(this);
        }
    };
    Visit.prototype.cancel = function () {
        if (this.state == VisitState.started) {
            if (this.request) {
                this.request.cancel();
            }
            this.cancelRender();
            this.state = VisitState.canceled;
        }
    };
    Visit.prototype.complete = function () {
        if (this.state == VisitState.started) {
            this.recordTimingMetric(TimingMetric.visitEnd);
            this.state = VisitState.completed;
            this.adapter.visitCompleted(this);
            this.delegate.visitCompleted(this);
        }
    };
    Visit.prototype.fail = function () {
        if (this.state == VisitState.started) {
            this.state = VisitState.failed;
            this.adapter.visitFailed(this);
        }
    };
    Visit.prototype.changeHistory = function () {
        if (!this.historyChanged) {
            var actionForHistory = this.location.isEqualTo(this.referrer) ? "replace" : this.action;
            var method = this.getHistoryMethodForAction(actionForHistory);
            this.history.update(method, this.location, this.restorationIdentifier);
            this.historyChanged = true;
        }
    };
    Visit.prototype.issueRequest = function () {
        if (this.hasPreloadedResponse()) {
            this.simulateRequest();
        }
        else if (this.shouldIssueRequest() && !this.request) {
            this.request = new fetch_request_FetchRequest(this, FetchMethod.get, this.location);
            this.request.perform();
        }
    };
    Visit.prototype.simulateRequest = function () {
        if (this.response) {
            this.startRequest();
            this.recordResponse();
            this.finishRequest();
        }
    };
    Visit.prototype.startRequest = function () {
        this.recordTimingMetric(TimingMetric.requestStart);
        this.adapter.visitRequestStarted(this);
    };
    Visit.prototype.recordResponse = function (response) {
        if (response === void 0) { response = this.response; }
        this.response = response;
        if (response) {
            var statusCode = response.statusCode;
            if (isSuccessful(statusCode)) {
                this.adapter.visitRequestCompleted(this);
            }
            else {
                this.adapter.visitRequestFailedWithStatusCode(this, statusCode);
            }
        }
    };
    Visit.prototype.finishRequest = function () {
        this.recordTimingMetric(TimingMetric.requestEnd);
        this.adapter.visitRequestFinished(this);
    };
    Visit.prototype.loadResponse = function () {
        var _this = this;
        if (this.response) {
            var _a = this.response, statusCode_1 = _a.statusCode, responseHTML_1 = _a.responseHTML;
            this.render(function () {
                _this.cacheSnapshot();
                if (isSuccessful(statusCode_1) && responseHTML_1 != null) {
                    _this.view.render({ snapshot: snapshot_Snapshot.fromHTMLString(responseHTML_1) }, _this.performScroll);
                    _this.adapter.visitRendered(_this);
                    _this.complete();
                }
                else {
                    _this.view.render({ error: responseHTML_1 }, _this.performScroll);
                    _this.adapter.visitRendered(_this);
                    _this.fail();
                }
            });
        }
    };
    Visit.prototype.getCachedSnapshot = function () {
        var snapshot = this.view.getCachedSnapshotForLocation(this.location) || this.getPreloadedSnapshot();
        if (snapshot && (!this.location.anchor || snapshot.hasAnchor(this.location.anchor))) {
            if (this.action == "restore" || snapshot.isPreviewable()) {
                return snapshot;
            }
        }
    };
    Visit.prototype.getPreloadedSnapshot = function () {
        if (this.snapshotHTML) {
            return snapshot_Snapshot.wrap(this.snapshotHTML);
        }
    };
    Visit.prototype.hasCachedSnapshot = function () {
        return this.getCachedSnapshot() != null;
    };
    Visit.prototype.loadCachedSnapshot = function () {
        var _this = this;
        var snapshot = this.getCachedSnapshot();
        if (snapshot) {
            var isPreview_1 = this.shouldIssueRequest();
            this.render(function () {
                _this.cacheSnapshot();
                _this.view.render({ snapshot: snapshot, isPreview: isPreview_1 }, _this.performScroll);
                _this.adapter.visitRendered(_this);
                if (!isPreview_1) {
                    _this.complete();
                }
            });
        }
    };
    Visit.prototype.followRedirect = function () {
        if (this.redirectedToLocation && !this.followedRedirect) {
            this.location = this.redirectedToLocation;
            this.history.replace(this.redirectedToLocation, this.restorationIdentifier);
            this.followedRedirect = true;
        }
    };
    // Fetch request delegate
    Visit.prototype.requestStarted = function () {
        this.startRequest();
    };
    Visit.prototype.requestPreventedHandlingResponse = function (request, response) {
    };
    Visit.prototype.requestSucceededWithResponse = function (request, response) {
        return visit_awaiter(this, void 0, void 0, function () {
            var responseHTML;
            return visit_generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, response.responseHTML];
                    case 1:
                        responseHTML = _a.sent();
                        if (responseHTML == undefined) {
                            this.recordResponse({ statusCode: SystemStatusCode.contentTypeMismatch });
                        }
                        else {
                            this.redirectedToLocation = response.redirected ? response.location : undefined;
                            this.recordResponse({ statusCode: response.statusCode, responseHTML: responseHTML });
                        }
                        return [2 /*return*/];
                }
            });
        });
    };
    Visit.prototype.requestFailedWithResponse = function (request, response) {
        return visit_awaiter(this, void 0, void 0, function () {
            var responseHTML;
            return visit_generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, response.responseHTML];
                    case 1:
                        responseHTML = _a.sent();
                        if (responseHTML == undefined) {
                            this.recordResponse({ statusCode: SystemStatusCode.contentTypeMismatch });
                        }
                        else {
                            this.recordResponse({ statusCode: response.statusCode, responseHTML: responseHTML });
                        }
                        return [2 /*return*/];
                }
            });
        });
    };
    Visit.prototype.requestErrored = function (request, error) {
        this.recordResponse({ statusCode: SystemStatusCode.networkFailure });
    };
    Visit.prototype.requestFinished = function () {
        this.finishRequest();
    };
    Visit.prototype.scrollToRestoredPosition = function () {
        var scrollPosition = this.restorationData.scrollPosition;
        if (scrollPosition) {
            this.view.scrollToPosition(scrollPosition);
            return true;
        }
    };
    Visit.prototype.scrollToAnchor = function () {
        if (this.location.anchor != null) {
            this.view.scrollToAnchor(this.location.anchor);
            return true;
        }
    };
    Visit.prototype.scrollToTop = function () {
        this.view.scrollToPosition({ x: 0, y: 0 });
    };
    // Instrumentation
    Visit.prototype.recordTimingMetric = function (metric) {
        this.timingMetrics[metric] = new Date().getTime();
    };
    Visit.prototype.getTimingMetrics = function () {
        return visit_assign({}, this.timingMetrics);
    };
    // Private
    Visit.prototype.getHistoryMethodForAction = function (action) {
        switch (action) {
            case "replace": return history.replaceState;
            case "advance":
            case "restore": return history.pushState;
        }
    };
    Visit.prototype.hasPreloadedResponse = function () {
        return typeof this.response == "object";
    };
    Visit.prototype.shouldIssueRequest = function () {
        return this.action == "restore"
            ? !this.hasCachedSnapshot()
            : true;
    };
    Visit.prototype.cacheSnapshot = function () {
        if (!this.snapshotCached) {
            this.view.cacheSnapshot();
            this.snapshotCached = true;
        }
    };
    Visit.prototype.render = function (callback) {
        var _this = this;
        this.cancelRender();
        this.frame = requestAnimationFrame(function () {
            delete _this.frame;
            callback.call(_this);
        });
    };
    Visit.prototype.cancelRender = function () {
        if (this.frame) {
            cancelAnimationFrame(this.frame);
            delete this.frame;
        }
    };
    return Visit;
}());

function isSuccessful(statusCode) {
    return statusCode >= 200 && statusCode < 300;
}
//# sourceMappingURL=visit.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/browser_adapter.js



var browser_adapter_BrowserAdapter = /** @class */ (function () {
    function BrowserAdapter(controller) {
        var _this = this;
        this.progressBar = new progress_bar_ProgressBar;
        this.showProgressBar = function () {
            _this.progressBar.show();
        };
        this.controller = controller;
    }
    BrowserAdapter.prototype.visitProposedToLocation = function (location, options) {
        var restorationIdentifier = uuid();
        this.controller.startVisitToLocation(location, restorationIdentifier, options);
    };
    BrowserAdapter.prototype.visitStarted = function (visit) {
        visit.issueRequest();
        visit.changeHistory();
        visit.loadCachedSnapshot();
    };
    BrowserAdapter.prototype.visitRequestStarted = function (visit) {
        this.progressBar.setValue(0);
        if (visit.hasCachedSnapshot() || visit.action != "restore") {
            this.showProgressBarAfterDelay();
        }
        else {
            this.showProgressBar();
        }
    };
    BrowserAdapter.prototype.visitRequestCompleted = function (visit) {
        visit.loadResponse();
    };
    BrowserAdapter.prototype.visitRequestFailedWithStatusCode = function (visit, statusCode) {
        switch (statusCode) {
            case SystemStatusCode.networkFailure:
            case SystemStatusCode.timeoutFailure:
            case SystemStatusCode.contentTypeMismatch:
                return this.reload();
            default:
                return visit.loadResponse();
        }
    };
    BrowserAdapter.prototype.visitRequestFinished = function (visit) {
        this.progressBar.setValue(1);
        this.hideProgressBar();
    };
    BrowserAdapter.prototype.visitCompleted = function (visit) {
        visit.followRedirect();
    };
    BrowserAdapter.prototype.pageInvalidated = function () {
        this.reload();
    };
    BrowserAdapter.prototype.visitFailed = function (visit) {
    };
    BrowserAdapter.prototype.visitRendered = function (visit) {
    };
    // Private
    BrowserAdapter.prototype.showProgressBarAfterDelay = function () {
        this.progressBarTimeout = window.setTimeout(this.showProgressBar, this.controller.progressBarDelay);
    };
    BrowserAdapter.prototype.hideProgressBar = function () {
        this.progressBar.hide();
        if (this.progressBarTimeout != null) {
            window.clearTimeout(this.progressBarTimeout);
            delete this.progressBarTimeout;
        }
    };
    BrowserAdapter.prototype.reload = function () {
        window.location.reload();
    };
    return BrowserAdapter;
}());

//# sourceMappingURL=browser_adapter.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/form_submit_observer.js
var FormSubmitObserver = /** @class */ (function () {
    function FormSubmitObserver(delegate) {
        var _this = this;
        this.started = false;
        this.submitCaptured = function () {
            removeEventListener("submit", _this.submitBubbled, false);
            addEventListener("submit", _this.submitBubbled, false);
        };
        this.submitBubbled = function (event) {
            if (!event.defaultPrevented) {
                var form = event.target instanceof HTMLFormElement ? event.target : undefined;
                if (form) {
                    if (_this.delegate.willSubmitForm(form)) {
                        event.preventDefault();
                        _this.delegate.formSubmitted(form);
                    }
                }
            }
        };
        this.delegate = delegate;
    }
    FormSubmitObserver.prototype.start = function () {
        if (!this.started) {
            addEventListener("submit", this.submitCaptured, true);
            this.started = true;
        }
    };
    FormSubmitObserver.prototype.stop = function () {
        if (this.started) {
            removeEventListener("submit", this.submitCaptured, true);
            this.started = false;
        }
    };
    return FormSubmitObserver;
}());

//# sourceMappingURL=form_submit_observer.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/history.js
var history_assign = (undefined && undefined.__assign) || function () {
    history_assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return history_assign.apply(this, arguments);
};


var history_History = /** @class */ (function () {
    function History(delegate) {
        var _this = this;
        this.restorationData = {};
        this.started = false;
        this.pageLoaded = false;
        // Event handlers
        this.onPopState = function (event) {
            if (_this.shouldHandlePopState()) {
                var turbolinks = (event.state || {}).turbolinks;
                if (turbolinks) {
                    var location_1 = Location.currentLocation;
                    _this.location = location_1;
                    var restorationIdentifier = turbolinks.restorationIdentifier;
                    _this.restorationIdentifier = restorationIdentifier;
                    _this.delegate.historyPoppedToLocationWithRestorationIdentifier(location_1, restorationIdentifier);
                }
            }
        };
        this.onPageLoad = function (event) {
            defer(function () {
                _this.pageLoaded = true;
            });
        };
        this.delegate = delegate;
    }
    History.prototype.start = function () {
        if (!this.started) {
            this.previousScrollRestoration = history.scrollRestoration;
            history.scrollRestoration = "manual";
            addEventListener("popstate", this.onPopState, false);
            addEventListener("load", this.onPageLoad, false);
            this.started = true;
            this.replace(Location.currentLocation);
        }
    };
    History.prototype.stop = function () {
        var _a;
        if (this.started) {
            history.scrollRestoration = (_a = this.previousScrollRestoration) !== null && _a !== void 0 ? _a : "auto";
            removeEventListener("popstate", this.onPopState, false);
            removeEventListener("load", this.onPageLoad, false);
            this.started = false;
        }
    };
    History.prototype.push = function (location, restorationIdentifier) {
        this.update(history.pushState, location, restorationIdentifier);
    };
    History.prototype.replace = function (location, restorationIdentifier) {
        this.update(history.replaceState, location, restorationIdentifier);
    };
    History.prototype.update = function (method, location, restorationIdentifier) {
        if (restorationIdentifier === void 0) { restorationIdentifier = uuid(); }
        var state = { turbolinks: { restorationIdentifier: restorationIdentifier } };
        method.call(history, state, "", location.absoluteURL);
        this.location = location;
        this.restorationIdentifier = restorationIdentifier;
    };
    // Restoration data
    History.prototype.getRestorationDataForIdentifier = function (restorationIdentifier) {
        return this.restorationData[restorationIdentifier] || {};
    };
    History.prototype.updateRestorationData = function (additionalData) {
        var restorationIdentifier = this.restorationIdentifier;
        var restorationData = this.restorationData[restorationIdentifier];
        this.restorationData[restorationIdentifier] = history_assign(history_assign({}, restorationData), additionalData);
    };
    // Private
    History.prototype.shouldHandlePopState = function () {
        // Safari dispatches a popstate event after window's load event, ignore it
        return this.pageIsLoaded();
    };
    History.prototype.pageIsLoaded = function () {
        return this.pageLoaded || document.readyState == "complete";
    };
    return History;
}());

//# sourceMappingURL=history.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/link_click_observer.js


var link_click_observer_LinkClickObserver = /** @class */ (function () {
    function LinkClickObserver(delegate) {
        var _this = this;
        this.started = false;
        this.clickCaptured = function () {
            removeEventListener("click", _this.clickBubbled, false);
            addEventListener("click", _this.clickBubbled, false);
        };
        this.clickBubbled = function (event) {
            if (_this.clickEventIsSignificant(event)) {
                var link = _this.findLinkFromClickTarget(event.target);
                if (link) {
                    var location_1 = _this.getLocationForLink(link);
                    if (_this.delegate.willFollowLinkToLocation(link, location_1)) {
                        event.preventDefault();
                        _this.delegate.followedLinkToLocation(link, location_1);
                    }
                }
            }
        };
        this.delegate = delegate;
    }
    LinkClickObserver.prototype.start = function () {
        if (!this.started) {
            addEventListener("click", this.clickCaptured, true);
            this.started = true;
        }
    };
    LinkClickObserver.prototype.stop = function () {
        if (this.started) {
            removeEventListener("click", this.clickCaptured, true);
            this.started = false;
        }
    };
    LinkClickObserver.prototype.clickEventIsSignificant = function (event) {
        return !((event.target && event.target.isContentEditable)
            || event.defaultPrevented
            || event.which > 1
            || event.altKey
            || event.ctrlKey
            || event.metaKey
            || event.shiftKey);
    };
    LinkClickObserver.prototype.findLinkFromClickTarget = function (target) {
        if (target instanceof Element) {
            return closest(target, "a[href]:not([target^=_]):not([download])");
        }
    };
    LinkClickObserver.prototype.getLocationForLink = function (link) {
        return new Location(link.getAttribute("href") || "");
    };
    return LinkClickObserver;
}());

//# sourceMappingURL=link_click_observer.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/form_submission.js
var form_submission_assign = (undefined && undefined.__assign) || function () {
    form_submission_assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return form_submission_assign.apply(this, arguments);
};
var form_submission_awaiter = (undefined && undefined.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var form_submission_generator = (undefined && undefined.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};



var FormSubmissionState;
(function (FormSubmissionState) {
    FormSubmissionState[FormSubmissionState["initialized"] = 0] = "initialized";
    FormSubmissionState[FormSubmissionState["requesting"] = 1] = "requesting";
    FormSubmissionState[FormSubmissionState["waiting"] = 2] = "waiting";
    FormSubmissionState[FormSubmissionState["receiving"] = 3] = "receiving";
    FormSubmissionState[FormSubmissionState["stopping"] = 4] = "stopping";
    FormSubmissionState[FormSubmissionState["stopped"] = 5] = "stopped";
})(FormSubmissionState || (FormSubmissionState = {}));
var form_submission_FormSubmission = /** @class */ (function () {
    function FormSubmission(delegate, formElement, mustRedirect) {
        if (mustRedirect === void 0) { mustRedirect = false; }
        this.state = FormSubmissionState.initialized;
        this.delegate = delegate;
        this.formElement = formElement;
        this.formData = new FormData(formElement);
        this.fetchRequest = new fetch_request_FetchRequest(this, this.method, this.location, this.formData);
        this.mustRedirect = mustRedirect;
    }
    Object.defineProperty(FormSubmission.prototype, "method", {
        get: function () {
            var method = this.formElement.getAttribute("method") || "";
            return fetchMethodFromString(method.toLowerCase()) || FetchMethod.get;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(FormSubmission.prototype, "location", {
        get: function () {
            return Location.wrap(this.formElement.action);
        },
        enumerable: true,
        configurable: true
    });
    // The submission process
    FormSubmission.prototype.start = function () {
        return form_submission_awaiter(this, void 0, void 0, function () {
            var initialized, requesting;
            return form_submission_generator(this, function (_a) {
                initialized = FormSubmissionState.initialized, requesting = FormSubmissionState.requesting;
                if (this.state == initialized) {
                    this.state = requesting;
                    return [2 /*return*/, this.fetchRequest.perform()];
                }
                return [2 /*return*/];
            });
        });
    };
    FormSubmission.prototype.stop = function () {
        var stopping = FormSubmissionState.stopping, stopped = FormSubmissionState.stopped;
        if (this.state != stopping && this.state != stopped) {
            this.state = stopping;
            this.fetchRequest.cancel();
            return true;
        }
    };
    // Fetch request delegate
    FormSubmission.prototype.additionalHeadersForRequest = function (request) {
        var headers = {};
        if (this.method != FetchMethod.get) {
            var token = getCookieValue(getMetaContent("csrf-param")) || getMetaContent("csrf-token");
            if (token) {
                headers["X-CSRF-Token"] = token;
            }
        }
        return headers;
    };
    FormSubmission.prototype.requestStarted = function (request) {
        this.state = FormSubmissionState.waiting;
        dispatch("turbolinks:submit-start", { target: this.formElement, data: { formSubmission: this } });
        this.delegate.formSubmissionStarted(this);
    };
    FormSubmission.prototype.requestPreventedHandlingResponse = function (request, response) {
        this.result = { success: response.succeeded, fetchResponse: response };
    };
    FormSubmission.prototype.requestSucceededWithResponse = function (request, response) {
        if (this.requestMustRedirect(request) && !response.redirected) {
            var error = new Error("Form responses must redirect to another location");
            this.delegate.formSubmissionErrored(this, error);
        }
        else {
            this.state = FormSubmissionState.receiving;
            this.result = { success: true, fetchResponse: response };
            this.delegate.formSubmissionSucceededWithResponse(this, response);
        }
    };
    FormSubmission.prototype.requestFailedWithResponse = function (request, response) {
        this.result = { success: false, fetchResponse: response };
        this.delegate.formSubmissionFailedWithResponse(this, response);
    };
    FormSubmission.prototype.requestErrored = function (request, error) {
        this.result = { success: false, error: error };
        this.delegate.formSubmissionErrored(this, error);
    };
    FormSubmission.prototype.requestFinished = function (request) {
        this.state = FormSubmissionState.stopped;
        dispatch("turbolinks:submit-end", { target: this.formElement, data: form_submission_assign({ formSubmission: this }, this.result) });
        this.delegate.formSubmissionFinished(this);
    };
    FormSubmission.prototype.requestMustRedirect = function (request) {
        return !request.isIdempotent && this.mustRedirect;
    };
    return FormSubmission;
}());

function getCookieValue(cookieName) {
    if (cookieName != null) {
        var cookies = document.cookie ? document.cookie.split("; ") : [];
        var cookie = cookies.find(function (cookie) { return cookie.startsWith(cookieName); });
        if (cookie) {
            var value = cookie.split("=").slice(1).join("=");
            return value ? decodeURIComponent(value) : undefined;
        }
    }
}
function getMetaContent(name) {
    var element = document.querySelector("meta[name=\"" + name + "\"]");
    return element && element.content;
}
//# sourceMappingURL=form_submission.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/navigator.js
var navigator_assign = (undefined && undefined.__assign) || function () {
    navigator_assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return navigator_assign.apply(this, arguments);
};
var navigator_awaiter = (undefined && undefined.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var navigator_generator = (undefined && undefined.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};



var navigator_Navigator = /** @class */ (function () {
    function Navigator(delegate) {
        this.delegate = delegate;
    }
    Navigator.prototype.proposeVisit = function (location, options) {
        if (options === void 0) { options = {}; }
        if (this.delegate.allowsVisitingLocation(location)) {
            this.delegate.visitProposedToLocation(location, options);
        }
    };
    Navigator.prototype.startVisit = function (location, restorationIdentifier, options) {
        if (options === void 0) { options = {}; }
        this.stop();
        this.currentVisit = new visit_Visit(this, location, restorationIdentifier, navigator_assign({ referrer: this.location }, options));
        this.currentVisit.start();
    };
    Navigator.prototype.submitForm = function (form) {
        this.stop();
        this.formSubmission = new form_submission_FormSubmission(this, form, true);
        this.formSubmission.start();
    };
    Navigator.prototype.stop = function () {
        if (this.formSubmission) {
            this.formSubmission.stop();
            delete this.formSubmission;
        }
        if (this.currentVisit) {
            this.currentVisit.cancel();
            delete this.currentVisit;
        }
    };
    Navigator.prototype.reload = function () {
    };
    Navigator.prototype.goBack = function () {
    };
    Object.defineProperty(Navigator.prototype, "adapter", {
        get: function () {
            return this.delegate.adapter;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(Navigator.prototype, "view", {
        get: function () {
            return this.delegate.view;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(Navigator.prototype, "history", {
        get: function () {
            return this.delegate.history;
        },
        enumerable: true,
        configurable: true
    });
    // Form submission delegate
    Navigator.prototype.formSubmissionStarted = function (formSubmission) {
    };
    Navigator.prototype.formSubmissionSucceededWithResponse = function (formSubmission, fetchResponse) {
        return navigator_awaiter(this, void 0, void 0, function () {
            var responseHTML, statusCode, visitOptions;
            return navigator_generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        console.log("Form submission succeeded", formSubmission);
                        if (!(formSubmission == this.formSubmission)) return [3 /*break*/, 2];
                        return [4 /*yield*/, fetchResponse.responseHTML];
                    case 1:
                        responseHTML = _a.sent();
                        if (responseHTML) {
                            if (formSubmission.method != FetchMethod.get) {
                                console.log("Clearing snapshot cache after successful form submission");
                                this.view.clearSnapshotCache();
                            }
                            statusCode = fetchResponse.statusCode;
                            visitOptions = { response: { statusCode: statusCode, responseHTML: responseHTML } };
                            console.log("Visiting", fetchResponse.location, visitOptions);
                            this.proposeVisit(fetchResponse.location, visitOptions);
                        }
                        _a.label = 2;
                    case 2: return [2 /*return*/];
                }
            });
        });
    };
    Navigator.prototype.formSubmissionFailedWithResponse = function (formSubmission, fetchResponse) {
        console.error("Form submission failed", formSubmission, fetchResponse);
    };
    Navigator.prototype.formSubmissionErrored = function (formSubmission, error) {
        console.error("Form submission failed", formSubmission, error);
    };
    Navigator.prototype.formSubmissionFinished = function (formSubmission) {
    };
    // Visit delegate
    Navigator.prototype.visitStarted = function (visit) {
        this.delegate.visitStarted(visit);
    };
    Navigator.prototype.visitCompleted = function (visit) {
        this.delegate.visitCompleted(visit);
    };
    Object.defineProperty(Navigator.prototype, "location", {
        // Visits
        get: function () {
            return this.history.location;
        },
        enumerable: true,
        configurable: true
    });
    return Navigator;
}());

//# sourceMappingURL=navigator.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/page_observer.js
var PageStage;
(function (PageStage) {
    PageStage[PageStage["initial"] = 0] = "initial";
    PageStage[PageStage["loading"] = 1] = "loading";
    PageStage[PageStage["interactive"] = 2] = "interactive";
    PageStage[PageStage["complete"] = 3] = "complete";
    PageStage[PageStage["invalidated"] = 4] = "invalidated";
})(PageStage || (PageStage = {}));
var PageObserver = /** @class */ (function () {
    function PageObserver(delegate) {
        var _this = this;
        this.stage = PageStage.initial;
        this.started = false;
        this.interpretReadyState = function () {
            var readyState = _this.readyState;
            if (readyState == "interactive") {
                _this.pageIsInteractive();
            }
            else if (readyState == "complete") {
                _this.pageIsComplete();
            }
        };
        this.delegate = delegate;
    }
    PageObserver.prototype.start = function () {
        if (!this.started) {
            if (this.stage == PageStage.initial) {
                this.stage = PageStage.loading;
            }
            document.addEventListener("readystatechange", this.interpretReadyState, false);
            this.started = true;
        }
    };
    PageObserver.prototype.stop = function () {
        if (this.started) {
            document.removeEventListener("readystatechange", this.interpretReadyState, false);
            this.started = false;
        }
    };
    PageObserver.prototype.invalidate = function () {
        if (this.stage != PageStage.invalidated) {
            this.stage = PageStage.invalidated;
            this.delegate.pageInvalidated();
        }
    };
    PageObserver.prototype.pageIsInteractive = function () {
        if (this.stage == PageStage.loading) {
            this.stage = PageStage.interactive;
            this.delegate.pageBecameInteractive();
        }
    };
    PageObserver.prototype.pageIsComplete = function () {
        this.pageIsInteractive();
        if (this.stage == PageStage.interactive) {
            this.stage = PageStage.complete;
            this.delegate.pageLoaded();
        }
    };
    Object.defineProperty(PageObserver.prototype, "readyState", {
        get: function () {
            return document.readyState;
        },
        enumerable: true,
        configurable: true
    });
    return PageObserver;
}());

//# sourceMappingURL=page_observer.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/scroll_observer.js
var ScrollObserver = /** @class */ (function () {
    function ScrollObserver(delegate) {
        var _this = this;
        this.started = false;
        this.onScroll = function () {
            _this.updatePosition({ x: window.pageXOffset, y: window.pageYOffset });
        };
        this.delegate = delegate;
    }
    ScrollObserver.prototype.start = function () {
        if (!this.started) {
            addEventListener("scroll", this.onScroll, false);
            this.onScroll();
            this.started = true;
        }
    };
    ScrollObserver.prototype.stop = function () {
        if (this.started) {
            removeEventListener("scroll", this.onScroll, false);
            this.started = false;
        }
    };
    // Private
    ScrollObserver.prototype.updatePosition = function (position) {
        this.delegate.scrollPositionChanged(position);
    };
    return ScrollObserver;
}());

//# sourceMappingURL=scroll_observer.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/types.js
function isAction(action) {
    return action == "advance" || action == "replace" || action == "restore";
}
//# sourceMappingURL=types.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/renderer.js

var Renderer = /** @class */ (function () {
    function Renderer() {
    }
    Renderer.prototype.renderView = function (callback) {
        this.delegate.viewWillRender(this.newBody);
        callback();
        this.delegate.viewRendered(this.newBody);
    };
    Renderer.prototype.invalidateView = function () {
        this.delegate.viewInvalidated();
    };
    Renderer.prototype.createScriptElement = function (element) {
        if (element.getAttribute("data-turbolinks-eval") == "false") {
            return element;
        }
        else {
            var createdScriptElement = document.createElement("script");
            createdScriptElement.textContent = element.textContent;
            createdScriptElement.async = false;
            copyElementAttributes(createdScriptElement, element);
            return createdScriptElement;
        }
    };
    return Renderer;
}());

function copyElementAttributes(destinationElement, sourceElement) {
    for (var _i = 0, _a = array(sourceElement.attributes); _i < _a.length; _i++) {
        var _b = _a[_i], name_1 = _b.name, value = _b.value;
        destinationElement.setAttribute(name_1, value);
    }
}
//# sourceMappingURL=renderer.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/error_renderer.js
var __extends = (undefined && undefined.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();


var error_renderer_ErrorRenderer = /** @class */ (function (_super) {
    __extends(ErrorRenderer, _super);
    function ErrorRenderer(delegate, html) {
        var _this = _super.call(this) || this;
        _this.delegate = delegate;
        _this.htmlElement = (function () {
            var htmlElement = document.createElement("html");
            htmlElement.innerHTML = html;
            return htmlElement;
        })();
        _this.newHead = _this.htmlElement.querySelector("head") || document.createElement("head");
        _this.newBody = _this.htmlElement.querySelector("body") || document.createElement("body");
        return _this;
    }
    ErrorRenderer.render = function (delegate, callback, html) {
        return new this(delegate, html).render(callback);
    };
    ErrorRenderer.prototype.render = function (callback) {
        var _this = this;
        this.renderView(function () {
            _this.replaceHeadAndBody();
            _this.activateBodyScriptElements();
            callback();
        });
    };
    ErrorRenderer.prototype.replaceHeadAndBody = function () {
        var documentElement = document.documentElement, head = document.head, body = document.body;
        documentElement.replaceChild(this.newHead, head);
        documentElement.replaceChild(this.newBody, body);
    };
    ErrorRenderer.prototype.activateBodyScriptElements = function () {
        for (var _i = 0, _a = this.getScriptElements(); _i < _a.length; _i++) {
            var replaceableElement = _a[_i];
            var parentNode = replaceableElement.parentNode;
            if (parentNode) {
                var element = this.createScriptElement(replaceableElement);
                parentNode.replaceChild(element, replaceableElement);
            }
        }
    };
    ErrorRenderer.prototype.getScriptElements = function () {
        return array(document.documentElement.querySelectorAll("script"));
    };
    return ErrorRenderer;
}(Renderer));

//# sourceMappingURL=error_renderer.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/snapshot_cache.js
var SnapshotCache = /** @class */ (function () {
    function SnapshotCache(size) {
        this.keys = [];
        this.snapshots = {};
        this.size = size;
    }
    SnapshotCache.prototype.has = function (location) {
        return location.toCacheKey() in this.snapshots;
    };
    SnapshotCache.prototype.get = function (location) {
        if (this.has(location)) {
            var snapshot = this.read(location);
            this.touch(location);
            return snapshot;
        }
    };
    SnapshotCache.prototype.put = function (location, snapshot) {
        this.write(location, snapshot);
        this.touch(location);
        return snapshot;
    };
    SnapshotCache.prototype.clear = function () {
        this.snapshots = {};
    };
    // Private
    SnapshotCache.prototype.read = function (location) {
        return this.snapshots[location.toCacheKey()];
    };
    SnapshotCache.prototype.write = function (location, snapshot) {
        this.snapshots[location.toCacheKey()] = snapshot;
    };
    SnapshotCache.prototype.touch = function (location) {
        var key = location.toCacheKey();
        var index = this.keys.indexOf(key);
        if (index > -1)
            this.keys.splice(index, 1);
        this.keys.unshift(key);
        this.trim();
    };
    SnapshotCache.prototype.trim = function () {
        for (var _i = 0, _a = this.keys.splice(this.size); _i < _a.length; _i++) {
            var key = _a[_i];
            delete this.snapshots[key];
        }
    };
    return SnapshotCache;
}());

//# sourceMappingURL=snapshot_cache.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/snapshot_renderer.js
var snapshot_renderer_extends = (undefined && undefined.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var snapshot_renderer_spreadArrays = (undefined && undefined.__spreadArrays) || function () {
    for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;
    for (var r = Array(s), k = 0, i = 0; i < il; i++)
        for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, k++)
            r[k] = a[j];
    return r;
};


var snapshot_renderer_SnapshotRenderer = /** @class */ (function (_super) {
    snapshot_renderer_extends(SnapshotRenderer, _super);
    function SnapshotRenderer(delegate, currentSnapshot, newSnapshot, isPreview) {
        var _this = _super.call(this) || this;
        _this.delegate = delegate;
        _this.currentSnapshot = currentSnapshot;
        _this.currentHeadDetails = currentSnapshot.headDetails;
        _this.newSnapshot = newSnapshot;
        _this.newHeadDetails = newSnapshot.headDetails;
        _this.newBody = newSnapshot.bodyElement;
        _this.isPreview = isPreview;
        return _this;
    }
    SnapshotRenderer.render = function (delegate, callback, currentSnapshot, newSnapshot, isPreview) {
        return new this(delegate, currentSnapshot, newSnapshot, isPreview).render(callback);
    };
    SnapshotRenderer.prototype.render = function (callback) {
        var _this = this;
        if (this.shouldRender()) {
            this.mergeHead();
            this.renderView(function () {
                _this.replaceBody();
                if (!_this.isPreview) {
                    _this.focusFirstAutofocusableElement();
                }
                callback();
            });
        }
        else {
            this.invalidateView();
        }
    };
    SnapshotRenderer.prototype.mergeHead = function () {
        this.copyNewHeadStylesheetElements();
        this.copyNewHeadScriptElements();
        this.removeCurrentHeadProvisionalElements();
        this.copyNewHeadProvisionalElements();
    };
    SnapshotRenderer.prototype.replaceBody = function () {
        var placeholders = this.relocateCurrentBodyPermanentElements();
        this.activateNewBody();
        this.assignNewBody();
        this.replacePlaceholderElementsWithClonedPermanentElements(placeholders);
    };
    SnapshotRenderer.prototype.shouldRender = function () {
        return this.newSnapshot.isVisitable() && this.trackedElementsAreIdentical();
    };
    SnapshotRenderer.prototype.trackedElementsAreIdentical = function () {
        return this.currentHeadDetails.getTrackedElementSignature() == this.newHeadDetails.getTrackedElementSignature();
    };
    SnapshotRenderer.prototype.copyNewHeadStylesheetElements = function () {
        for (var _i = 0, _a = this.getNewHeadStylesheetElements(); _i < _a.length; _i++) {
            var element = _a[_i];
            document.head.appendChild(element);
        }
    };
    SnapshotRenderer.prototype.copyNewHeadScriptElements = function () {
        for (var _i = 0, _a = this.getNewHeadScriptElements(); _i < _a.length; _i++) {
            var element = _a[_i];
            document.head.appendChild(this.createScriptElement(element));
        }
    };
    SnapshotRenderer.prototype.removeCurrentHeadProvisionalElements = function () {
        for (var _i = 0, _a = this.getCurrentHeadProvisionalElements(); _i < _a.length; _i++) {
            var element = _a[_i];
            document.head.removeChild(element);
        }
    };
    SnapshotRenderer.prototype.copyNewHeadProvisionalElements = function () {
        for (var _i = 0, _a = this.getNewHeadProvisionalElements(); _i < _a.length; _i++) {
            var element = _a[_i];
            document.head.appendChild(element);
        }
    };
    SnapshotRenderer.prototype.relocateCurrentBodyPermanentElements = function () {
        var _this = this;
        return this.getCurrentBodyPermanentElements().reduce(function (placeholders, permanentElement) {
            var newElement = _this.newSnapshot.getPermanentElementById(permanentElement.id);
            if (newElement) {
                var placeholder = createPlaceholderForPermanentElement(permanentElement);
                replaceElementWithElement(permanentElement, placeholder.element);
                replaceElementWithElement(newElement, permanentElement);
                return snapshot_renderer_spreadArrays(placeholders, [placeholder]);
            }
            else {
                return placeholders;
            }
        }, []);
    };
    SnapshotRenderer.prototype.replacePlaceholderElementsWithClonedPermanentElements = function (placeholders) {
        for (var _i = 0, placeholders_1 = placeholders; _i < placeholders_1.length; _i++) {
            var _a = placeholders_1[_i], element = _a.element, permanentElement = _a.permanentElement;
            var clonedElement = permanentElement.cloneNode(true);
            replaceElementWithElement(element, clonedElement);
        }
    };
    SnapshotRenderer.prototype.activateNewBody = function () {
        document.adoptNode(this.newBody);
        this.activateNewBodyScriptElements();
    };
    SnapshotRenderer.prototype.activateNewBodyScriptElements = function () {
        for (var _i = 0, _a = this.getNewBodyScriptElements(); _i < _a.length; _i++) {
            var inertScriptElement = _a[_i];
            var activatedScriptElement = this.createScriptElement(inertScriptElement);
            replaceElementWithElement(inertScriptElement, activatedScriptElement);
        }
    };
    SnapshotRenderer.prototype.assignNewBody = function () {
        if (document.body) {
            replaceElementWithElement(document.body, this.newBody);
        }
        else {
            document.documentElement.appendChild(this.newBody);
        }
    };
    SnapshotRenderer.prototype.focusFirstAutofocusableElement = function () {
        var element = this.newSnapshot.findFirstAutofocusableElement();
        if (elementIsFocusable(element)) {
            element.focus();
        }
    };
    SnapshotRenderer.prototype.getNewHeadStylesheetElements = function () {
        return this.newHeadDetails.getStylesheetElementsNotInDetails(this.currentHeadDetails);
    };
    SnapshotRenderer.prototype.getNewHeadScriptElements = function () {
        return this.newHeadDetails.getScriptElementsNotInDetails(this.currentHeadDetails);
    };
    SnapshotRenderer.prototype.getCurrentHeadProvisionalElements = function () {
        return this.currentHeadDetails.getProvisionalElements();
    };
    SnapshotRenderer.prototype.getNewHeadProvisionalElements = function () {
        return this.newHeadDetails.getProvisionalElements();
    };
    SnapshotRenderer.prototype.getCurrentBodyPermanentElements = function () {
        return this.currentSnapshot.getPermanentElementsPresentInSnapshot(this.newSnapshot);
    };
    SnapshotRenderer.prototype.getNewBodyScriptElements = function () {
        return array(this.newBody.querySelectorAll("script"));
    };
    return SnapshotRenderer;
}(Renderer));

function createPlaceholderForPermanentElement(permanentElement) {
    var element = document.createElement("meta");
    element.setAttribute("name", "turbolinks-permanent-placeholder");
    element.setAttribute("content", permanentElement.id);
    return { element: element, permanentElement: permanentElement };
}
function replaceElementWithElement(fromElement, toElement) {
    var parentElement = fromElement.parentElement;
    if (parentElement) {
        return parentElement.replaceChild(toElement, fromElement);
    }
}
function elementIsFocusable(element) {
    return element && typeof element.focus == "function";
}
//# sourceMappingURL=snapshot_renderer.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/view.js






var view_View = /** @class */ (function () {
    function View(delegate) {
        this.htmlElement = document.documentElement;
        this.snapshotCache = new SnapshotCache(10);
        this.delegate = delegate;
    }
    View.prototype.getRootLocation = function () {
        return this.getSnapshot().getRootLocation();
    };
    View.prototype.getElementForAnchor = function (anchor) {
        return this.getSnapshot().getElementForAnchor(anchor);
    };
    View.prototype.getSnapshot = function () {
        return snapshot_Snapshot.fromHTMLElement(this.htmlElement);
    };
    View.prototype.clearSnapshotCache = function () {
        this.snapshotCache.clear();
    };
    View.prototype.shouldCacheSnapshot = function () {
        return this.getSnapshot().isCacheable();
    };
    View.prototype.cacheSnapshot = function () {
        var _this = this;
        if (this.shouldCacheSnapshot()) {
            this.delegate.viewWillCacheSnapshot();
            var snapshot_1 = this.getSnapshot();
            var location_1 = this.lastRenderedLocation || Location.currentLocation;
            defer(function () { return _this.snapshotCache.put(location_1, snapshot_1.clone()); });
        }
    };
    View.prototype.getCachedSnapshotForLocation = function (location) {
        return this.snapshotCache.get(location);
    };
    View.prototype.render = function (_a, callback) {
        var snapshot = _a.snapshot, error = _a.error, isPreview = _a.isPreview;
        this.markAsPreview(isPreview);
        if (snapshot) {
            this.renderSnapshot(snapshot, isPreview, callback);
        }
        else {
            this.renderError(error, callback);
        }
    };
    // Scrolling
    View.prototype.scrollToAnchor = function (anchor) {
        var element = this.getElementForAnchor(anchor);
        if (element) {
            this.scrollToElement(element);
        }
        else {
            this.scrollToPosition({ x: 0, y: 0 });
        }
    };
    View.prototype.scrollToElement = function (element) {
        element.scrollIntoView();
    };
    View.prototype.scrollToPosition = function (_a) {
        var x = _a.x, y = _a.y;
        window.scrollTo(x, y);
    };
    // Private
    View.prototype.markAsPreview = function (isPreview) {
        if (isPreview) {
            this.htmlElement.setAttribute("data-turbolinks-preview", "");
        }
        else {
            this.htmlElement.removeAttribute("data-turbolinks-preview");
        }
    };
    View.prototype.renderSnapshot = function (snapshot, isPreview, callback) {
        snapshot_renderer_SnapshotRenderer.render(this.delegate, callback, this.getSnapshot(), snapshot, isPreview || false);
    };
    View.prototype.renderError = function (error, callback) {
        error_renderer_ErrorRenderer.render(this.delegate, callback, error || "");
    };
    return View;
}());

//# sourceMappingURL=view.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/controller.js











var controller_Controller = /** @class */ (function () {
    function Controller() {
        this.navigator = new navigator_Navigator(this);
        this.adapter = new browser_adapter_BrowserAdapter(this);
        this.history = new history_History(this);
        this.view = new view_View(this);
        this.pageObserver = new PageObserver(this);
        this.linkClickObserver = new link_click_observer_LinkClickObserver(this);
        this.formSubmitObserver = new FormSubmitObserver(this);
        this.scrollObserver = new ScrollObserver(this);
        this.enabled = true;
        this.progressBarDelay = 500;
        this.started = false;
    }
    Controller.prototype.start = function () {
        if (Controller.supported && !this.started) {
            this.pageObserver.start();
            this.linkClickObserver.start();
            this.formSubmitObserver.start();
            this.scrollObserver.start();
            this.history.start();
            this.started = true;
            this.enabled = true;
        }
    };
    Controller.prototype.disable = function () {
        this.enabled = false;
    };
    Controller.prototype.stop = function () {
        if (this.started) {
            this.pageObserver.stop();
            this.linkClickObserver.stop();
            this.formSubmitObserver.stop();
            this.scrollObserver.stop();
            this.history.stop();
            this.started = false;
        }
    };
    Controller.prototype.clearCache = function () {
        this.view.clearSnapshotCache();
    };
    Controller.prototype.visit = function (location, options) {
        if (options === void 0) { options = {}; }
        this.navigator.proposeVisit(Location.wrap(location), options);
    };
    Controller.prototype.startVisitToLocation = function (location, restorationIdentifier, options) {
        this.navigator.startVisit(Location.wrap(location), restorationIdentifier, options);
    };
    Controller.prototype.setProgressBarDelay = function (delay) {
        this.progressBarDelay = delay;
    };
    Object.defineProperty(Controller.prototype, "location", {
        get: function () {
            return this.history.location;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(Controller.prototype, "restorationIdentifier", {
        get: function () {
            return this.history.restorationIdentifier;
        },
        enumerable: true,
        configurable: true
    });
    // History delegate
    Controller.prototype.historyPoppedToLocationWithRestorationIdentifier = function (location, restorationIdentifier) {
        if (this.enabled) {
            this.navigator.proposeVisit(location, { action: "restore", historyChanged: true });
        }
        else {
            this.adapter.pageInvalidated();
        }
    };
    // Scroll observer delegate
    Controller.prototype.scrollPositionChanged = function (position) {
        this.history.updateRestorationData({ scrollPosition: position });
    };
    // Link click observer delegate
    Controller.prototype.willFollowLinkToLocation = function (link, location) {
        return this.linkIsVisitable(link)
            && this.locationIsVisitable(location)
            && this.applicationAllowsFollowingLinkToLocation(link, location);
    };
    Controller.prototype.followedLinkToLocation = function (link, location) {
        var action = this.getActionForLink(link);
        this.visit(location, { action: action });
    };
    // Navigator delegate
    Controller.prototype.allowsVisitingLocation = function (location) {
        return this.applicationAllowsVisitingLocation(location);
    };
    Controller.prototype.visitProposedToLocation = function (location, options) {
        this.adapter.visitProposedToLocation(location, options);
    };
    Controller.prototype.visitStarted = function (visit) {
        this.notifyApplicationAfterVisitingLocation(visit.location);
    };
    Controller.prototype.visitCompleted = function (visit) {
        this.notifyApplicationAfterPageLoad(visit.getTimingMetrics());
    };
    // Form submit observer delegate
    Controller.prototype.willSubmitForm = function (form) {
        return true;
    };
    Controller.prototype.formSubmitted = function (form) {
        this.navigator.submitForm(form);
    };
    // Page observer delegate
    Controller.prototype.pageBecameInteractive = function () {
        this.view.lastRenderedLocation = this.location;
        this.notifyApplicationAfterPageLoad();
    };
    Controller.prototype.pageLoaded = function () {
    };
    Controller.prototype.pageInvalidated = function () {
        this.adapter.pageInvalidated();
    };
    // View delegate
    Controller.prototype.viewWillRender = function (newBody) {
        this.notifyApplicationBeforeRender(newBody);
    };
    Controller.prototype.viewRendered = function () {
        this.view.lastRenderedLocation = this.history.location;
        this.notifyApplicationAfterRender();
    };
    Controller.prototype.viewInvalidated = function () {
        this.pageObserver.invalidate();
    };
    Controller.prototype.viewWillCacheSnapshot = function () {
        this.notifyApplicationBeforeCachingSnapshot();
    };
    // Application events
    Controller.prototype.applicationAllowsFollowingLinkToLocation = function (link, location) {
        var event = this.notifyApplicationAfterClickingLinkToLocation(link, location);
        return !event.defaultPrevented;
    };
    Controller.prototype.applicationAllowsVisitingLocation = function (location) {
        var event = this.notifyApplicationBeforeVisitingLocation(location);
        return !event.defaultPrevented;
    };
    Controller.prototype.notifyApplicationAfterClickingLinkToLocation = function (link, location) {
        return dispatch("turbolinks:click", { target: link, data: { url: location.absoluteURL }, cancelable: true });
    };
    Controller.prototype.notifyApplicationBeforeVisitingLocation = function (location) {
        return dispatch("turbolinks:before-visit", { data: { url: location.absoluteURL }, cancelable: true });
    };
    Controller.prototype.notifyApplicationAfterVisitingLocation = function (location) {
        return dispatch("turbolinks:visit", { data: { url: location.absoluteURL } });
    };
    Controller.prototype.notifyApplicationBeforeCachingSnapshot = function () {
        return dispatch("turbolinks:before-cache");
    };
    Controller.prototype.notifyApplicationBeforeRender = function (newBody) {
        return dispatch("turbolinks:before-render", { data: { newBody: newBody } });
    };
    Controller.prototype.notifyApplicationAfterRender = function () {
        return dispatch("turbolinks:render");
    };
    Controller.prototype.notifyApplicationAfterPageLoad = function (timing) {
        if (timing === void 0) { timing = {}; }
        return dispatch("turbolinks:load", { data: { url: this.location.absoluteURL, timing: timing } });
    };
    // Private
    Controller.prototype.getActionForLink = function (link) {
        var action = link.getAttribute("data-turbolinks-action");
        return isAction(action) ? action : "advance";
    };
    Controller.prototype.linkIsVisitable = function (link) {
        var container = closest(link, "[data-turbolinks]");
        if (container) {
            return container.getAttribute("data-turbolinks") != "false";
        }
        else {
            return true;
        }
    };
    Controller.prototype.locationIsVisitable = function (location) {
        return location.isPrefixedBy(this.view.getRootLocation()) && location.isHTML();
    };
    Controller.supported = !!(window.history.pushState &&
        window.requestAnimationFrame &&
        window.addEventListener);
    return Controller;
}());

//# sourceMappingURL=controller.js.map
// CONCATENATED MODULE: ./node_modules/turbolinks/dist/index.js







var dist_controller = new controller_Controller;
var supported = controller_Controller.supported;
function dist_visit(location, options) {
    dist_controller.visit(location, options);
}
function clearCache() {
    dist_controller.clearCache();
}
function setProgressBarDelay(delay) {
    dist_controller.setProgressBarDelay(delay);
}
function start() {
    dist_controller.start();
}
//# sourceMappingURL=index.js.map

/***/ }),

/***/ 4:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";

// EXPORTS
__webpack_require__.d(__webpack_exports__, "a", function() { return /* reexport */ request_Request; });

// UNUSED EXPORTS: Response

// CONCATENATED MODULE: ./app/javascript/lib/http/response.js
class _Response{constructor(response){this.response=response;}get statusCode(){return this.response.status;}get ok(){return this.response.ok;}get unauthenticated(){return this.statusCode==401;}get authenticationURL(){return this.response.headers.get("WWW-Authenticate");}get contentType(){const contentType=this.response.headers.get("Content-Type")||"";return contentType.replace(/;.*$/,"");}get headers(){return this.response.headers;}get html(){if(this.contentType.match(/^(application|text)\/(html|xhtml\+xml)$/)){return this.response.text();}else{return Promise.reject("Expected an HTML response but got \""+this.contentType+"\" instead");}}get json(){if(this.contentType.match(/^application\/json/)){return this.response.json();}else{return Promise.reject("Expected a JSON response but got \""+this.contentType+"\" instead");}}get text(){return this.response.text();}}
// EXTERNAL MODULE: ./app/javascript/lib/cookie.js
var cookie = __webpack_require__(2);

// CONCATENATED MODULE: ./app/javascript/lib/http/request.js
window.breakAllFetchRequestsForTests=false;class request_Request{constructor(method,url,options={}){this.method=method;this.url=window.breakAllFetchRequestsForTests?"about:blank":url;this.options=options;}async perform(){const response=new _Response(await fetch(this.url,this.fetchOptions));if(response.unauthenticated&&response.authenticationURL){return Promise.reject(window.location.href=response.authenticationURL);}else{return response;}}get fetchOptions(){return{method:this.method,headers:this.headers,body:this.body,signal:this.signal,credentials:"same-origin",redirect:"follow"};}get headers(){return compact({"X-Requested-With":"XMLHttpRequest","X-CSRF-Token":this.csrfToken,"Content-Type":this.contentType,"Accept":this.accept});}get csrfToken(){var _document$head$queryS;const csrfParam=(_document$head$queryS=document.head.querySelector("meta[name=csrf-param]"))==null?void 0:_document$head$queryS.content;return csrfParam?Object(cookie["a" /* getCookie */])(csrfParam):undefined;}get contentType(){if(this.options.contentType){return this.options.contentType;}else if(this.body==null||this.body instanceof FormData){return undefined;}else if(this.body instanceof File){return this.body.type;}else{return"application/octet-stream";}}get accept(){switch(this.responseKind){case"html":return"text/html, application/xhtml+xml";case"json":return"application/json";default:return"*/*";}}get body(){return this.options.body;}get responseKind(){return this.options.responseKind||"html";}get signal(){return this.options.signal;}}function compact(object){const result={};for(const key in object){const value=object[key];if(value!==undefined){result[key]=value;}}return result;}
// CONCATENATED MODULE: ./app/javascript/lib/http/index.js


/***/ }),

/***/ 6:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";

// EXPORTS
__webpack_require__.d(__webpack_exports__, "a", function() { return /* binding */ processPageUpdates; });

// NAMESPACE OBJECT: ./app/javascript/lib/page-updater/commands.js
var commands_namespaceObject = {};
__webpack_require__.r(commands_namespaceObject);
__webpack_require__.d(commands_namespaceObject, "append", function() { return append; });
__webpack_require__.d(commands_namespaceObject, "prepend", function() { return prepend; });
__webpack_require__.d(commands_namespaceObject, "replace", function() { return replace; });
__webpack_require__.d(commands_namespaceObject, "update", function() { return update; });
__webpack_require__.d(commands_namespaceObject, "remove", function() { return remove; });

// CONCATENATED MODULE: ./app/javascript/lib/page-updater/commands.js
function append(element,content){element.append(content);}function prepend(element,content){element.prepend(content);}function replace(element,content){element.replaceWith(content);}function update(element,content){element.innerHTML="";element.append(content);}function remove(element){element.remove();}
// CONCATENATED MODULE: ./app/javascript/lib/page-updater/util.js
function createFragment(html){return document.createRange().createContextualFragment(html);}function findElement(id){return document.getElementById(id);}
// CONCATENATED MODULE: ./app/javascript/lib/page-updater/update.js
class update_Update{constructor(type,id,content){this.type=type;this.id=id;this.content=content;}perform(){const command=commands_namespaceObject[this.type];if(!command)return;const element=findElement(this.id);if(!element)return;command(element,this.content);}}
// CONCATENATED MODULE: ./app/javascript/lib/page-updater/templates.js
const ATTRIBUTE="data-page-update";const SELECTOR="template["+ATTRIBUTE+"]";function extractUpdates(html){return Array.from(extractTemplates(html),createUpdate);}function extractTemplates(html){return createFragment(html).querySelectorAll(SELECTOR);}function createUpdate(template){const[type,id]=template.getAttribute(ATTRIBUTE).split("#");return new update_Update(type,id,template.content);}
// CONCATENATED MODULE: ./app/javascript/lib/page-updater/index.js
const updates=[];let animationFrame;function processPageUpdates(html){extractUpdates(html).forEach(queue);}function queue(update){updates.push(update);scheduleRender();}function scheduleRender(){if(animationFrame)return;animationFrame=requestAnimationFrame(()=>{animationFrame=null;while(updates.length)updates.shift().perform();});}

/***/ }),

/***/ 7:
/***/ (function(module, exports, __webpack_require__) {

(function(global, factory) {
   true ? factory(exports) : undefined;
})(this, function(exports) {
  "use strict";
  var adapters = {
    logger: self.console,
    WebSocket: self.WebSocket
  };
  var logger = {
    log: function log() {
      if (this.enabled) {
        var _adapters$logger;
        for (var _len = arguments.length, messages = Array(_len), _key = 0; _key < _len; _key++) {
          messages[_key] = arguments[_key];
        }
        messages.push(Date.now());
        (_adapters$logger = adapters.logger).log.apply(_adapters$logger, [ "[ActionCable]" ].concat(messages));
      }
    }
  };
  var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function(obj) {
    return typeof obj;
  } : function(obj) {
    return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj;
  };
  var classCallCheck = function(instance, Constructor) {
    if (!(instance instanceof Constructor)) {
      throw new TypeError("Cannot call a class as a function");
    }
  };
  var createClass = function() {
    function defineProperties(target, props) {
      for (var i = 0; i < props.length; i++) {
        var descriptor = props[i];
        descriptor.enumerable = descriptor.enumerable || false;
        descriptor.configurable = true;
        if ("value" in descriptor) descriptor.writable = true;
        Object.defineProperty(target, descriptor.key, descriptor);
      }
    }
    return function(Constructor, protoProps, staticProps) {
      if (protoProps) defineProperties(Constructor.prototype, protoProps);
      if (staticProps) defineProperties(Constructor, staticProps);
      return Constructor;
    };
  }();
  var now = function now() {
    return new Date().getTime();
  };
  var secondsSince = function secondsSince(time) {
    return (now() - time) / 1e3;
  };
  var clamp = function clamp(number, min, max) {
    return Math.max(min, Math.min(max, number));
  };
  var ConnectionMonitor = function() {
    function ConnectionMonitor(connection) {
      classCallCheck(this, ConnectionMonitor);
      this.visibilityDidChange = this.visibilityDidChange.bind(this);
      this.connection = connection;
      this.reconnectAttempts = 0;
    }
    ConnectionMonitor.prototype.start = function start() {
      if (!this.isRunning()) {
        this.startedAt = now();
        delete this.stoppedAt;
        this.startPolling();
        addEventListener("visibilitychange", this.visibilityDidChange);
        logger.log("ConnectionMonitor started. pollInterval = " + this.getPollInterval() + " ms");
      }
    };
    ConnectionMonitor.prototype.stop = function stop() {
      if (this.isRunning()) {
        this.stoppedAt = now();
        this.stopPolling();
        removeEventListener("visibilitychange", this.visibilityDidChange);
        logger.log("ConnectionMonitor stopped");
      }
    };
    ConnectionMonitor.prototype.isRunning = function isRunning() {
      return this.startedAt && !this.stoppedAt;
    };
    ConnectionMonitor.prototype.recordPing = function recordPing() {
      this.pingedAt = now();
    };
    ConnectionMonitor.prototype.recordConnect = function recordConnect() {
      this.reconnectAttempts = 0;
      this.recordPing();
      delete this.disconnectedAt;
      logger.log("ConnectionMonitor recorded connect");
    };
    ConnectionMonitor.prototype.recordDisconnect = function recordDisconnect() {
      this.disconnectedAt = now();
      logger.log("ConnectionMonitor recorded disconnect");
    };
    ConnectionMonitor.prototype.startPolling = function startPolling() {
      this.stopPolling();
      this.poll();
    };
    ConnectionMonitor.prototype.stopPolling = function stopPolling() {
      clearTimeout(this.pollTimeout);
    };
    ConnectionMonitor.prototype.poll = function poll() {
      var _this = this;
      this.pollTimeout = setTimeout(function() {
        _this.reconnectIfStale();
        _this.poll();
      }, this.getPollInterval());
    };
    ConnectionMonitor.prototype.getPollInterval = function getPollInterval() {
      var _constructor$pollInte = this.constructor.pollInterval, min = _constructor$pollInte.min, max = _constructor$pollInte.max, multiplier = _constructor$pollInte.multiplier;
      var interval = multiplier * Math.log(this.reconnectAttempts + 1);
      return Math.round(clamp(interval, min, max) * 1e3);
    };
    ConnectionMonitor.prototype.reconnectIfStale = function reconnectIfStale() {
      if (this.connectionIsStale()) {
        logger.log("ConnectionMonitor detected stale connection. reconnectAttempts = " + this.reconnectAttempts + ", pollInterval = " + this.getPollInterval() + " ms, time disconnected = " + secondsSince(this.disconnectedAt) + " s, stale threshold = " + this.constructor.staleThreshold + " s");
        this.reconnectAttempts++;
        if (this.disconnectedRecently()) {
          logger.log("ConnectionMonitor skipping reopening recent disconnect");
        } else {
          logger.log("ConnectionMonitor reopening");
          this.connection.reopen();
        }
      }
    };
    ConnectionMonitor.prototype.connectionIsStale = function connectionIsStale() {
      return secondsSince(this.pingedAt ? this.pingedAt : this.startedAt) > this.constructor.staleThreshold;
    };
    ConnectionMonitor.prototype.disconnectedRecently = function disconnectedRecently() {
      return this.disconnectedAt && secondsSince(this.disconnectedAt) < this.constructor.staleThreshold;
    };
    ConnectionMonitor.prototype.visibilityDidChange = function visibilityDidChange() {
      var _this2 = this;
      if (document.visibilityState === "visible") {
        setTimeout(function() {
          if (_this2.connectionIsStale() || !_this2.connection.isOpen()) {
            logger.log("ConnectionMonitor reopening stale connection on visibilitychange. visbilityState = " + document.visibilityState);
            _this2.connection.reopen();
          }
        }, 200);
      }
    };
    return ConnectionMonitor;
  }();
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
  var message_types = INTERNAL.message_types, protocols = INTERNAL.protocols;
  var supportedProtocols = protocols.slice(0, protocols.length - 1);
  var indexOf = [].indexOf;
  var Connection = function() {
    function Connection(consumer) {
      classCallCheck(this, Connection);
      this.open = this.open.bind(this);
      this.consumer = consumer;
      this.subscriptions = this.consumer.subscriptions;
      this.monitor = new ConnectionMonitor(this);
      this.disconnected = true;
    }
    Connection.prototype.send = function send(data) {
      if (this.isOpen()) {
        this.webSocket.send(JSON.stringify(data));
        return true;
      } else {
        return false;
      }
    };
    Connection.prototype.open = function open() {
      if (this.isActive()) {
        logger.log("Attempted to open WebSocket, but existing socket is " + this.getState());
        return false;
      } else {
        logger.log("Opening WebSocket, current state is " + this.getState() + ", subprotocols: " + protocols);
        if (this.webSocket) {
          this.uninstallEventHandlers();
        }
        this.webSocket = new adapters.WebSocket(this.consumer.url, protocols);
        this.installEventHandlers();
        this.monitor.start();
        return true;
      }
    };
    Connection.prototype.close = function close() {
      var _ref = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {
        allowReconnect: true
      }, allowReconnect = _ref.allowReconnect;
      if (!allowReconnect) {
        this.monitor.stop();
      }
      if (this.isActive()) {
        return this.webSocket.close();
      }
    };
    Connection.prototype.reopen = function reopen() {
      logger.log("Reopening WebSocket, current state is " + this.getState());
      if (this.isActive()) {
        try {
          return this.close();
        } catch (error) {
          logger.log("Failed to reopen WebSocket", error);
        } finally {
          logger.log("Reopening WebSocket in " + this.constructor.reopenDelay + "ms");
          setTimeout(this.open, this.constructor.reopenDelay);
        }
      } else {
        return this.open();
      }
    };
    Connection.prototype.getProtocol = function getProtocol() {
      if (this.webSocket) {
        return this.webSocket.protocol;
      }
    };
    Connection.prototype.isOpen = function isOpen() {
      return this.isState("open");
    };
    Connection.prototype.isActive = function isActive() {
      return this.isState("open", "connecting");
    };
    Connection.prototype.isProtocolSupported = function isProtocolSupported() {
      return indexOf.call(supportedProtocols, this.getProtocol()) >= 0;
    };
    Connection.prototype.isState = function isState() {
      for (var _len = arguments.length, states = Array(_len), _key = 0; _key < _len; _key++) {
        states[_key] = arguments[_key];
      }
      return indexOf.call(states, this.getState()) >= 0;
    };
    Connection.prototype.getState = function getState() {
      if (this.webSocket) {
        for (var state in adapters.WebSocket) {
          if (adapters.WebSocket[state] === this.webSocket.readyState) {
            return state.toLowerCase();
          }
        }
      }
      return null;
    };
    Connection.prototype.installEventHandlers = function installEventHandlers() {
      for (var eventName in this.events) {
        var handler = this.events[eventName].bind(this);
        this.webSocket["on" + eventName] = handler;
      }
    };
    Connection.prototype.uninstallEventHandlers = function uninstallEventHandlers() {
      for (var eventName in this.events) {
        this.webSocket["on" + eventName] = function() {};
      }
    };
    return Connection;
  }();
  Connection.reopenDelay = 500;
  Connection.prototype.events = {
    message: function message(event) {
      if (!this.isProtocolSupported()) {
        return;
      }
      var _JSON$parse = JSON.parse(event.data), identifier = _JSON$parse.identifier, message = _JSON$parse.message, reason = _JSON$parse.reason, reconnect = _JSON$parse.reconnect, type = _JSON$parse.type;
      switch (type) {
       case message_types.welcome:
        this.monitor.recordConnect();
        return this.subscriptions.reload();

       case message_types.disconnect:
        logger.log("Disconnecting. Reason: " + reason);
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
    open: function open() {
      logger.log("WebSocket onopen event, using '" + this.getProtocol() + "' subprotocol");
      this.disconnected = false;
      if (!this.isProtocolSupported()) {
        logger.log("Protocol is unsupported. Stopping monitor and disconnecting.");
        return this.close({
          allowReconnect: false
        });
      }
    },
    close: function close(event) {
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
    error: function error() {
      logger.log("WebSocket onerror event");
    }
  };
  var extend = function extend(object, properties) {
    if (properties != null) {
      for (var key in properties) {
        var value = properties[key];
        object[key] = value;
      }
    }
    return object;
  };
  var Subscription = function() {
    function Subscription(consumer) {
      var params = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};
      var mixin = arguments[2];
      classCallCheck(this, Subscription);
      this.consumer = consumer;
      this.identifier = JSON.stringify(params);
      extend(this, mixin);
    }
    Subscription.prototype.perform = function perform(action) {
      var data = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};
      data.action = action;
      return this.send(data);
    };
    Subscription.prototype.send = function send(data) {
      return this.consumer.send({
        command: "message",
        identifier: this.identifier,
        data: JSON.stringify(data)
      });
    };
    Subscription.prototype.unsubscribe = function unsubscribe() {
      return this.consumer.subscriptions.remove(this);
    };
    return Subscription;
  }();
  var Subscriptions = function() {
    function Subscriptions(consumer) {
      classCallCheck(this, Subscriptions);
      this.consumer = consumer;
      this.subscriptions = [];
    }
    Subscriptions.prototype.create = function create(channelName, mixin) {
      var channel = channelName;
      var params = (typeof channel === "undefined" ? "undefined" : _typeof(channel)) === "object" ? channel : {
        channel: channel
      };
      var subscription = new Subscription(this.consumer, params, mixin);
      return this.add(subscription);
    };
    Subscriptions.prototype.add = function add(subscription) {
      this.subscriptions.push(subscription);
      this.consumer.ensureActiveConnection();
      this.notify(subscription, "initialized");
      this.sendCommand(subscription, "subscribe");
      return subscription;
    };
    Subscriptions.prototype.remove = function remove(subscription) {
      this.forget(subscription);
      if (!this.findAll(subscription.identifier).length) {
        this.sendCommand(subscription, "unsubscribe");
      }
      return subscription;
    };
    Subscriptions.prototype.reject = function reject(identifier) {
      var _this = this;
      return this.findAll(identifier).map(function(subscription) {
        _this.forget(subscription);
        _this.notify(subscription, "rejected");
        return subscription;
      });
    };
    Subscriptions.prototype.forget = function forget(subscription) {
      this.subscriptions = this.subscriptions.filter(function(s) {
        return s !== subscription;
      });
      return subscription;
    };
    Subscriptions.prototype.findAll = function findAll(identifier) {
      return this.subscriptions.filter(function(s) {
        return s.identifier === identifier;
      });
    };
    Subscriptions.prototype.reload = function reload() {
      var _this2 = this;
      return this.subscriptions.map(function(subscription) {
        return _this2.sendCommand(subscription, "subscribe");
      });
    };
    Subscriptions.prototype.notifyAll = function notifyAll(callbackName) {
      var _this3 = this;
      for (var _len = arguments.length, args = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
        args[_key - 1] = arguments[_key];
      }
      return this.subscriptions.map(function(subscription) {
        return _this3.notify.apply(_this3, [ subscription, callbackName ].concat(args));
      });
    };
    Subscriptions.prototype.notify = function notify(subscription, callbackName) {
      for (var _len2 = arguments.length, args = Array(_len2 > 2 ? _len2 - 2 : 0), _key2 = 2; _key2 < _len2; _key2++) {
        args[_key2 - 2] = arguments[_key2];
      }
      var subscriptions = void 0;
      if (typeof subscription === "string") {
        subscriptions = this.findAll(subscription);
      } else {
        subscriptions = [ subscription ];
      }
      return subscriptions.map(function(subscription) {
        return typeof subscription[callbackName] === "function" ? subscription[callbackName].apply(subscription, args) : undefined;
      });
    };
    Subscriptions.prototype.sendCommand = function sendCommand(subscription, command) {
      var identifier = subscription.identifier;
      return this.consumer.send({
        command: command,
        identifier: identifier
      });
    };
    return Subscriptions;
  }();
  var Consumer = function() {
    function Consumer(url) {
      classCallCheck(this, Consumer);
      this._url = url;
      this.subscriptions = new Subscriptions(this);
      this.connection = new Connection(this);
    }
    Consumer.prototype.send = function send(data) {
      return this.connection.send(data);
    };
    Consumer.prototype.connect = function connect() {
      return this.connection.open();
    };
    Consumer.prototype.disconnect = function disconnect() {
      return this.connection.close({
        allowReconnect: false
      });
    };
    Consumer.prototype.ensureActiveConnection = function ensureActiveConnection() {
      if (!this.connection.isActive()) {
        return this.connection.open();
      }
    };
    createClass(Consumer, [ {
      key: "url",
      get: function get$$1() {
        return createWebSocketURL(this._url);
      }
    } ]);
    return Consumer;
  }();
  function createWebSocketURL(url) {
    if (typeof url === "function") {
      url = url();
    }
    if (url && !/^wss?:/i.test(url)) {
      var a = document.createElement("a");
      a.href = url;
      a.href = a.href;
      a.protocol = a.protocol.replace("http", "ws");
      return a.href;
    } else {
      return url;
    }
  }
  function createConsumer() {
    var url = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : getConfig("url") || INTERNAL.default_mount_path;
    return new Consumer(url);
  }
  function getConfig(name) {
    var element = document.head.querySelector("meta[name='action-cable-" + name + "']");
    if (element) {
      return element.getAttribute("content");
    }
  }
  exports.Connection = Connection;
  exports.ConnectionMonitor = ConnectionMonitor;
  exports.Consumer = Consumer;
  exports.INTERNAL = INTERNAL;
  exports.Subscription = Subscription;
  exports.Subscriptions = Subscriptions;
  exports.adapters = adapters;
  exports.createWebSocketURL = createWebSocketURL;
  exports.logger = logger;
  exports.createConsumer = createConsumer;
  exports.getConfig = getConfig;
  Object.defineProperty(exports, "__esModule", {
    value: true
  });
});


/***/ }),

/***/ 92:
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var elements_turbo_frame__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(11);
/* harmony import */ var initializers_page_updates__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(10);
window.Turbolinks=__webpack_require__(3);Turbolinks.start();

/***/ })

/******/ });
