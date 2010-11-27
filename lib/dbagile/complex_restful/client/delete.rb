module DbAgile
  module ComplexRestful
    class Client
      module Delete

        # Makes a delete request
        def delete(path, params = {})
          with_uri(path, params) do |uri|
            Net::HTTP.start(uri.host, uri.port) {|http|
              req = Net::HTTP::Delete.new(uri.path)
              req.set_form_data(encode_params_to_json(params)) unless params.nil?
              res = http.request(req)
              yield(res, http)
              res.body
            }
          end
        end
  
      end # module Delete
    end # class Client
  end # module Restful
end # module DbAgile
