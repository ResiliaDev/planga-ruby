require 'securerandom'
require 'jose'
require 'json'

class Planga
    def self.get_planga_snippet(configuration)
        return %{
            <script type=\"text/javascript\" src=\"#{configuration.remote_host}/js/js_snippet.js\"></script>
            <div id=\"#{configuration.container_id}\"></div>
            <script type=\"text/javascript\">
               new Planga(document.getElementById(\"#{configuration.container_id}\"), \{
                   public_api_id: \"#{configuration.public_api_id}\",
                   encrypted_options: \"#{Planga.encrypt_options(configuration)}\",
                   socket_location: \"#{configuration.remote_host}/socket\",
               \});
            </script>
        }
    end
    
    private
    def self.encrypt_options(configuration)
        key = JOSE::JWK.from({"k" => configuration.private_api_key, "kty" => "oct"})

        payload = {
                "conversation_id": configuration.conversation_id,
                "current_user_id": configuration.current_user_id,
                "current_user_name": configuration.current_user_name
            }

        return JOSE::JWE.block_encrypt(
                key, 
                payload.to_json, 
                { "alg" => "A128GCMKW", "enc" => "A128GCM" }
            ).compact
    end
end

class PlangaConfiguration
    attr_accessor :public_api_id, :private_api_key, :conversation_id,
        :current_user_id, :current_user_name, :container_id, :remote_host

    def initialize(**conf)
        @public_api_id = conf[:public_api_id]
        @private_api_key = conf[:private_api_key]
        @conversation_id = conf[:conversation_id]
        @current_user_id = conf[:current_user_id]
        @current_user_name = conf[:current_user_name]
        @container_id = conf[:container_id]
        @remote_host = conf[:remote_host] || "//planga.def"

        if not container_id
            @container_id = "planga-chat-" + SecureRandom.hex
        end
    end
end