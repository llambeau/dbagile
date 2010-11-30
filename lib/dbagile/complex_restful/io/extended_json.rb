module DbAgile
  module IO
    module JSON

      # 
      # Override JSON behavior
      #
      # @return [...] the buffer itself
      #
      def to_json(data, columns = nil, buffer = "", options = {})
        require "json"
        result = {
          :data => []
        }
        with_type_safe_relation(data, options) do |tuple|
          result[:data] << tuple
        end
        
        additional_datas = options[:additional_infos] || {}
        additional_datas.each_pair do |key, value|
          result[key] = value
        end
        
        buffer << ::JSON::fast_generate(result)
        buffer
      end
      module_function :to_json
            
    end # module JSON
  end # module IO
end # module DbAgile
