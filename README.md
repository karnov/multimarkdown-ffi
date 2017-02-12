Ruby Multimarkdown 5
====================

[![Build Status](https://travis-ci.org/jakobjanot/multimarkdown-ffi.png?branch=master)](https://travis-ci.org/jakobjanot/multimarkdown-ffi)

An FFI extension library around the
[Fletcher Penney's MultiMarkdown](http://github.com/fletcher/MultiMarkdown-5/)
C-library. It is based upon the multimarkdown4 ruby wrapper
[rmultimarkdown](https://github.com/tillsc/multi_markdown) by [Till Schulte-Coerne](https://github.com/tillsc), which was inspired by
[rpeg-markdown](https://github.com/rtomayko/rpeg-markdown/) and
[rpeg-multimarkdown](https://github.com/djungelvral/rpeg-multimarkdown) libraries by
[Ryan Tomayko](https://github.com/rtomayko) and  [Oliver "djungelvral"](https://github.com/djungelvral).

Synopsis
--------

    >> require 'multimarkdown-ffi'

    >> Multimarkdown.new('Hello, world.').to_html
    #=> "<p>Hello, world.</p>"

    >> Multimarkdown.new('_Hello World!_', :smart, :filter_html).to_html
    #=> "<p><em>Hello World!</em></p>"

    >> Multimarkdown.new('_Hello World!_').to_latex
    #=> "\emph{Hello World!}"

	>> doc = Multimarkdown.new("Title: Some document  \n\nSome text in the document")

    >> doc.metadata
    #=> {"title" => "Some document"}

    >> doc.metadata("Title")
    #=> "Some document"

See [MultiMarkdown documentation](http://fletcher.github.io/MultiMarkdown-5/).

Installation
------------

The library has been tested with later versions of Ruby MRI and JRuby

Install from [Rubygems](http://rubygems.org/gems/multimarkdown-ffi):

    $ [sudo] gem install multimarkdown-ffi

Or add to your projects Gemfile [Bundler](http://bundler.io):

    gem 'multimarkdown-ffi'

Development
-----------

    $ git clone git://github.com/jakobjanot/multimarkdown-ffi.git
    $ cd multimarkdown-ffi
    $ bundle install
    $ bundle exec rake

Changes
-------

**Beware**: The versioning scheme isn't based upon
[Semantic Versioning](http://semver.org), but inherits from the underlying C library.
Only the last number is used to indicate changes in the Ruby wrapper itself.

COPYING
-------

MultiMarkdown-5, multimarkdown-ffi are both licensed under the GPL and the MIT License.
See [LICENSE](LICENCSE) for more information.