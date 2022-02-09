module Trailblazer
  module Declarative
    def self.Schema(&block)
      Class.new do
        extend Trailblazer::Declarative::Schema
        instance_exec(&block)
      end
    end
    # Include this to maintain inheritable, nested schemas with ::defaults and
    # ::feature the way we have it in Representable, Reform, and Disposable.
    #
    # The schema with its defnitions will be kept in ::definitions.
    #
    # Requirements to includer: ::default_nested_class, override building with ::nested_builder.
    module Schema
      def self.extended(extender)
        extender.extend DSL                 # ::property
        # extender.extend Feature             # ::feature
        # extender.extend Heritage::DSL       # ::heritage
        # extender.extend Heritage::Inherited # ::included

        extender.initialize_state!() # replaces {@definitions ||= Definitions.new(definition_class)}
      end


      # class << self
      # end

      module DSL
        # def initialize_state!()
        #   @state = State.new
        # end

        # # @return State
        # def update_state!(key, value)
        #   @state = @state.merge(key => value)
        # end

        def property(name, options={}, &block)
          # heritage.record(:property, name, options, &block)

          # build_definition(name, options, &block)
        end
      end

      module State
        def initialize_state!(tuples)
          @state = Declarative.State(tuples)
        end

        def state
          @state
        end

        module Inherited
          # DISCUSS: this is *not* a class method and will not be executed when extended the first time.
          def inherited(subclass)
            super

            inherited_fields = state.copy_fields(subclass: subclass)

            subclass.initialize_state!(inherited_fields) # TODO: discuss, should this be done "in" the subclass rather than here?
          end
        end
      end # Schema::State
    end # Schema

  end
end
