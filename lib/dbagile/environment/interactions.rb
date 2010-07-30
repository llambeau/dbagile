module DbAgile
  class Environment
    # 
    # Environment's interactions contract.
    #
    module Interactions
      
      # The output buffer to use for user requests
      attr_accessor :input_buffer
    
      # The output buffer to use for display
      attr_reader :output_buffer
      
      # Sets the output buffer
      def output_buffer=(io)
        @output_buffer = io
        @highline = HighLine.new(input_buffer, io)
      end
    
      #
      # Asks something to the user/oracle. If a continuation block is given
      # yields it with result returns block result. Simply returns the value 
      # otherwise.
      #
      # This method is provided when something needs to be asked to the user. The 
      # result should be passed as a string to the continuation proc.
      #
      # @param [String] prompt a prompt for user-oriented environments
      # @param [Proc] continuation a optional continuation procedure
      # @return [...] result of the continuation block
      #
      def ask(prompt, &continuation)
        if continuation
          continuation.call(readline(prompt))
        else
          readline(prompt)
        end
      end
    
      # 
      # Prints an information message. An optional color may be provided if the 
      # environment supports colors.
      #
      # @param [String] something a message to print
      # @param [Symbol] an optional color
      # @return [void]
      #
      def say(something, color = nil)
        if color
          @highline.say(@highline.color(something, color))
        else
          @highline.say(something)
        end
      end
    
      # 
      # Displays something.
      #
      # @param [Object] something to write on environment output
      # @return [void]
      #
      def display(something)
        if something.kind_of?(String)
          writeline(something)
        elsif something.kind_of?(Enumerable)
          something.each{|v| display(v)}
        else
          writeline(something.to_s)
        end
        nil
      end
    
      # Protected section starts here ###################################################
      protected

      # 
      # Reads a line on the abstract input buffer and returns it.
      #
      # This method is an internal tool and is not part of the Environment
      # contract per se. The default implementation relies on Readline.
      #
      # @param [String] a prompt to display
      # @return [String] line that has been read
      #
      def readline(prompt)
        line = Readline.readline(prompt, false)
        line
      end
    
      # 
      # Writes a line on the abstract output buffer.
      #
      # This method is an internal tool and is not part of the Environment
      # contract per se. The default implementation writes the line on real
      # output buffer provided at construction.
      #
      # @param [String] something a message to display
      #
      def writeline(something)
        return if output_buffer.nil?
        output_buffer << something 
        output_buffer << "\n" unless something =~ /\n$/
      end

    end # module Interactions
  end # class Environment
end # module DbAgile