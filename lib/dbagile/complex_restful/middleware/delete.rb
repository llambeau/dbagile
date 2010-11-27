module DbAgile
  module ComplexRestful
    class Middleware
      module Delete
      
        # Implements DELETE access of the restful interface
        def delete(env)
          request = Rack::Request.new(env)
          decode(env) do |connection, table, format|
            heading = connection.heading(table)

            # filters parameter can be a JSON encoded hash or a simple get array
            # ex: /url?filters={"language":"ruby","project":"dbagile"}
            # ex: /url?filters[language]=ruby&filters[project]=dbagile
            filters = to_filters_definition(request.POST["filters"])
            
            tuple = params_to_tuple(filters, heading)
            connection.transaction do |t|
              t.delete(table, tuple)
            end
            [ :json, [ JSON::generate(:ok => true) ] ]
          end
        end
      
      end # module Delete
    end # class Middleware
  end # module ComplexRestful
end # module Facts
