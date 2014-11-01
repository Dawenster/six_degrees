Getting started
===============

Environment
-----------

Ruby 2.0.0

Rails 4.1.1

Configuration
-------------

The following environment variables should be setup in a new file: config/initializers/aaa_secrets.rb

```
ENV['FACEBOOK_APP_ID'] = "<get from Facebook>"
ENV['FACEBOOK_APP_SECRET'] = "<get from Facebook>"
ENV['FACEBOOK_DEV_APP_ID'] = "<get from Facebook>"
ENV['FACEBOOK_DEV_APP_SECRET'] = "<get from Facebook>"
```

Database
--------

To set up databases in development and test environments:
```
rake db:create db:migrate db:test:prepare
```

Testing
-------

No tests yet... we bad.

Gems
----

To setup your gems, run the following:

```
bundle install
```

Emails
------

We don't have emails being sent yet, but when we do...

In development mode, make sure to run the following command in terminal:
```
mailcatcher
```
You can see the "caught" emails by going to localhost:1080 in your browser.  Failure to do this may result in the error:

```
Errno::ECONNREFUSED: Connection refused - connect(2) for "localhost" port 1025
```

Enjoy!
------