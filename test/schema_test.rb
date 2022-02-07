require "test_helper"

class SchemaTest < Minitest::Spec
  it "what" do
    # we want a "normalizer" pipe per DSL call (e.g. `step` or `property`)
    # we want "immutable" inheritance

    twin = Class.new do
      extend Trailblazer::Declarative::Schema

      update_state!(:parser, {type: Object})
      update_state!(:hydrate, {type: Module})

      # property :title # here, we want to create three different fields in state

      # property :title, inherit: true # copy over old config, where to default? and how to extend, say, taskWrap :extensions?

      class << self
        def _state; @state; end
      end
    end

    assert_equal twin._state.to_h.inspect, %{{:parser=>{:type=>Object}, :hydrate=>{:type=>Module}}}


  end
end
