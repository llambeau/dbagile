module DbAgile
  class SequelAdapter < Adapter
    module Data
      module TableDriven

        # @see DbAgile::Contract::Data::TableDriven#dataset
        def dataset(table, proj = nil, sort = nil, window = nil)
          result = case table
            when Symbol
              (proj.nil? or proj.empty?) ? db[table] : db[table].where(proj)
            else
              (proj.nil? or proj.empty?) ? db[table] : db[table].where(proj)
          end
          
          # Transform
          if sort
            sort = sort.to_a.collect do |definition|
              field = definition[0].to_sym
              definition[1] == :desc ? field.desc : field.asc
            end
          end
          result = (sort.nil? or sort.empty?) ? result : result.order(*sort)
          
          # Windowing
          if window
            if window[:offset]
              result = result.limit(window[:limit], window[:offset])
            else
              result = result.limit(window[:limit])
            end
          end
          
          result.extend(::DbAgile::Contract::Data::Dataset)
          result
        end
      
        # @see DbAgile::Contract::Data::TableDriven#exists?
        def exists?(table_or_query, subtuple = {})
          if subtuple.nil? or subtuple.empty?
            !dataset(table_or_query).empty?
          else
            !dataset(table_or_query).where(subtuple).empty?
          end
        end
    
      end # module TableDriven
    end # module Data
  end # class SequelAdapter
end # module DbAgile
