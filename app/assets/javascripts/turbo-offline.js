/*!
Turbo 8.0.20
Copyright © 2025 37signals LLC
 */
class Rule {
  constructor({handler: handler, match: match = /.*/} = {}) {
    this.handler = handler;
    this.match = match;
  }
  matches(request) {
    if (typeof this.match === "function") return this.match(request);
    const regexes = Array.isArray(this.match) ? this.match : [ this.match ];
    return regexes.some((regex => regex.test(request.url)));
  }
  async handle(event) {
    const {response: response, afterHandlePromise: afterHandlePromise} = await this.handler.handle(event.request);
    event.waitUntil(afterHandlePromise);
    return response;
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

const DATABASE_NAME = "turbo-offline-database";

const DATABASE_VERSION = 1;

const STORE_NAME = "cache-registry";

class CacheRegistryDatabase {
  get(cacheName, key) {
    const getOp = store => this.#requestToPromise(store.get(key));
    return this.#performOperation(STORE_NAME, getOp, "readonly");
  }
  has(cacheName, key) {
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
  getTimestamp(cacheName, key) {
    return this.get(cacheName, key).then((result => result?.timestamp));
  }
  getOlderThan(cacheName, timestamp) {
    const getOlderThanOp = store => {
      const index = store.index("cacheNameAndTimestamp");
      const range = IDBKeyRange.bound([ cacheName, 0 ], [ cacheName, timestamp ], false, true);
      const cursorRequest = index.openCursor(range);
      return this.#cursorRequestToPromise(cursorRequest);
    };
    return this.#performOperation(STORE_NAME, getOlderThanOp, "readonly");
  }
  delete(cacheName, key) {
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
  #cursorRequestToPromise(request) {
    return new Promise(((resolve, reject) => {
      const results = [];
      request.onsuccess = event => {
        const cursor = event.target.result;
        if (cursor) {
          results.push(cursor.value);
          cursor.continue();
        } else {
          resolve(results);
        }
      };
      request.onerror = () => reject(request.error);
    }));
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
    return this.database.get(this.cacheName, key);
  }
  has(key) {
    return this.database.has(this.cacheName, key);
  }
  put(key, value = {}) {
    return this.database.put(this.cacheName, key, value);
  }
  getTimestamp(key) {
    return this.database.getTimestamp(this.cacheName, key);
  }
  getOlderThan(timestamp) {
    return this.database.getOlderThan(this.cacheName, timestamp);
  }
  delete(key) {
    return this.database.delete(this.cacheName, key);
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
    return this.options.maxAge && this.options.maxAge > 0;
  }
  async deleteEntries() {
    if (this.options.maxAge) {
      await this.deleteEntriesByAge();
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
    const cache = await caches.open(this.cacheName);
    const deletePromises = expiredEntries.map((async entry => {
      const cacheDeletePromise = cache.delete(entry.key);
      const registryDeletePromise = this.cacheRegistry.delete(entry.key);
      return Promise.all([ cacheDeletePromise, registryDeletePromise ]);
    }));
    await Promise.all(deletePromises);
    console.debug(`Successfully trimmed ${expiredEntries.length} entries from cache "${this.cacheName}"`);
  }
}

class Handler {
  constructor({cacheName: cacheName, networkTimeout: networkTimeout, maxAge: maxAge}) {
    this.cacheName = cacheName;
    this.networkTimeout = networkTimeout;
    this.cacheRegistry = new CacheRegistry(cacheName);
    this.cacheTrimmer = new CacheTrimmer(cacheName, this.cacheRegistry, {
      maxAge: maxAge
    });
  }
  async handle(request) {}
  async fetchFromCache(request) {
    const cacheKeyUrl = buildCacheKey(request);
    let response = await caches.match(cacheKeyUrl, {
      ignoreVary: true
    });
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
      referrer: referrer
    });
  }
  async saveToCache(request, response) {
    if (response && this.canCacheResponse(response)) {
      const cacheKeyUrl = buildCacheKey(request, response);
      const cache = await caches.open(this.cacheName);
      const cachePromise = cache.put(cacheKeyUrl, response);
      const registryPromise = this.cacheRegistry.put(cacheKeyUrl);
      const trimPromise = this.cacheTrimmer.trim();
      return Promise.all([ cachePromise, registryPromise, trimPromise ]);
    }
  }
  canCacheResponse(response) {
    return response.status === 200 || response.status === 0;
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
    } catch (error) {
      console.warn(`${error} fetching from network ${request.url} with timeout`);
    }
    if (timeoutId) clearTimeout(timeoutId);
    if (!response && cacheAttemptedOnTimeout) {
      try {
        response = await networkPromise;
      } catch (error) {
        console.warn(`${error} fetching from network ${request.url}`);
      }
    } else if (!response) {
      response = await this.fetchFromCache(request);
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

export { ServiceWorker, addRule, index as handlers, serviceWorker, start };
