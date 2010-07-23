module DbAgile
  class Command
    module Schema
      #
      # Show differences between database schemas
      #
      # Usage: dba #{command_name}
      #        dba #{command_name} REFERENCE
      #        dba #{command_name} DB1 DB2
      #
      # When used without any argument, shows the differences between the schema inside
      # the SQL database (left) of the current configuration and the schema files (right).
      #
      # When used with one configuration name (REFERENCE), shows the differences between
      # the schema of the current configuration and the schema of REFERENCE.
      #
      # When used with two configuration names (DB1 and DB2), shows the differences between
      # the schemas of the respective databases.
      #
      # WARNING: The current version of DbAgile is unable to infer some SQL database objects
      #          (like foreign keys) when using certain adapters. In contrast, comparing 
      #          schema files is safe. Therefore, in the second and third cases, if schema 
      #          files are installed, they have the prirory. Use --real option to override 
      #          this behavior. 
      #
      class Diff < Command
        include Schema::ComparisonBased
        Command::build_me(self, __FILE__)
      
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          add_common_schema_options(opt)
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          normalize_comparison_arguments(arguments)
        end
        
        # Executes the command
        def execute_command
          ls, ld, rs, rd = left_and_right_schemas(true)
          show_minus(ld, ls, rd, rs, :remove)
          show_minus(rd, rs, ld, ls, :add)
        end
      
      end # class SchemaDump
    end # module Schema
  end # class Command
end # module DbAgile