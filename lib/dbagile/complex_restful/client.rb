require 'dbagile/restful/client'
class DbAgile::ComplexRestful::Client < DbAgile::Restful::Client; end

require 'dbagile/complex_restful/client/utils'
require 'dbagile/complex_restful/client/get'
require 'dbagile/complex_restful/client/post'
require 'dbagile/complex_restful/client/delete'

module DbAgile
  module ComplexRestful
    #
    # Helper to query the restful server
    #
    class Client < DbAgile::Restful::Client
      include DbAgile::ComplexRestful::Client::Utils
      include DbAgile::ComplexRestful::Client::Get
      include DbAgile::ComplexRestful::Client::Post
      include DbAgile::ComplexRestful::Client::Delete

    end # class Client
  end # module ComplexRestful
end # module DbAgile
