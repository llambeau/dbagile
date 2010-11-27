module DbAgile
  module Restful
    class Client
      module Utils

        # Yields the block with an URI to access the server
        def with_uri(path, params = {})
          uri = "#{server_uri}#{path}"
          uri += "?" + encode_params_to_url(params) unless params.empty?
          
          yield(URI.parse(uri))
        end

        def encode_params_to_url(params={})
          params = encode_params_to_json(params)
          uri = ""
          params.each_pair do |key,value|
            key, value = CGI::escape(key), CGI::escape(value)
            uri += "#{key}=#{value}&"
          end
          uri
        end
  
        def encode_params_to_json(params={})
          h = Hash.new
          params.each_pair do |key,value|
            h[key.to_s] = value.to_json
          end
          h
        end
        
      end # module Get
    end # module Utils
  end # module Restful
end # module DbAgile
