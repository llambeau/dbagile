module DbAgile
  module ComplexRestful
    class Middleware
      module Post
      
        # Implements POST access of the restful interface
        def post(env)
          request = Rack::Request.new(env)
          decode(env) do |connection, table, format|
            format = :json if format.nil?
            
            # Retrieve heading and keys
            heading = connection.heading(table)
            keys = connection.keys(table)
            
            # Tuple to insert
            # tuple parameter can be a JSON encoded hash or a simple get array
            # ex: /url?tuple={"language":"ruby","project":"dbagile"}
            # ex: /url?tuple[language]=ruby&tuple[project]=dbagile
            tuple = to_tuple_definition(request.POST["tuple"], heading)

            inserted = connection.transaction do |t|
              t.insert(table, tuple)
            end
            
            [format, to_xxx_enumerable(format, [ inserted ], tuple.keys, {
							:additional_infos => {
                :success => true
							}
						})]
          end
        end
      
      end # module Get
    end # class Middleware
  end # module ComplexRestful
end # module Facts
