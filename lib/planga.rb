require 'securerandom'
require 'jose'
require 'json'

class Planga
    attr_accessor :public_api_id, :private_api_key, :conversation_id,
        :current_user_id, :current_user_name, :container_id, :remote_host

    
    def initialize(**conf)
        @public_api_id = conf[:public_api_id]
        @private_api_key = conf[:private_api_key]
        @conversation_id = conf[:conversation_id]
        @current_user_id = conf[:current_user_id]
        @current_user_name = conf[:current_user_name]
        @container_id = conf[:container_id]
        @remote_host = conf[:remote_host] || "//chat.planga.io"

        if not container_id
            @container_id = "planga-chat-" + SecureRandom.hex
        end
    end
    

    def chat_snippet
        return %{
            <script type=\"text/javascript\" src=\"#{self.remote_host}/js/js_snippet.js\"></script>
            <div id=\"#{self.container_id}\"></div>
            <script type=\"text/javascript\">
               new Planga(document.getElementById(\"#{self.container_id}\"), \{
                   public_api_id: \"#{self.public_api_id}\",
                   encrypted_options: \"#{encrypt_options()}\",
                   socket_location: \"#{self.remote_host}/socket\",
               \});
            </script>
        }
    end
    

    private
    def encrypt_options
        key = JOSE::JWK.from({"k" => self.private_api_key, "kty" => "oct"})

        payload = {
                "conversation_id": self.conversation_id,
                "current_user_id": self.current_user_id,
                "current_user_name": self.current_user_name
            }

        return JOSE::JWE.block_encrypt(
                key, 
                payload.to_json, 
                { "alg" => "A128GCMKW", "enc" => "A128GCM" }
            ).compact
    end
end