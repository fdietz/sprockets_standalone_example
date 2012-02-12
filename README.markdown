Sprockets Standalone Example
============================

Example of using Sprockets standalone to compress and package assets. Following Rails 3.1 conventions as far as possible.

Prerequisites
-------------

You need Ruby. I've tested with Ruby-1.9.2-p290

Additionally install Bundler with:

    $ gem install bundler

Getting Started
---------------

Clone the git repository and execute:

    $ bundle install

To package the example content execute:

    $ bundle exec rake assets:precompile

To start the Sinatra example app:

    $ bundle exec rake assets:rackup

Background
----------

All example content can be found in assets/ directory. All generated output will reside in build/ directory.

Following Rails 3.1 conventions all assets have an MD5 hashsum filename generated.

Additionally there's a manifest.yml created which contains a mapping of each assets path to it's versioned path.

The sinatra app loads all assets with an asset helper method which supports passing :debug => true options. This will include all individual files instead of a single compiled file.

Contact
-------

Author: Frederik Dietz

Email: fdietz@gmail.com
