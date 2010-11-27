module DbAgile
  module Restful
    class Client
      module Post

        # Makes a post request
        def post(path, params = {})
          with_uri(path) do |uri|
            Net::HTTP.start(uri.host, uri.port) {|http|
              req = Net::HTTP::Post.new(uri.path)
              req.set_form_data(encode_params_to_json(params))
              res = http.request(req)
              yield(res, http)
              res.body
            }
          end
        end
  
      end # module Post
    end # class Client
  end # module Restful
end # module DbAgile
