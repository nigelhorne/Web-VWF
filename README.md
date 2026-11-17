# NAME

Web::VWF - Versatile Web Framework - easily build a website to support different languages and client platforms

# VERSION

Version 0.002.0

# DESCRIPTION

Web::VWF is [VWF](https://github.com/nigelhorne/vwf), the Versatile Web
Framework, packaged as a CPAN distribution.  It is an MVC framework for
building responsive websites that adapt to the client's language, to the kind
of client (web, mobile, robot, search engine or AI crawler) and to whichever
database back end the site uses.

This module is the distribution's front door: it holds the version number, this
overview, and the one thing a site builds by hand - ["new"](#new), the site's
configuration and the directory the server keeps it in.  Working the framework
does these modules:

- [Web::VWF::Display](https://metacpan.org/pod/Web%3A%3AVWF%3A%3ADisplay)

    The page renderer.  Given the configuration, the browser's language and the
    kind of client it is, it finds the right template for a page and renders it.
    A site subclasses it for each of its pages.

- [Web::VWF::Config](https://metacpan.org/pod/Web%3A%3AVWF%3A%3AConfig)

    Reads the site's XML configuration.

- [Web::VWF::Allow](https://metacpan.org/pod/Web%3A%3AVWF%3A%3AAllow)

    Access control and rate limiting.

- [Web::VWF::Blacklist](https://metacpan.org/pod/Web%3A%3AVWF%3A%3ABlacklist)

    The country blacklist, shared by the page script, [Web::VWF::Allow](https://metacpan.org/pod/Web%3A%3AVWF%3A%3AAllow) and
    [Web::VWF::Display](https://metacpan.org/pod/Web%3A%3AVWF%3A%3ADisplay).

- [Web::VWF::Utils](https://metacpan.org/pod/Web%3A%3AVWF%3A%3AUtils)

    Cache initialisation and the Haversine distance calculation.

- [Web::VWF::CAPTCHA](https://metacpan.org/pod/Web%3A%3AVWF%3A%3ACAPTCHA)

    reCAPTCHA integration and the bypass that follows a solved challenge.

- [Web::VWF::Mail](https://metacpan.org/pod/Web%3A%3AVWF%3A%3AMail)

    Sends mail through sendmail(1), signed with DKIM when the site has a key.

- [Web::VWF::Throttle](https://metacpan.org/pod/Web%3A%3AVWF%3A%3AThrottle)

    A YAML backend for Data::Throttler that also works on Windows.

- [Web::VWF::Data::&lt;source>](https://metacpan.org/pod/Web%3A%3AVWF%3A%3AData%3A%3A%3Csource%3E)

    The data access layer: CSV, XML and SQLite, through Database::Abstraction.

`example/` in this distribution is a small working site to copy and adapt:
`example/cgi-bin/page.fcgi` is the page script, `example/conf/default` is the
configuration (placeholders only - put real keys in your own copy), and
`example/templates/` holds the templates.  Run it from the command line with
`CONFIG_DIR=$(pwd)/example/conf root_dir=$(pwd)/example perl -Ilib example/cgi-bin/page.fcgi page=index`.

A site's templates sit under a path built from the page's class name,
so the file to change when the page module is `Web::VWF::Display::index` is
`templates/web/Web/VWF/Display/index.tmpl` - see [Web::VWF::Display](https://metacpan.org/pod/Web%3A%3AVWF%3A%3ADisplay)
for the rest of the search order.

A site that used to carry a renamed copy of VWF of its own deletes that copy,
installs this distribution, renames `VWF::` to `Web::VWF::` in its own code,
and moves its templates from `.../VWF/Display/` to `.../Web/VWF/Display/`.

# SUBROUTINES/METHODS

## new

The configuration of a site, and the directory the server keeps it in.

**Parameters:**

- `directory` - The directory the server keeps the configuration of the
sites it serves in: one directory per site, named after the site, so that a site
reached as `example.com` is configured from `/usr/lib/vwf/example.com`.  Any
other root can be named here - `/etc/vwf`, `/usr/local/etc/vwf` - and the
default is `/usr/lib/vwf`.  Optional.
- `info`, `logger`, `config_directory`, `config_file`, `config` -
handed to [Web::VWF::Config](https://metacpan.org/pod/Web%3A%3AVWF%3A%3AConfig), which describes them.

### API SPECIFICATION

#### INPUT

        {
                directory => { type => 'string', optional => 1 },
                info => { type => 'object', optional => 1 },
                logger => { type => 'object', optional => 1 },
                config_directory => { type => 'string', optional => 1 },
                config_file => { type => 'string', optional => 1 },
                config => { type => 'hashref', optional => 1 },
        }

`new` croaks with `directory must be a string` when `directory` is a reference.

#### OUTPUT

        { type => 'object', isa => 'Web::VWF' }

## \_directory

Internal: not part of the public interface.  The directory the server keeps this site's configuration in: what `new()` was
given, or `/usr/lib/vwf`.  [Web::VWF::Config](https://metacpan.org/pod/Web%3A%3AVWF%3A%3AConfig) adds the site's own name to it.

### API SPECIFICATION

#### INPUT

        {}

#### OUTPUT

        { type => 'string' }

## \_config

Internal: not part of the public interface.  The site's configuration, read once and kept: a site that has no `conf/` of its
own beside `cgi-bin/` is configured from the server's directory for it, and
[Web::VWF::Config](https://metacpan.org/pod/Web%3A%3AVWF%3A%3AConfig) describes the rest of the search.

### API SPECIFICATION

#### INPUT

        {}

#### OUTPUT

        { type => 'object', isa => 'Web::VWF::Config' }

# AUTHOR

Nigel Horne, `<njh at nigelhorne.com>`

# LICENCE AND COPYRIGHT

Copyright 2010-2026 Nigel Horne.

Usage is subject to the GPL2 licence terms.
If you use it,
please let me know.
