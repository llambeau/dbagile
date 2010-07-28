module DbAgile
  module Core
    module Schema
      module Computations
        module Stage
          class Stager
        
            # List of status
            Status = ::DbAgile::Core::Schema
            
            # Default stager options
            DEFAULT_OPTIONS = {:expand => true, :collapse => true}
        
            # List of abstract operations
            attr_reader :operations
  
            # Helper for each table
            attr_reader :helpers
  
            ############################################################################
            ### Schema info helpers need
            ############################################################################
        
            # Checks if table already exists
            def relvar_exists?(rv)
              (rv.status == Status::TO_ALTER) or (rv.status == Status::CREATED)
            end
  
            # Asserts that a table exists
            def relvar_exists!(rv)
              rv.status = Status::CREATED
            end
  
            ############################################################################
            ### Public interface
            ############################################################################
        
            #
            # Runs the staging algorithm on an annotated schema (result of a merge)
            # and options.
            #
            def run(schema, options)
              @helpers = {}
              @operations = []
          
              # Take all objects and mark them as :to_ensure
              all_objects = schema.collect{|o, parent| o}
          
              # Collapse first
              if options[:collapse]
                collapse_objects(all_objects.select{|obj| obj.status == Status::TO_DROP})
              end
          
              # Expand then
              if options[:expand]
                expand_objects(all_objects.select{|obj| obj.status == Status::TO_CREATE})
              end
          
              # clean
              raise AssumptionFailedError, "Helpers should be empty" unless @helpers.empty?
              to_return = @operations
              @operations = nil
              @helpers = nil
              to_return
            end
        
            ############################################################################
            ### Collapse algorithms (for drop)
            ############################################################################

            # Yields the block with an helper to collapse a relation
            # variable, creating it if required.
            def with_collapse_helper(rv)
              if h = helpers[rv]
                yield(h)
              else
                h = helpers[rv] = Stage::CollapseHelper.new(self, rv)
                yield(h)
                operations.push(*h.flush)
                helpers.delete(rv)
              end
            end
  
            # Ensures inexistence of a list of schema objects
            def collapse_objects(schema_objects)
              schema_objects.each do |object|
                case s = object.status
                  when Status::TO_DROP, Status::TO_ALTER
                    collapse_object(object)
                  when Status::NO_CHANGE, Status::DROPPED
                    # nothing to do
                  else
                    msg = "Unexpected status #{s} for #{object} for schema collapsing"
                    raise AssumptionFailedError, msg
                end
              end
            end
        
            # Ensures inexistence of a single schema object
            def collapse_object(object)
              parent = object.parent
          
              case parent.status
                when Status::DROPPED
                  # nothing do do, parent has certainly removed me
                  object.status = Status::DROPPED
                when Status::TO_DROP
                  #
                  # Delegate to parent if it needs to be collapsed itself
                  #
                  # Making this helps issuing a single DROP TABLE and avoiding 
                  # many ALTER TABLE that will eventually fail (the last column)
                  #
                  collapse_object(parent)
                  object.status = Status::DROPPED
                else
                  object.status = Status::PENDING
              
                  collapse_call = :"collapse_#{object.builder_handler}"
                  self.send(collapse_call, object)
              
                  object.status = Status::DROPPED
              end
            end

            # Collapses a relation variable
            def collapse_relvar(relvar)
              operations << [:DROP_TABLE, relvar.name]
            end

            # Collapses a candidate key
            def collapse_candidate_key(ckey)
              with_collapse_helper(ckey.relation_variable){|h| h.candidate_key(ckey)}
            end

            # Collapses a foreign key
            def collapse_foreign_key(fkey)
              with_collapse_helper(fkey.relation_variable){|h| h.foreign_key(fkey)}
            end

            # Collapses an attribute
            def collapse_attribute(attribute)
              with_collapse_helper(attribute.relation_variable){|h| h.attribute(attribute)}
            end

            # Collapses an index
            def collapse_index(index)
              with_collapse_helper(index.indexed_relvar){|h| h.index(index)}
            end

            ############################################################################
            ### Expand algorithms (for alter/create)
            ############################################################################

            # Yields the block with an helper to expand a relation
            # variable, creating it if required
            def with_expand_helper(rv)
              if h = helpers[rv]
                yield(h)
              else
                h = helpers[rv] = Stage::ExpandHelper.new(self, rv)
                yield(h)
                operations.push(*h.flush)
                helpers.delete(rv)
              end
            end
  
            # Ensures existence of a list of schema objects.
            def expand_objects(schema_objects)
              schema_objects.each do |object| 
                case s = object.status
                  when Status::TO_CREATE, Status::TO_ALTER
                    expand_object(object)
                  when Status::NO_CHANGE, Status::CREATED
                    # nothing do to
                  else
                    msg = "Unexpected status #{s} for #{object} for schema expansion"
                    raise AssumptionFailedError, msg
                end
              end
            end
        
            # Ensures existence of a single schema object
            def expand_object(object)
              parent = object.parent

              if parent.status == Status::TO_CREATE
                #
                # Delegate to parent if it needs to be ensured itself
                #
                # Making this helps issuing a single CREATE TABLE instead of 
                # many ALTER TABLE statements, which are not always supported
                # by adapters.
                #
                expand_object(parent)
              else
                # Mark the object as being currently created
                object.status = Status::PENDING
      
                # ensure dependencies
                expand_objects(object.outside_dependencies)
      
                # ensure itself and recurse on children
                expand_call = :"expand_#{object.builder_handler}"
                if object.composite?
                  # ensure composite objects
                  if self.respond_to?(expand_call)
                    self.send(expand_call, object){ expand_objects(object.parts) }
                  else
                    expand_objects(object.parts)
                  end
                else
                  # ensure part objects
                  self.send(expand_call, object)
                end

                # mark object as ensured!
                object.status = Status::CREATED
              end
            end
  
            ### Composites
  
            def expand_relvar_xxx(xxx)
              with_expand_helper(rv = xxx.relation_variable){|helper| yield}
            end
            alias :expand_relvar :expand_relvar_xxx
            alias :expand_heading :expand_relvar_xxx
  
            ### Parts

            def expand_attribute(attribute)
              with_expand_helper(rv = attribute.relation_variable){|helper|
                helper.attribute(attribute)
              }
            end

            def expand_candidate_key(ckey)
              with_expand_helper(rv = ckey.relation_variable){|helper|
                helper.candidate_key(ckey)
              }
            end

            def expand_foreign_key(fkey)
              with_expand_helper(rv = fkey.relation_variable){|helper|
                helper.foreign_key(fkey)
              }
            end

            def expand_index(index)
              with_expand_helper(rv = index.indexed_relvar){|helper|
                helper.index(index)
              }
            end

          end # class Stager
        end # module Stage
      end # module Computations
    end # module Schema
  end # module Core
end # module DbAgile
