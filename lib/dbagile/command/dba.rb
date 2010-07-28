module DbAgile
  class Command
    #
    # Agile SQL databases and tools for database administrators
    #
    # Usage: dba [--version] [--help] [--list]
    #        dba help [--complete] <subcommand>
    #        dba [--config=FILE] [--use=DB] <subcommand> [OPTIONS] [ARGS]
    #
    # DbAgile aims at supporting database administrators and developers of database
    # oriented application. Read more about it on http://blambeau.github.com/dbagile.
    #
    class Dba < Command
      Command::build_me(self, __FILE__)
      
      # Configuration file
      attr_accessor :repository_path
      
      # Database configuration to use
      attr_accessor :use_config
      
      # Continue after my options
      attr_accessor :stop_after_options

      # Returns command's category
      def category
        :dba
      end
      
      # Contribute to options
      def add_options(opt)
        opt.separator nil
        opt.separator "Options:"
        opt.on("--config=FILE", 
               "Use a specific configuration file (defaults to ~/.dbagile)") do |value|
          self.repository_path = value
        end
        opt.on("--use=DB", 
               "Use a specific database configuration") do |value|
          self.use_config = value
        end
        opt.on_tail("--help", "Show help") do
          show_short_help
          self.stop_after_options = true
        end
        opt.on_tail("--list", "Show list of available subcommands") do
          show_long_help
          self.stop_after_options = true
        end
        opt.on_tail("--version", "Show version") do
          say("dba" << " " << DbAgile::VERSION << " (c) 2010, Bernard Lambeau")
          self.stop_after_options = true
        end
      end

      # Returns commands by category
      def commands_by_categ
        return @commands_by_categ if @commands_by_categ
        @commands_by_categ = Hash.new{|h,k| h[k] = []}
        Command.subclasses.each do |subclass|
          next if subclass == Dba
          name     = Command::command_name_of(subclass)
          command  = Command::command_for(name, environment)
          category = command.category
          raise "Unknown command category #{category}" unless DbAgile::Command::CATEGORIES.include?(category)
          @commands_by_categ[category] << command
        end
        @commands_by_categ
      end

      # Show command help for a specific category
      def show_commands_help(category)
        commands_by_categ[category].each do |command|
          display options.summary_indent + command.command_name.ljust(30) + command.summary.to_s
        end
      end

      # Shows the short help
      def show_short_help
        display banner
        display options.summarize
        display "\n"
      end
      alias :show_help :show_short_help
      
      # Shows the long help
      def show_long_help
        show_short_help
        DbAgile::Command::CATEGORIES.each{|categ|
          display DbAgile::Command::CATEGORY_NAMES[categ]
          show_commands_help(categ)
          display ""
        }
      end
      
      # Runs the command
      def unsecure_run(requester_file, argv)
        #environment.load_history
        
        # My own options
        my_args = []
        while argv.first =~ /^--/
          my_args << argv.shift
        end
        options.parse!(my_args)
        
        # Prepare the environment
        if self.repository_path
          environment.repository_path = self.repository_path
        end
        if self.use_config
          environment.repository.current_db_name = self.use_config.to_sym
        end
        
        # Invoke sub command
        unless stop_after_options
          invoke_subcommand(requester_file, argv) 
        end
      rescue Exception => ex
        environment.on_error(self, ex)
        environment
      ensure
        #environment.save_history if environment.manage_history?
      end
      
      # Invokes the subcommand
      def invoke_subcommand(requester_file, argv)
        # Save command in history 
        unless ['replay', 'history'].include?(argv[0])
          #environment.push_in_history(argv) 
        end
      
        # Command execution
        if argv.size >= 1
          command = has_command!(argv.shift, environment)
          command.run(requester_file, argv)
        else
          show_help
        end
      end

    end # class DbA
  end # class Command
end # module DbAgile