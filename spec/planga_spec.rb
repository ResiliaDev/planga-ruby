require 'planga'

def valid_planga_config()
  Planga.new(
    # These stay the same for all chats:
    :public_api_id => "b5fc4092f05c70445fb758caac5027ca",
    :private_api_key => "ePxoM3OTkW1z6j84JDurqw",
    # These change based on the current user:
    :conversation_id => "general",
    :current_user_id => "1234",
    :current_user_name => "Bob",
  )
end

def invalid_planga_configs()
  {missing_private_api_key:
     Planga.new(
     # These stay the same for all chats:
     :public_api_id => "b5fc4092f05c70445fb758caac5027ca",
     # These change based on the current user:
     :conversation_id => "general",
     :current_user_id => "1234",
     :current_user_name => "Bob",
   ),
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
        expect{ Planga.new(**config) }.to raise_error
      end
    end
  end

  context "Default options are set to expected default values" do

  end
end

RSpec.describe Planga, "#chat_snippet" do
  it "emits valid HTML" do

  end
end

RSpec.describe Planga, "#encrypted_options" do
  it "is a valid JWE-encrypted blob that can be decrypted" do

  end

  it "will give the same options when decrypted that were passed in" do

  end
end
