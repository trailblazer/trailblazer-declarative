module Trailblazer
  module Declarative
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
        def initialize_state!()
          @state = State.new
        end

        # @return State
        def update_state!(key, value)
          @state = @state.merge(key => value)
        end

        def property(name, options={}, &block)
          # heritage.record(:property, name, options, &block)

          # build_definition(name, options, &block)
        end
      end
    end # Schema

    # Class-wide configuration data
    class State < Hash # FIXME: who is providing the immutable API?

    end
  end
end
