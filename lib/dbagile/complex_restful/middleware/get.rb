module DbAgile
  module ComplexRestful
    class Middleware
      module Get
        include Middleware::Utils
      
        # Implements GET access of the restful interface
        def get(env)
          request = Rack::Request.new(env)
          decode(env) do |connection, table, format|
            # Compute the projection on query string
            heading = connection.heading(table)
            
            # filters parameter can be a JSON encoded hash or a simple get array
            # ex: /url?filters={"language":"ruby","project":"dbagile"}
            # ex: /url?filters[language]=ruby&filters[project]=dbagile
            filters = to_filters_definition(request.GET["filters"], heading)
            
            # sort_by parameter can be a JSON encoded hash or a simple get array
            # ex: /url?sort_by={"language":"desc","project":"asc"}
            # ex: /url?sort_by[language]=desc&sort_by[project]=asc
            sort_by = to_sort_by_definition(request.GET["sort_by"], heading)
            
            # Retrieve dataset
            columns = connection.column_names(table)
            dataset = connection.dataset(table, filters, sort_by)

            # Make output now
            format ||= :json 
            [format, to_xxx_enumerable(format, dataset, columns)]
          end
        end
      
      end # module Get
    end # class Middleware
  end # module ComplexRestful
end # module Facts
