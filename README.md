Planga Ruby Wrapper:
====================

[![Planga](https://img.shields.io/badge/%F0%9F%98%8E%20planga-chat-ff00ff.svg)](http://www.planga.io/)
[![Planga Docs](https://img.shields.io/badge/planga-docs-lightgrey.svg)](http://www.planga.io/docs)
[![Gem](https://img.shields.io/gem/v/planga.svg)](https://rubygems.org/gems/planga)
[RubyDoc](https://www.rubydoc.info/github/ResiliaDev/planga-ruby/master)
[![Build Status](https://travis-ci.org/ResiliaDev/planga-ruby.svg?branch=master)](https://travis-ci.org/ResiliaDev/planga-ruby)

**Installation**

Global installation:
`gem install planga`
or, for installation in a single project, add
```
gem 'planga', '~> 0.6.0'
```
to your Gemfile.

**Example usage**

```ruby
require 'planga'

planga = Planga.new(
        # These stay the same for all chats:
        :public_api_id => "b5fc4092f05c70445fb758caac5027ca",
        :private_api_key => "ePxoM3OTkW1z6j84JDurqw",
        # These change based on the current user:
        :conversation_id => "general",
        :current_user_id => "1234",
        :current_user_name => "Bob",
    )

snippet = planga.chat_snippet()
```

For more information on what the different fields mean, see the [main Planga.io documentation](https://planga.io/docs) (until more detailed Ruby-specific documentation has been written).

For a guide that goes into a little bit more details, see [Building Live Chat Between Users in a Rails application using Planga.io](https://medium.com/@renevanpelt/building-live-chat-between-users-in-a-rails-application-91bc3a33b545)


**Requirements:**

* Ruby >= 2.4.1
* The Planga gem



**Steps to build and Deploy a new version of the gem:**

_(This is only interesting if you want to make a fork of this Gem)_

**NOTE:** We've set up Travis-CI to build a new version of the official gem whenever a tagged commit is made

* run `gem build planga.gemspec`
* run `gem push planga-n.n.n.gem`
