module DbAgile
  class Engine
    module Data
      
      # Inserts some tuples inside a table
      def insert(table, tuples)
        case tuples
          when Hash
            database.insert(table, tuples)
          when Array
            tuples.collect do |t|
              database.insert(table, t)
            end
        end
      end

      # Inserts some tuples inside a table
      def delete(table, proj = {})
        database.delete(table, proj)
      end
      
      # Updates some tuples of a table
      def update(table, proj = {}, update = {})
        database.update(table, proj, update)
      end
      
    end # module Data
  end # class Engine
end # module DbAgile