(function(global, factory) {
  typeof exports === "object" && typeof module !== "undefined" ? factory(exports) : typeof define === "function" && define.amd ? define([ "exports" ], factory) : (global = typeof globalThis !== "undefined" ? globalThis : global || self, 
  factory(global.TurboOffline = {}));
})(this, (function(exports) {
  "use strict";
  /*!
  Turbo 8.0.23
  Copyright © 2026 37signals LLC
   */  class Rule {
    constructor({handler: handler, match: match = /.*/, except: except} = {}) {
      this.handler = handler;
      this.match = match;
      this.except = except;
    }
    matches(request) {
      return this.#matchesCondition(request, this.match) && !this.#matchesCondition(request, this.except);
    }
    #matchesCondition(request, condition) {
      if (!condition) return false;
      if (typeof condition === "function") return condition(request);
      const regexes = Array.isArray(condition) ? condition : [ condition ];
      return regexes.some((regex => regex.test(request.url)));
    }
    async handle(event) {
      const {response: response, afterHandlePromise: afterHandlePromise} = await this.handler.handle(event.request);
      event.waitUntil(afterHandlePromise);
      return response;
    }
  }
  const DATABASE_NAME = "turbo-offline-database";
  const DATABASE_VERSION = 1;
  const STORE_NAME = "cache-registry";
  function deleteCacheRegistries() {
    return new Promise(((resolve, reject) => {
      const request = indexedDB.deleteDatabase(DATABASE_NAME);
      request.onsuccess = () => resolve();
      request.onerror = () => reject(request.error);
    })).then((() => {
      cacheRegistryDatabase = null;
    }));
  }
  class CacheRegistryDatabase {
    get(key) {
      const getOp = store => this.#requestToPromise(store.get(key));
      return this.#performOperation(STORE_NAME, getOp, "readonly");
    }
    has(key) {
      const countOp = store => this.#requestToPromise(store.count(key));
      return this.#performOperation(STORE_NAME, countOp, "readonly").then((result => result === 1));
    }
    put(cacheName, key, value) {
      const putOp = store => {
        const item = {
          key: key,
          cacheName: cacheName,
          timestamp: Date.now(),
          ...value
        };
        store.put(item);
        return this.#requestToPromise(store.transaction);
      };
      return this.#performOperation(STORE_NAME, putOp, "readwrite");
    }
    getTimestamp(key) {
      return this.get(key).then((result => result?.timestamp));
    }
    getOlderThan(cacheName, timestamp) {
      const getOlderThanOp = store => {
        const index = store.index("cacheNameAndTimestamp");
        const cursorRequest = index.openCursor(this.#getTimestampRange(cacheName, timestamp));
        return this.#cursorRequestToPromise(cursorRequest);
      };
      return this.#performOperation(STORE_NAME, getOlderThanOp, "readonly");
    }
    getEntryCount(cacheName) {
      const countOp = store => {
        const index = store.index("cacheNameAndTimestamp");
        const range = this.#getTimestampRange(cacheName);
        return this.#requestToPromise(index.count(range));
      };
      return this.#performOperation(STORE_NAME, countOp, "readonly");
    }
    getOldestEntries(cacheName, limit) {
      const getOldestOp = store => {
        const index = store.index("cacheNameAndTimestamp");
        const cursorRequest = index.openCursor(this.#getTimestampRange(cacheName));
        return this.#cursorRequestToPromise(cursorRequest, limit);
      };
      return this.#performOperation(STORE_NAME, getOldestOp, "readonly");
    }
    delete(key) {
      const deleteOp = store => this.#requestToPromise(store.delete(key));
      return this.#performOperation(STORE_NAME, deleteOp, "readwrite");
    }
    #performOperation(storeName, operation, mode) {
      return this.#openDatabase().then((database => {
        const transaction = database.transaction(storeName, mode);
        const store = transaction.objectStore(storeName);
        return operation(store);
      }));
    }
    #openDatabase() {
      const request = indexedDB.open(DATABASE_NAME, DATABASE_VERSION);
      request.onupgradeneeded = () => {
        const cacheMetadataStore = request.result.createObjectStore(STORE_NAME, {
          keyPath: "key"
        });
        cacheMetadataStore.createIndex("cacheNameAndTimestamp", [ "cacheName", "timestamp" ]);
      };
      return this.#requestToPromise(request);
    }
    #requestToPromise(request) {
      return new Promise(((resolve, reject) => {
        request.oncomplete = request.onsuccess = () => resolve(request.result);
        request.onabort = request.onerror = () => reject(request.error);
      }));
    }
    #cursorRequestToPromise(request, limit = Infinity) {
      return new Promise(((resolve, reject) => {
        const results = [];
        request.onsuccess = event => {
          const cursor = event.target.result;
          if (cursor && results.length < limit) {
            results.push(cursor.value);
            cursor.continue();
          } else {
            resolve(results);
          }
        };
        request.onerror = () => reject(request.error);
      }));
    }
    #getTimestampRange(cacheName, upperBound = Infinity) {
      return IDBKeyRange.bound([ cacheName, 0 ], [ cacheName, upperBound ], false, true);
    }
  }
  let cacheRegistryDatabase = null;
  function getDatabase() {
    if (!cacheRegistryDatabase) {
      cacheRegistryDatabase = new CacheRegistryDatabase;
    }
    return cacheRegistryDatabase;
  }
  class CacheRegistry {
    constructor(cacheName) {
      this.cacheName = cacheName;
      this.database = getDatabase();
    }
    get(key) {
      return this.database.get(key);
    }
    has(key) {
      return this.database.has(key);
    }
    put(key, value = {}) {
      return this.database.put(this.cacheName, key, value);
    }
    getTimestamp(key) {
      return this.database.getTimestamp(key);
    }
    getOlderThan(timestamp) {
      return this.database.getOlderThan(this.cacheName, timestamp);
    }
    getEntryCount() {
      return this.database.getEntryCount(this.cacheName);
    }
    getOldestEntries(limit) {
      return this.database.getOldestEntries(this.cacheName, limit);
    }
    delete(key) {
      return this.database.delete(key);
    }
  }
  class ServiceWorker {
    #started=false;
    #rules=[];
    addRule(rule) {
      this.#rules.push(new Rule(rule));
    }
    start() {
      this.#warnIfNoRulesConfigured();
      if (!this.#started) {
        self.addEventListener("install", this.installed);
        self.addEventListener("message", this.messageReceived);
        self.addEventListener("fetch", this.fetch);
        this.#started = true;
      }
    }
    installed=event => {
      console.log("Service worker installed");
    };
    messageReceived=event => {
      if (this[event.data.action]) {
        const actionCall = this[event.data.action](event.data.params);
        event.waitUntil(actionCall);
      }
    };
    fetch=event => {
      if (this.#canInterceptRequest(event.request)) {
        const rule = this.#findMatchingRule(event.request);
        if (!rule) return;
        const response = rule.handle(event);
        event.respondWith(response);
      }
    };
    async preloadResources({urls: urls}) {
      for (const url of urls) {
        const request = new Request(url);
        const rule = this.#findMatchingRule(request);
        if (!rule) continue;
        try {
          const response = await fetch(url);
          await rule.handler.saveToCache(request, response);
        } catch (error) {
          console.debug(`Preloading failed for ${url}:`, error);
        }
      }
    }
    async clearCache() {
      const cacheNames = await caches.keys();
      await Promise.all(cacheNames.map((name => caches.delete(name))));
      await deleteCacheRegistries();
    }
    #warnIfNoRulesConfigured() {
      if (this.#rules.length === 0) {
        console.warn("No rules configured for service worker. No requests will be intercepted.");
      }
    }
    #canInterceptRequest(request) {
      const url = new URL(request.url, location.href);
      return request.method === "GET" && url.protocol.startsWith("http");
    }
    #findMatchingRule(request) {
      return this.#rules.find((rule => rule.matches(request)));
    }
  }
  class CacheTrimmer {
    #isRunning=false;
    constructor(cacheName, cacheRegistry, options = {}) {
      this.cacheName = cacheName;
      this.cacheRegistry = cacheRegistry;
      this.options = options;
    }
    async trim() {
      if (this.#isRunning) {
        return;
      }
      if (!this.#shouldTrim()) {
        return;
      }
      this.#isRunning = true;
      try {
        await this.deleteEntries();
      } finally {
        this.#isRunning = false;
      }
    }
    #shouldTrim() {
      const {maxAge: maxAge, maxEntries: maxEntries} = this.options;
      return maxAge && maxAge > 0 || maxEntries && maxEntries > 0;
    }
    async deleteEntries() {
      if (this.options.maxAge) {
        await this.deleteEntriesByAge();
      }
      if (this.options.maxEntries) {
        await this.deleteEntriesByCount();
      }
    }
    async deleteEntriesByAge() {
      const maxAgeMs = this.options.maxAge * 1e3;
      const cutoffTimestamp = Date.now() - maxAgeMs;
      const expiredEntries = await this.cacheRegistry.getOlderThan(cutoffTimestamp);
      if (expiredEntries.length === 0) {
        return;
      }
      console.debug(`Trimming ${expiredEntries.length} expired entries from cache "${this.cacheName}"`);
      await this.#deleteEntryList(expiredEntries);
      console.debug(`Successfully trimmed ${expiredEntries.length} entries from cache "${this.cacheName}"`);
    }
    async deleteEntriesByCount() {
      const currentCount = await this.cacheRegistry.getEntryCount();
      const excess = currentCount - this.options.maxEntries;
      if (excess <= 0) {
        return;
      }
      const entriesToDelete = await this.cacheRegistry.getOldestEntries(excess);
      if (entriesToDelete.length === 0) {
        return;
      }
      console.debug(`Trimming ${entriesToDelete.length} entries (count limit) from cache "${this.cacheName}"`);
      await this.#deleteEntryList(entriesToDelete);
      console.debug(`Successfully trimmed ${entriesToDelete.length} entries from cache "${this.cacheName}"`);
    }
    async #deleteEntryList(entries) {
      const cache = await caches.open(this.cacheName);
      const deletePromises = entries.map((async entry => {
        const cacheDeletePromise = cache.delete(entry.key);
        const registryDeletePromise = this.cacheRegistry.delete(entry.key);
        return Promise.all([ cacheDeletePromise, registryDeletePromise ]);
      }));
      await Promise.all(deletePromises);
    }
  }
  async function buildPartialResponse(request, response) {
    if (response.status === 206) {
      return response;
    }
    const rangeHeader = request.headers.get("range");
    if (!rangeHeader) {
      return response;
    }
    if (response.type === "opaque" || response.type === "opaqueredirect") {
      return response;
    }
    try {
      const {start: start, end: end} = parseRangeHeader(rangeHeader);
      const blob = await response.blob();
      const {effectiveStart: effectiveStart, effectiveEnd: effectiveEnd} = calculateEffectiveBoundaries(blob, start, end);
      const slicedBlob = blob.slice(effectiveStart, effectiveEnd);
      const slicedSize = slicedBlob.size;
      const totalSize = blob.size;
      const partialResponse = new Response(slicedBlob, {
        status: 206,
        statusText: "Partial Content",
        headers: response.headers
      });
      partialResponse.headers.set("Content-Length", slicedSize);
      partialResponse.headers.set("Content-Range", `bytes ${effectiveStart}-${effectiveEnd - 1}/${totalSize}`);
      return partialResponse;
    } catch (error) {
      console.warn("Range request error:", error.message);
      return new Response("", {
        status: 416,
        statusText: "Range Not Satisfiable"
      });
    }
  }
  function parseRangeHeader(rangeHeader) {
    const normalized = rangeHeader.trim().toLowerCase();
    if (!normalized.startsWith("bytes=")) {
      throw new Error("Range unit must be 'bytes'");
    }
    if (normalized.includes(",")) {
      throw new Error("Multiple ranges are not supported");
    }
    const rangeValue = normalized.slice(6);
    const match = rangeValue.match(/^(\d*)-(\d*)$/);
    if (!match) {
      throw new Error("Invalid range format");
    }
    const [, startStr, endStr] = match;
    const start = startStr ? parseInt(startStr, 10) : undefined;
    const end = endStr ? parseInt(endStr, 10) : undefined;
    if (start === undefined && end === undefined) {
      throw new Error("Invalid range: both start and end are missing");
    }
    return {
      start: start,
      end: end
    };
  }
  function calculateEffectiveBoundaries(blob, start, end) {
    const size = blob.size;
    let effectiveStart;
    let effectiveEnd;
    if (start !== undefined && end !== undefined) {
      effectiveStart = start;
      effectiveEnd = end + 1;
    } else if (start !== undefined) {
      effectiveStart = start;
      effectiveEnd = size;
    } else {
      effectiveStart = size - end;
      effectiveEnd = size;
    }
    if (effectiveStart < 0 || effectiveStart >= size || effectiveEnd > size) {
      throw new Error("Range not satisfiable");
    }
    return {
      effectiveStart: effectiveStart,
      effectiveEnd: effectiveEnd
    };
  }
  class Handler {
    constructor({cacheName: cacheName, networkTimeout: networkTimeout, maxAge: maxAge, maxEntries: maxEntries, maxEntrySize: maxEntrySize, fetchOptions: fetchOptions}) {
      this.cacheName = cacheName;
      this.networkTimeout = networkTimeout;
      this.fetchOptions = fetchOptions || {};
      this.maxEntrySize = maxEntrySize;
      this.cacheRegistry = new CacheRegistry(cacheName);
      this.cacheTrimmer = new CacheTrimmer(cacheName, this.cacheRegistry, {
        maxAge: maxAge,
        maxEntries: maxEntries
      });
    }
    async handle(request) {}
    async fetchFromCache(request) {
      const cacheKeyUrl = buildCacheKey(request);
      let response = await caches.match(cacheKeyUrl, {
        ignoreVary: true
      });
      if (response !== undefined && request.headers.has("range")) {
        response = await buildPartialResponse(request, response);
      }
      if (response !== undefined && request.redirect === "manual" && response.redirected) {
        response = new Response(response.body, {
          headers: response.headers,
          status: response.status,
          url: response.url
        });
      }
      return response;
    }
    async fetchFromNetwork(request) {
      const referrer = request.referrer;
      return await fetch(request, {
        referrer: referrer,
        ...this.fetchOptions
      });
    }
    async saveToCache(request, response) {
      if (response && this.canCacheResponse(response)) {
        if (this.maxEntrySize && this.maxEntrySize > 0) {
          const size = await this.#getResponseSize(response);
          if (size === null) {
            console.warn(`Cannot determine size for opaque response to "${request.url}". Consider using fetchOptions: { mode: "cors" } if the server supports CORS. maxEntrySize check skipped.`);
          } else if (size > this.maxEntrySize) {
            console.debug(`Skipping cache for "${request.url}": response size ${size} exceeds maxEntrySize ${this.maxEntrySize}`);
            return;
          }
        }
        const cacheKeyUrl = buildCacheKey(request, response);
        const cache = await caches.open(this.cacheName);
        const cachePromise = cache.put(cacheKeyUrl, response);
        const registryPromise = this.cacheRegistry.put(cacheKeyUrl);
        const trimPromise = this.cacheTrimmer.trim();
        return Promise.all([ cachePromise, registryPromise, trimPromise ]).catch((async error => {
          if (this.#isQuotaExceededError(error)) {
            await this.#clearAllStorage();
          }
          throw error;
        }));
      }
    }
    async #getResponseSize(response) {
      if (response.type === "opaque" || response.status === 0) {
        return null;
      }
      const contentLength = response.headers.get("Content-Length");
      if (contentLength) {
        return parseInt(contentLength, 10);
      }
      const clone = response.clone();
      const blob = await clone.blob();
      return blob.size;
    }
    canCacheResponse(response) {
      return response.status === 200 || response.status === 0;
    }
    #isQuotaExceededError(error) {
      return error?.name === "QuotaExceededError" || error?.inner && error.inner.name === "QuotaExceededError";
    }
    async #clearAllStorage() {
      const cacheNames = await caches.keys();
      for (const cacheName of cacheNames) {
        await caches.delete(cacheName);
      }
      await deleteCacheRegistries();
    }
  }
  function buildCacheKey(requestOrUrl, response) {
    const request = new Request(requestOrUrl);
    const url = response && isHtmlResponse(response) ? response.url : request.url;
    return new URL(url, location.href).href;
  }
  function isHtmlResponse(response) {
    return response.headers.get("content-type")?.includes("text/html");
  }
  class CacheFirst extends Handler {
    async handle(request) {
      let response = await this.fetchFromCache(request);
      let afterHandlePromise;
      if (response) {
        afterHandlePromise = this.cacheTrimmer.trim();
        return {
          response: response,
          afterHandlePromise: afterHandlePromise
        };
      }
      console.debug(`Cache miss for ${request.url}`);
      try {
        response = await this.fetchFromNetwork(request);
      } catch (error) {
        console.warn(`${error} fetching from network ${request.url}`);
      }
      if (response) {
        afterHandlePromise = this.saveToCache(request, response.clone());
      }
      return {
        response: response,
        afterHandlePromise: afterHandlePromise
      };
    }
    canCacheResponse(response) {
      return response.status === 200;
    }
  }
  class NetworkFirst extends Handler {
    async handle(request) {
      let response;
      let afterHandlePromise;
      let timeoutId;
      let cacheAttemptedOnTimeout = false;
      let responseFromNetwork = false;
      const networkPromise = this.fetchFromNetwork(request);
      const promises = [ networkPromise ];
      if (this.networkTimeout) {
        const timeoutPromise = new Promise((resolve => {
          timeoutId = setTimeout((async () => {
            console.debug(`Network timeout after ${this.networkTimeout}s for ${request.url}, trying the cache...`);
            const cachedResponse = await this.fetchFromCache(request);
            cacheAttemptedOnTimeout = true;
            resolve(cachedResponse);
          }), this.networkTimeout * 1e3);
        }));
        promises.push(timeoutPromise);
      }
      try {
        response = await Promise.race(promises);
        if (!cacheAttemptedOnTimeout) {
          responseFromNetwork = true;
        }
      } catch (error) {
        console.warn(`${error} fetching from network ${request.url} with timeout`);
      }
      if (timeoutId) clearTimeout(timeoutId);
      if (!response && cacheAttemptedOnTimeout) {
        try {
          response = await networkPromise;
          responseFromNetwork = true;
        } catch (error) {
          console.warn(`${error} fetching from network ${request.url}`);
        }
      } else if (!response) {
        response = await this.fetchFromCache(request);
      }
      if (response && responseFromNetwork) {
        afterHandlePromise = this.saveToCache(request, response.clone());
      } else {
        afterHandlePromise = Promise.resolve();
      }
      return {
        response: response,
        afterHandlePromise: afterHandlePromise
      };
    }
  }
  class StaleWhileRevalidate extends Handler {
    async handle(request) {
      let response = await this.fetchFromCache(request);
      let afterHandlePromise;
      if (response) {
        afterHandlePromise = this.revalidateCache(request);
        return {
          response: response,
          afterHandlePromise: afterHandlePromise
        };
      }
      console.debug(`Cache miss for ${request.url}`);
      try {
        response = await this.fetchFromNetwork(request);
      } catch (error) {
        console.warn(`${error} fetching from network ${request.url}`);
      }
      if (response) {
        afterHandlePromise = this.saveToCache(request, response.clone());
      } else {
        afterHandlePromise = Promise.resolve();
      }
      return {
        response: response,
        afterHandlePromise: afterHandlePromise
      };
    }
    async revalidateCache(request) {
      try {
        const response = await this.fetchFromNetwork(request);
        if (response) {
          await this.saveToCache(request, response.clone());
        }
      } catch (error) {
        console.debug(`${error} revalidating cache for ${request.url}`);
      }
    }
  }
  const cacheFirst = config => new CacheFirst(config);
  const networkFirst = config => new NetworkFirst(config);
  const staleWhileRevalidate = config => new StaleWhileRevalidate(config);
  var index = Object.freeze({
    __proto__: null,
    cacheFirst: cacheFirst,
    networkFirst: networkFirst,
    staleWhileRevalidate: staleWhileRevalidate
  });
  const serviceWorker = new ServiceWorker;
  function addRule(rule) {
    serviceWorker.addRule(rule);
  }
  function start() {
    serviceWorker.start();
  }
  exports.ServiceWorker = ServiceWorker;
  exports.addRule = addRule;
  exports.handlers = index;
  exports.serviceWorker = serviceWorker;
  exports.start = start;
  Object.defineProperty(exports, "__esModule", {
    value: true
  });
}));
