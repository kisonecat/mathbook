<?xml version='1.0'?> <!-- As XML file -->

<!--********************************************************************
Copyright 2018 Robert A. Beezer

This file is part of PreTeXt.

PreTeXt is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 or version 3 of the
License (at your option).

PreTeXt is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PreTeXt.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************-->

<!-- http://pimpmyxslt.com/articles/entity-tricks-part2/ -->
<!DOCTYPE xsl:stylesheet [
    <!ENTITY % entities SYSTEM "entities.ent">
    %entities;
]>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:exsl="http://exslt.org/common"    
    extension-element-prefixes="exsl"    
>

<xsl:import href="./pretext-text.xsl" />

<!-- override on command-line with xsltproc's "-stringparam" option -->
<xsl:param name="chunk.level" select="2"/>
<xsl:param name="base-url" select="'http://abstract.ups.edu/aata/'"/>
<!-- <xsl:param name="base-url" select="'http://set-base-url/'"/> -->

<!-- Necessary variables, typically set in  mathbook-html.xsl -->
<!-- $chunk-level will eventually be referenced by templates  -->
<!-- for the containing filename used to construct a URL      -->
<!-- Since we are describing HTML output, we want filenames   -->
<!-- describing those files                                   -->
<xsl:variable name="file-extension" select="'.html'"/>
<xsl:variable name="chunk-level">
    <xsl:value-of select="$chunk.level"/>
</xsl:variable>

<xsl:template match="/">
  <exsl:document href="service-worker.js" method="html" indent="yes" encoding="UTF-8" doctype-system="about:legacy-compat">  
    <xsl:apply-templates select="$document-root"/>
  </exsl:document>
</xsl:template>

<xsl:template match="&STRUCTURAL;">
    <xsl:apply-templates select="." mode="full-url"/>
    <xsl:apply-templates select="&STRUCTURAL;"/>
</xsl:template>

<xsl:template match="&STRUCTURAL;" mode="full-url">
  <xsl:text>'</xsl:text>
  <xsl:apply-templates select="." mode="containing-filename"/>
  <xsl:text>',</xsl:text>  
</xsl:template>

<xsl:template match="&STRUCTURAL;">
    <xsl:apply-templates select="." mode="full-url"/>
    <xsl:apply-templates select="&STRUCTURAL;"/>
</xsl:template>

<xsl:template match="/">

<exsl:document href="service-worker.js" method="text" indent="yes" encoding="UTF-8" doctype-system="about:legacy-compat">
  <xsl:text>
const PRECACHE = 'precache-v1';
const RUNTIME = 'runtime';

const PRECACHE_URLS = [
  </xsl:text>

  <xsl:apply-templates select="$document-root"/>
  
  <xsl:text>
];
    
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(PRECACHE)
      .then(cache => cache.addAll(PRECACHE_URLS))
      .then(self.skipWaiting())
  );
});

self.addEventListener('activate', event => {
  const currentCaches = [PRECACHE, RUNTIME];
  
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return cacheNames.filter(cacheName => !currentCaches.includes(cacheName));
    }).then(cachesToDelete => {
      return Promise.all(cachesToDelete.map(cacheToDelete => {
        return caches.delete(cacheToDelete);
      }));
    }).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', event => {
  // Skip cross-origin requests, like those for Google Analytics.
  if (event.request.url.startsWith(self.location.origin)) {
    event.respondWith(
      caches.match(event.request).then(cachedResponse => {
        if (cachedResponse) {
          return cachedResponse;
        }

        return caches.open(RUNTIME).then(cache => {
          return fetch(event.request).then(response => {
            // Put a copy of the response in the runtime cache.
            return cache.put(event.request, response.clone()).then(() => {
              return response;
            });
          });
        });
      })
    );
  }
});
      </xsl:text>
</exsl:document>
</xsl:template>


</xsl:stylesheet>
