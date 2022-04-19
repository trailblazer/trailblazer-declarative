module Trailblazer
  module Declarative
    # Class-wide configuration data
    def self.State(tuples={})
      state = State.new
      tuples.each { |path, (value, options)| state.add!(path, value, **options) }
      state
    end

    class State # FIXME: who is providing the immutable API?
      def self.dup(value, **) # DISCUSS: should that be here?
        value.dup
      end

      def self.subclass(value, **)
        Class.new(value)
      end

      def initialize
        @fields        = {}
        @field_options = {}
      end

      def add!(path, value, copy: State.method(:dup))
        @fields[path]        = value
        @field_options[path] = {copy: copy}
        self
      end

      # Tries to retrieve {path}, if it exists {block} is called
      # and receives the old value.
      # The return value of the block will be the new value.
      def update!(path, &block)
        value = get(path)
        new_value = yield(value, **{})
        set!(path, new_value)
      end

      def get(path)
        @fields.fetch(path)
      end

      # @private
      def set!(path, value)
        @fields[path] = value
      end

      def copy_fields(**options)
        @fields.collect do |path, value|
          path_options = @field_options.fetch(path)
          inherited_value = path_options.fetch(:copy).(value, **options)

          [path, [inherited_value, path_options]]
        end.to_h
      end

      # DISCUSS: do we need it?
      def copy(**options) # DISCUSS: make class method?
        inherited_fields = copy_fields(**options)

        Declarative.State(inherited_fields)
      end
    end # State
  end
end
