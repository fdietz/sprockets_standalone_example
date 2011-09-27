Sprockets Standalone Example
============================

Example of using Sprockets standalone to compress and package assets. Following Rails 3.1 conventions as far as possible.

Prerequisites
-------------

You need Ruby. I've tested with Ruby 1.8.7-p352 and Ruby-1.9.2-p290

Additionally install Bundler with:

    $ gem install bundler

Getting Started
---------------

Clone the git repository and execute:

    $ bundle install

To package the example content execute:

    $ bundle exec rake assets:compile

Background
----------

All example content can be found in src/ directory. All generated output will reside in build/ directory. 

Following Rails 3.1 conventions all assets have an MD5 hashsum filename generated.

Additionally there's a manifest.yml created which contains a mapping of each assets path to it's versioned path.

Contact
-------

Author: Frederik Dietz

Email: fdietz@gmail.com
