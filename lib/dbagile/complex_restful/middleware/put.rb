module DbAgile
  module ComplexRestful
    class Middleware
      module Put
      
        # Implements PUT access of the restful interface
        def put(env)
          request = Rack::Request.new(env)
          decode(env) do |connection, table, format|
            format = :json if format.nil?
            
            # Retrieve heading and keys
            heading = connection.heading(table)
            keys = connection.keys(table)
            
            # filters parameter can be a JSON encoded hash or a simple get array
            # ex: /url?filters={"language":"ruby","project":"dbagile"}
            # ex: /url?filters[language]=ruby&filters[project]=dbagile
            filters = to_filters_definition(request.POST["filters"], heading)
  
            # Tuple to insert
            tuple = to_tuple_definition(request.POST["tuple"], heading)
            
            updated = connection.transaction do |t|
              t.update(table, tuple, filters)
            end
            
            [format, to_xxx_enumerable(format, [ updated ], tuple.keys)]
          end
        end
      
      end # module Get
    end # class Middleware
  end # module ComplexRestful
end # module Facts
