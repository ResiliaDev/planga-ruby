require 'securerandom'
require 'jose'
require 'json'

# This class allows you to create a snippet of HTML/JS that,
# if included in a webpage, lets the visitor of that webpage
# connect with the Planga Chat Server and start chatting.
class Planga
    # The following configuration options are available:
    #
    # Required are:
    #
    # * public_api_id: The public API ID that can be found in the Planga Dashboard.
    # * private_api_key: The private API key that can be found in the Planga Dashboard.
    # * conversation_id: The identifier that uniquely identifies the single conversation
    # that the user can connect with in this chat. Examples would be "general", "product/1234" or "private/123/543".
    # * current_user_id: The internal ID your application uses, which uniquely identifies
    # the user currently using your application.
    # * current_user_name: The name of this user. This name is shown in the chat interface
    # next to the typed messages
    #
    # Optional are:
    #
    # * remote_host: This can point to another host, if you are hosting your own instance of Planga.
    # It defaults to the URL of Planga's main chat server. (`//chat.planga.io`)
    # * container_id: If you want a custom HTML ID attribute specified to the created HTML element,
    # you can enter it here.
    # * include_style: Can be the location of a custom stylesheet to include,
    # or `false` if you do not want to include your own style
    # (and do this manually somewhere else in the page).
    # (Defaults to "#{remote_host}/css/chat-style-basic.css")
    # * debug: (defaults to `false`).
    #
    def initialize(**conf)
        @public_api_id = conf[:public_api_id]
        @private_api_key = conf[:private_api_key]
        @conversation_id = conf[:conversation_id]
        @current_user_id = conf[:current_user_id]
        @current_user_name = conf[:current_user_name]

        @remote_host = conf[:remote_host]
        @remote_host ||= "//chat.planga.io"

        @container_id = conf[:container_id]
        @container_id ||= "planga-chat-" + SecureRandom.hex

        @include_style = conf[:include_style]
        @include_style ||= "#{remote_host}/css/chat-style-basic.css"
	      @debug = conf[:debug] || false
    end


    # Creates a full-fledged HTML snippet that includes Planga in your page.
    def chat_snippet
        <<-SNIPPET
            #{style_tag()}
            <script type="text/javascript" src="#{@remote_host}/js/js_snippet.js"></script>
            <div id="#{@container_id}"></div>
            <script type="text/javascript">
               new Planga(document.getElementById("#{@container_id}"), \{
                   public_api_id: "#{@public_api_id}",
                   encrypted_options: "#{encrypted_options()}",
                   socket_location: "#{@remote_host}/socket",
                   debug: #{@debug},
               \});
            </script>
        SNIPPET
    end

    def style_tag()
     "" unless @include_style

     <<-SNIPPET
     <link rel="#{include_style}">"
     SNIPPET
    end


    # Returns the encrypted configuration.
    #
    # This function is useful if (and only if) you do not want to use the normal chat snippet,
    # but want to completely customize how Planga loads (so you want to create it manually).
    def encrypted_options
        encrypt(construct_encrypted_options())
    end

    private def construct_encrypted_options
      {
        "conversation_id": @conversation_id,
        "current_user_id": @current_user_id,
        "current_user_name": @current_user_name
      }.to_json
    end

    private def encrypt(payload)
      JOSE::JWE.block_encrypt(
        unwrapped_key,
        payload,
        { "alg" => "A128GCMKW", "enc" => "A128GCM" }
      ).compact
    end

    private def unwrapped_key()
      JOSE::JWK.from({"k" => @private_api_key, "kty" => "oct"})
    end
end
