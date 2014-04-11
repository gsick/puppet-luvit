[![Build Status](https://travis-ci.org/gsick/puppet-luvit.svg?branch=0.0.1)](https://travis-ci.org/gsick/puppet-luvit)
[![Coverage Status](https://coveralls.io/repos/gsick/puppet-luvit/badge.png?branch=0.0.1)](https://coveralls.io/r/gsick/puppet-luvit?branch=0.0.1)
(100% with rspec-puppet)

puppet-luvit
============

Puppet module for installing Luvit and Lum.<br />
[Luvit](http://luvit.io)<br />

## Table of Contents

* [Status](#status)
* [Usage](#usage)
* [Parameters](#parameters)
* [Installation](#installation)
    * [puppet](#puppet)
    * [librarian-puppet](#librarian-puppet)
* [Tests](#tests)
    * [Unit tests](#unit-tests)
    * [Smoke tests](#smoke-tests)
* [Authors](#authors)
* [Contributing](#contributing)
* [Licence](#licence)

## Status

0.0.1 released.

## Usage

In your puppet file

```puppet
node default {
  include luvit
}
```

In your hieradata file

```yaml
---
luvit::version: 0.7.0
```

## Parameters

* `luvit::version`: version of Luvit (required)
* `luvit::tmp`: tmp directory used by install, default `/tmp`

## Installation

### puppet

```bash
$ puppet module install gsick-luvit
```

### librarian-puppet

Add in your Puppetfile

```text
mod 'gsick/luvit'
```

and run

```bash
$ librarian-puppet update
```

## Tests

### Unit tests

```bash
$ bundle install
$ rake test
```

### Smoke tests

```bash
$ puppet apply tests/init.pp --noop
```

## Authors

Gamaliel Sick

## Contributing

  * Fork it
  * Create your feature branch `git checkout -b my-new-feature`
  * Commit your changes `git commit -am 'Add some feature'`
  * Push to the branch `git push origin my-new-feature`
  * Create new Pull Request

## Licence

```
The MIT License (MIT)

Copyright (c) 2014 gsick

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
