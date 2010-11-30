require 'dbagile/complex_restful'
require 'dbagile/restful/middleware'
class DbAgile::ComplexRestful::Middleware < DbAgile::Restful::Middleware; end

require 'dbagile/complex_restful/io/extended_json'
require 'dbagile/complex_restful/middleware/utils'
require 'dbagile/complex_restful/middleware/get'
require 'dbagile/complex_restful/middleware/post'
require 'dbagile/complex_restful/middleware/put'
require 'dbagile/complex_restful/middleware/delete'
require 'dbagile/complex_restful/middleware/one_database'

module DbAgile
  module ComplexRestful
    class Middleware
      include DbAgile::ComplexRestful::Middleware::Utils
      
      # Installs the delegates
      def _install
        @delegates = {}
        environment.repository.each{|db|
          @delegates[db.name] = DbAgile::ComplexRestful::Middleware::OneDatabase.new(db)
        }
      end
      
    end # class Middleware
  end # module ComplexRestful
end # module DbAgile
