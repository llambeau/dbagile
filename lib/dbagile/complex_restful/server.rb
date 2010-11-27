require 'dbagile/restful/server'
require 'dbagile/complex_restful/middleware'

module DbAgile
  module ComplexRestful
    class Server < DbAgile::Restful::Server

      protected
      def factor_rack_app(env)
        ::Rack::Builder.new{ run DbAgile::ComplexRestful::Middleware.new(env) }
      end
              
    end # class Server
  end # module ComplexRestful
end # module DbAgile
