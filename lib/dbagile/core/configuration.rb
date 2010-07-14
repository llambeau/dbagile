module DbAgile
  module Core
    #
    # Encapsulates configuration of a database handler.
    # 
    class Configuration
      
      # Configuration name
      attr_reader :name
      
      # Plugs as arrays of arrays
      attr_reader :plugs
      
      # Creates a configuration instance
      def initialize(name = :noname, &block)
        @name = name
        @uri = nil
        @connector = ::DbAgile::Core::Connector.new
        self.instance_eval(&block) if block
      end
      
      # Sets the configuration URI
      def uri(uri = nil)
        @uri = uri unless uri.nil?
        @uri
      end
      
      # @see Connector#plug
      def plug(*args)
        (@plugs ||= []) << args
        @connector.plug(*args)
      end
      
      # Connects and returns a Connection object
      def connect(uri = @uri, options = {})
        adapter = DbAgile::Adapter::factor(uri || @uri, options)
        connector = @connector.connect(adapter)
        Connection.new(connector)
      end
      
      # Inspects this configuration, returning a ruby chunk of code
      # whose evaluation leads to a configuration instance
      def inspect
        buffer = ""
        buffer << "DbAgile::config(#{name.inspect}){" << "\n"
        buffer << "  uri #{uri.inspect}" << "\n"
        if plugs and not(plugs.empty?)
          plugs.each{|plug| 
            buffer << "  plug " << plug.collect{|p| p.inspect}.join(', ') << "\n"
          } 
        end
        buffer << "}"
      end
      
    end # class Configuration
  end # module Core
end # module DbAgile 