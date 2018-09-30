Planga Ruby Wrapper:
====================

[![Planga](https://img.shields.io/badge/%F0%9F%98%8E%20planga-chat-ff00ff.svg)](http://www.planga.io/)
[![Planga Docs](https://img.shields.io/badge/planga-docs-lightgrey.svg)](http://www.planga.io/docs)
[![Gem](https://img.shields.io/gem/v/planga.svg)](https://rubygems.org/gems/planga)

**Installation**

Global installation:
`gem install planga`
or, for installation in a single project, add
```
gem 'planga', '~> 0.0.3'
```
to your Gemfile.

**Example usage**

```ruby
require 'planga'

planga = Planga.new(
        :public_api_id => "foobar",
        :private_api_key => "ePxoM3OTkW1z6j84JDurqw",
        :conversation_id => "general",
        :current_user_id => "1234",
        :current_user_name => "Bob",
        :container_id => "my_container_div"
    )

snippet = planga.chat_snippet()
```

**Requirements:**

* Ruby >= 2.4.1
* The Planga gem

**Steps to build and Deploy a new version of the gem:**

* run `gem build planga.gemspec`
* run `gem push planga-n.n.n.gem`
