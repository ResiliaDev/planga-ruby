require 'planga'

def valid_planga_config
  {
    # These stay the same for all chats:
    :public_api_id => "b5fc4092f05c70445fb758caac5027ca",
    :private_api_key => "ePxoM3OTkW1z6j84JDurqw",
    # These change based on the current user:
    :conversation_id => "general",
    :current_user_id => "1234",
    :current_user_name => "Bob",
  }
end

def invalid_planga_configs
  {missing_private_api_key:
     {
     # These stay the same for all chats:
     :public_api_id => "b5fc4092f05c70445fb758caac5027ca",
     # These change based on the current user:
     :conversation_id => "general",
     :current_user_id => "1234",
     :current_user_name => "Bob",
   },
   missing_public_api_key:
     {
     # These stay the same for all chats:
     :private_api_key => "ePxoM3OTkW1z6j84JDurqw",
     # These change based on the current user:
     :conversation_id => "general",
     :current_user_id => "1234",
     :current_user_name => "Bob",
   },
   missing_conversation_id:
     {
     # These stay the same for all chats:
     :public_api_id => "b5fc4092f05c70445fb758caac5027ca",
     :private_api_key => "ePxoM3OTkW1z6j84JDurqw",
     # These change based on the current user:
     :current_user_id => "1234",
     :current_user_name => "Bob",
   },
   missing_current_user_id:
     {
     # These stay the same for all chats:
     :public_api_id => "b5fc4092f05c70445fb758caac5027ca",
     :private_api_key => "ePxoM3OTkW1z6j84JDurqw",
     # These change based on the current user:
     :conversation_id => "general",
     :current_user_name => "Bob",
   },
   missing_current_user_name:
     {
     # These stay the same for all chats:
     :public_api_id => "b5fc4092f05c70445fb758caac5027ca",
     :private_api_key => "ePxoM3OTkW1z6j84JDurqw",
     # These change based on the current user:
     :conversation_id => "general",
     :current_user_id => "1234",
   },
   invalid_private_api_key:
     {
     # These stay the same for all chats:
     :public_api_id => "b5fc4092f05c70445fb758caac5027ca",
     :private_api_key => 42,
     # These change based on the current user:
     :conversation_id => "general",
     :current_user_id => "1234",
     :current_user_name => "Bob",
   },
  }
end

RSpec.describe Planga, "#initialize" do
  context "with a correct configuration" do
    it "allows the instance to be created" do
      expect(Planga.new(**valid_planga_config)).to be
    end
  end

  context "with an invalid configuration" do
    invalid_planga_configs.each do |key, config|
      it "raises a validation error when #{key}" do
        pending('Implement validations')
        expect{ Planga.new(**config) }.to raise_error
      end
    end
  end

  it "by default turns off debug mode" do
    expect(Planga.new(**valid_planga_config).debug).to be false
  end
end

RSpec.describe Planga, "#chat_snippet" do
  it "emits valid HTML" do
    snippet = Planga.new(valid_planga_config).chat_snippet
    doc = Nokogiri::HTML.fragment(snippet)
    expect(doc.errors).to be_empty
  end

  it "has two script tags and a container div" do
    snippet = Planga.new(valid_planga_config.merge({container_id: "my-container"})).chat_snippet
    doc = Nokogiri::HTML.fragment(snippet) { |config| config.strict }

    expect(doc.css('script').size).to eq 2
    expect(doc.css('div#my-container').size).to eq 1
  end

  it "by default includes default chat stylesheet" do
    snippet = Planga.new(valid_planga_config).chat_snippet
    doc = Nokogiri::HTML.fragment(snippet) { |config| config.strict }

    expect(doc.at_css('link').attribute('rel').value).to eq "//chat.planga.io/css/chat-style-basic.css"
  end

  it "includes custom stylesheet when configured" do
    style_uri = "http://my-site.com/my/own/style.css"
    snippet = Planga.new(valid_planga_config.merge(include_style: style_uri)).chat_snippet
    doc = Nokogiri::HTML.fragment(snippet) { |config| config.strict }

    expect(doc.at_css('link').attribute('rel').value).to eq style_uri
  end


  it "includes no stylesheet when `include_style` turned off" do
    snippet = Planga.new(valid_planga_config.merge(include_style: false)).chat_snippet
    doc = Nokogiri::HTML.fragment(snippet) { |config| config.strict }

    expect(doc.at_css('link')).to be_nil
  end

  it "by default uses default host" do
    snippet = Planga.new(valid_planga_config).chat_snippet
    doc = Nokogiri::HTML.fragment(snippet) { |config| config.strict }

    expect(doc.at_css('script').attribute('src').value).to eq "//chat.planga.io/js/js_snippet.js"
  end

  it "includes custom host when configured" do
    host_uri = "//my_host.com"
    snippet = Planga.new(valid_planga_config.merge(remote_host: host_uri)).chat_snippet
    doc = Nokogiri::HTML.fragment(snippet) { |config| config.strict }

    expect(doc.at_css('script').attribute('src').value).to eq "//my_host.com/js/js_snippet.js"
    expect(doc.at_css('link').attribute('rel').value).to eq "#{host_uri}/css/chat-style-basic.css"
  end
end

RSpec.describe Planga, "#encrypted_options" do
  before(:each) do
    blob = Planga.new(**valid_planga_config).encrypted_options
    unwrapped_key = JOSE::JWK.from({"k" => valid_planga_config[:private_api_key], "kty" => "oct"})
    res = JOSE::JWE.block_decrypt(unwrapped_key, blob).first
    @json = JSON.parse(res)
  end
  it "is a valid JWE-encrypted blob that can be decrypted" do
    expect(@json.keys.sort).to eq ["conversation_id", "current_user_id", "current_user_name"].sort
  end

  it "will give the same options when decrypted that were passed in" do
    expected = { "conversation_id" => valid_planga_config[:conversation_id],
      "current_user_id" => valid_planga_config[:current_user_id],
      "current_user_name" => valid_planga_config[:current_user_name],
    }

    expect(@json).to eq expected
  end
end
