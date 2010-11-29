module DbAgile
  module ComplexRestful
    class Middleware
      module Utils
      
      # Transform sort_by http parameters to valid definition
      def to_sort_by_definition(params, heading)
        params = (params.nil? or params.empty?) ? {} : params
        params.delete_if? { |key, value| !heading.key?(key) }
        params = ::JSON.parse(params) unless params.kind_of? Hash
        sort_by = {}
        params.each_pair do |key, value|
          sort_by[key.to_sym] = (value.downcase == "desc") ? :desc : :asc
        end
      end
      
      # Transform filters http parameters to valid definition
      def to_filters_definition(params, heading)
        params = (params.nil? or params.empty?) ? {} : params
        params.delete_if? { |key, value| !heading.key?(key) }
        params = ::JSON.parse(params) unless params.kind_of? Hash
        filters = {}
        params.each_pair do |key, value|
          filters[key.to_sym] = value
        end
        filters
      end
      alias to_tuple_definition to_filters_definition
      
      end # module Utils
    end # class Middleware
  end # module ComplexRestful
end # module DbAgile
