module DbAgile
  module Core
    class Configuration
      module Robustness
        
        #
        # Asserts that a configuration name is valid or raises a InvalidConfigurationName 
        # error. A valid configuration name is a Symbol that matches /[a-z][a-z0-9_]*/.
        #
        # @returns [Symbol] name
        # @raise DbAgile::InvalidConfigurationName if assertion fails
        #
        def valid_configuration_name!(name)
          raise DbAgile::InvalidConfigurationName, "Invalid configuration name #{name}"\
            unless name.kind_of?(Symbol) and /[a-z][a-z0-9_]*/ =~ name.to_s
          name
        end
      
        # 
        # Asserts that a database uri is valid or raises a InvalidDatabaseUri error.
        #
        # A valid database uri is any valid absolute URI (for now, will be restricted 
        # to known adapters in the future).
        #
        # @return [String] uri
        # @raise DbAgile::InvalidDatabaseUri if assertion fails
        #
        def valid_database_uri!(uri)
          require 'uri'
          got = URI::parse(uri)
          if got.scheme.nil?
            raise DbAgile::InvalidDatabaseUri, "Invalid database uri: #{uri}" 
          end
          uri
        rescue URI::InvalidURIError
          raise DbAgile::InvalidDatabaseUri, "Invalid database uri: #{uri}"
        end
        
        #
        # Asserts that a configuration exists inside a ConfigFile instance. 
        # When config_name is nil, asserts that a default configuration is set.
        #
        # @return [DbAgile::Core::Configuration] the configuration instance when 
        # found.
        # @raise ArgumentError if config_file is not a ConfigFile instance
        # @raise DbAgile::NoSuchConfigError if the configuration cannot be found.
        # @raise DbAgile::NoDefaultConfigError if config_name is nil and no 
        #        current configuration is set on the config file.
        #
        def has_config!(config_file, config_name = nil)
          raise ArgumentError, "ConfigFile expected, got #{config_file}"\
            unless config_file.kind_of?(DbAgile::Core::ConfigFile)
          config = if config_name.nil?
            config_file.current_config
          else 
            config_file.config(config_name)
          end
          if config.nil?
            raise DbAgile::NoSuchConfigError, "Unknown configuration #{config_name}" if config_name
            raise DbAgile::NoDefaultConfigError, "No default configuration set (try 'dba use ...' first)"
          else
            config
          end
        end
      
      end # module Robustness
    end # class Configuration
  end # module Core
end # module DbAgile