module DbAgile
  module Core
    module Schema
      module Migrate
        class ExpandTable < Migrate::Operation
        
          # The table name
          attr_reader :table_name
        
          # The sub operations
          attr_reader :operations
        
          # Creates an alter table operation instance
          def initialize(table_name)
            @table_name = table_name
            @operations = []
          end
                    
        end # class ExpandTable
      end # module Migrate
    end # module Schema
  end # module Core
end # module DbAgile
