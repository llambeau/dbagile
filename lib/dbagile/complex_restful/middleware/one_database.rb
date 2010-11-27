module DbAgile
  module ComplexRestful
    class Middleware
      # 
      # Rack middleware that provide access to a database using a database 
      # instance (DbAgile::Core::Database)
      #
      class OneDatabase < DbAgile::Restful::Middleware::OneDatabase
        include DbAgile::ComplexRestful::Middleware::Get
        include DbAgile::ComplexRestful::Middleware::Post
        include DbAgile::ComplexRestful::Middleware::Put
        include DbAgile::ComplexRestful::Middleware::Delete

        # Decodes a path and yield the block with a connection and the 
        # requested format
        def decode(env)
          case env['PATH_INFO'].strip[1..-1]
            when ''
              _copyright_(env)
            when /(\w+)(\.(\w+))?$/
              table = $1.to_sym
            
              # Handle format
              format = nil
              if $2
                format = known_extension?($2)
                return _404_(env) unless format
              end
            
              format, body = database.with_connection do |connection|
                yield(connection, table, format) 
              end
              
              content_type = DbAgile::IO::FORMAT_TO_CONTENT_TYPE[format]
              _200_(env, content_type, body)
            else
              _404_(env)
          end
        rescue DbAgile::InvalidDatabaseName,
               DbAgile::NoSuchDatabaseError,
               DbAgile::NoSuchTableError => ex
          _404_(env, ex)
        rescue DbAgile::Error, Sequel::Error => ex
          if ex.message =~ /exist/
            _404_(env)
          else
            raise
          end
        end
              
      end # class OneDatabase
    end # class Middleware
  end # module ComplexRestful
end # module DbAgile
