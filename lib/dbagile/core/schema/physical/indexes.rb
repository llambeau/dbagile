require 'dbagile/core/schema/physical/indexes'
require 'dbagile/core/schema/physical/index'
module DbAgile
  module Core
    class Schema
      class Physical < Schema::Brick
        #
        # Index collection
        #
        class Indexes < Schema::Brick
          include Schema::NamedCollection
        
          # Creates a logical schema instance
          def initialize
            __initialize_named_collection
          end
        
        end # class Indexes
      end # class Logical
    end # class Schema
  end # module Core
end # module DbAgile