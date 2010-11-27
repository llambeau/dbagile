module DbAgile
  module ComplexRestful
    class Client
      module Put

        # Makes a put request
        def put(path, params = {})
          with_uri(path) do |uri|
            Net::HTTP.start(uri.host, uri.port) {|http|
              req = Net::HTTP::Put.new(uri.path)
              req.set_form_data(encode_params_to_json(params))
              res = http.request(req)
              yield(res, http)
              res.body
            }
          end
        end
  
      end # module Put
    end # class Client
  end # module ComplexRestful
end # module DbAgile
