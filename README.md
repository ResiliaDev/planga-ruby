Planga Ruby Wrapper:
====================

**requirements:**

* Ruby >= 2.4.1
* gem

**Build and Deploy new gem:**

* run `gem build planga.gemspec`
* run `gem push planga-n.n.n.gem`

**Installing the new gem:**

* run `gem install planga`

**Example usage**

```ruby
require 'planga'

conf = PlangaConfiguration.new(
        :public_api_id => "foobar",
        :private_api_key => "ePxoM3OTkW1z6j84JDurqw",
        :conversation_id => "general",
        :current_user_id => "1234",
        :current_user_name => "Bob",
        :container_id => "my_container_div"
    )

snippet = Planga.get_planga_snippet(conf)
```
