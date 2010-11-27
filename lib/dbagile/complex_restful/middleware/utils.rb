module DbAgile
  module ComplexRestful
    class Middleware
      module Utils
      
      # Transform sort_by http parameters to valid definition
      def to_sort_by_definition(params)
        sort_by = (params.nil? or params.empty?) ? {} : params
        sort_by = ::JSON.parse(sort_by) unless sort_by.kind_of? Hash
        sort_by.each_pair do |key, value|
          sort_by[key] = (value.downcase == "desc") ? :desc : :asc
        end
      end
      
      # Transform filters http parameters to valid definition
      def to_filters_definition(params)
        filters = (params.nil? or params.empty?) ? {} : params
        filters = ::JSON.parse(filters) unless filters.kind_of? Hash
        filters
      end
      alias to_tuple_definition to_filters_definition
      
      end # module Utils
    end # class Middleware
  end # module ComplexRestful
end # module DbAgile
