require 'stringio'
require 'json'
require 'dbagile'
require 'dbagile/restful/middleware/utils'
require 'dbagile/restful/middleware/get'
require 'dbagile/restful/middleware/post'
require 'dbagile/restful/middleware/delete'
require 'dbagile/restful/middleware/one_database'
module DbAgile
  module Restful
    class Middleware
      include Middleware::Utils
    
      # Environment
      attr_reader :environment
      
      # OneDatabase delegates
      attr_reader :delegates
    
      # Creates a Restful handler
      def initialize(environment = DbAgile::default_environment, &block)
        raise "Environment may not be nil" if environment.nil?
        block.call(environment) if block
        @environment = environment
        _install
      end
      
      # Installs the delegates
      def _install
        @delegates = {}
        environment.repository.each{|db|
          @delegates[db.name] = Middleware::OneDatabase.new(db)
        }
      end
      
      # Delegated according to the path
      def call(env)
        env['PATH_INFO'] =~ /^\/(\w+)(.*)$/
        if $1
          if delegates.key?($1.to_sym)
            env['PATH_INFO'] = $2
            delegates[$1.to_sym].call(env)
          else
            _404_(env)
          end
        else
          _copyright_(env)
        end
      end
     
      private :_install
    end # class Middleware
  end # module Restful
end # module DbAgile