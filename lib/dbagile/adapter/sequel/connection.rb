module DbAgile
  class SequelAdapter < Adapter
    module Connection
      
      # @see DbAgile::Contract::Connection#ping
      def ping
        db.test_connection
      end
      
      # @see DbAgile::Contract::Connection#disconnect
      def disconnect
        @db.disconnect if @db
        true
      end
      
      # @see DbAgile::Contract::Connection#physical_schema
      def physical_schema
        SequelAdapter::Schema::PhysicalDump.new.run(db, uri)
      end
    
      # @see DbAgile::Contract::Connection#script2sql
      def script2sql(script, buffer = "")
        SequelAdapter::Schema::ConcreteScript::script2sql(db, script, buffer)
      end
      
      # @see DbAgile::Contract::Connection#transaction
      def transaction(&block)
        raise ArgumentError, "Missing transaction block" unless block
        begin
          db.transaction{ block.call(self) }
        rescue DbAgile::AbordTransactionError
          nil
        end
      end
      
    end # module Connection
  end # class SequelAdapter
end # module DbAgile
