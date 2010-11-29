module DbAgile
  module ComplexRestful
    class Middleware
      module Utils
      
      # Transform sort_by http parameters to valid definition
      def to_sort_by_definition(params, heading)
        params = transform_to_params(params, heading)
        params.each_pair do |key, value|
          params[key] = (value.downcase == "desc") ? :desc : :asc
        end
        params
      end
      
      # Transform filters http parameters to valid definition
      def to_filters_definition(params, heading)
        params = transform_to_params(params, heading)
        params
      end
      alias to_tuple_definition to_filters_definition
      
      # Transform windowing http parameters to valid definition
      def to_windowing_definition(params)
        params = transform_to_params(params)
        params
      end

      # Transform valid http parameters or JSON to hash
      # Converts all keys to symbols
      # Pass array of symbols as second parameters to keep only valid parameters
      def transform_to_params(params, keep = nil)
        ret = {}
        params = (params.nil? or params.empty?) ? {} : params
        params = ::JSON.parse(params) unless params.kind_of? Hash
        if keep
          params.delete_if { |key, value| !keep.key?(key.to_sym) }
        end
        params.each_pair do |key, value|
          ret[key.to_sym] = value
        end
        ret
      end
      
      end # module Utils
    end # class Middleware
  end # module ComplexRestful
end # module DbAgile
