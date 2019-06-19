PreTeXt with service workers
============================

With the 2 new .xsl files here, you can do this:

```
git clone https://github.com/kisonecat/mathbook.git
cd mathbook
git checkout serviceworker
cd examples/minimal
xsltproc ../../xsl/mathbook-html-serviceworker.xsl minimal.xml
xsltproc ../../xsl/pretext-serviceworker.xsl minimal.xml
python2.7 -m SimpleHTTPServer 7000
```

The first xsltproc produces the usual .html but with a bit more `<script>`
in the `<head>`.

The second xsltproc produces `service-worker.js` which arranges to
cache the `.html` files.

Then if you go to http://localhost:7000/minimal.html you will see the
usual content, but that first load will cache assets, even assets being
loaded from other domains (and in particular, will cache mathjax once it
gets loaded once).  If you then kill the HTTP server --- simulating an
offline browser --- a lot of the page will still work.  You can even
navigate to pages you hadn't previously visited!  This is good even for
people with only slightly flakey internet.

There's a number of caveats here, e.g., once things get cached, how
does cache invalidation happen?  What happens when the book is
updated?  Exactly what assets get cached in the first load?  Figures?
What about knowls?

PreTeXt
=======

An uncomplicated XML vocabulary for authors of research articles, textbooks, and monographs.

GPL License.

*Be sure* to checkout the dev branch, master is currently a fiction.

Quickstart instructions at project website:  [pretextbook.org](https://pretextbook.org)

Help and development discussions:
* Support forum/mailing-list: [pretext-support](https://groups.google.com/forum/#!forum/pretext-support)
* Announcements only, low-volume: [pretext-announce](https://groups.google.com/forum/#!forum/pretext-announce)


PreTeXt is guided by the following principles:
----------------------------------------------
1. PreTeXt is a markup language that captures the structure of
textbooks and research papers.
2. PreTeXt is human-readable and human-writable.
3. PreTeXt documents serve as a single source which can be
easily converted to multiple other formats, current and future.
4. PreTeXt respects the good design practices which have been
developed over the past centuries.
5. PreTeXt makes it easy for authors to implement features which
are both common and reasonable.
6. PreTeXt supports online documents which make use of the full
capabilities of the Web.
7. PreTeXt output is styled by selecting from a list of available
templates, relieving the author of the burden involved
in micromanaging the output format.
8. PreTeXt is free: the software is available at no cost, with an
open license. The use of PreTeXt does not impose any constraints
on documents prepared with the system.
9. PreTeXt is not a closed system: documents can be converted to
LaTeX and then developed using standard LaTeX tools.
10. PreTeXt recognizes that scholarly documents involve the
interaction of authors, publishers, scholars, instructors,
students, and readers, with each group having its own needs
and goals.
11. PreTeXt recognizes the inherent value in producing material
that is accessible to everyone.
