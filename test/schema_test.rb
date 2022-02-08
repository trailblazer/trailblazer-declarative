require "test_helper"

class SchemaTest < Minitest::Spec
    # we want a "normalizer" pipe per DSL call (e.g. `step` or `property`)
    # we want "immutable" inheritance
  it "lowest, most primitive API" do

=begin

dup:
  defaults: {property: {a: 1}}
  my_data: "api-key"
  arbitrary_bullshit: {...}
copy:
  sequence: [...]
forget/private/artifacts:
  parser: {
    activity: <compiled activity>
  }
  hydrate: {
    activity: <also compiled from property calls>
  }
  (in Railway, this would be :activity)
record:
  [
    "property :bla, inherit: true, ..."
  ]


# this happens when State is copied.
  def initialize(..)
    [:private][:parser] = Class.new(Railway) { extend(Call) }

inherit:
  {old options}.merge(new options)
  then run Normalizer
=end

    # twin = Class.new do
    twin = Trailblazer::Declarative.Schema do
      update_state!(:parser, {type: Object})
      update_state!(:hydrate, {type: Module})

      # property :title # here, we want to create three different fields in state

      # property :title, inherit: true # copy over old config, where to default? and how to extend, say, taskWrap :extensions?

      class << self
        def _state; @state; end
      end
    end

    assert_equal twin._state.to_h.inspect, %{{:parser=>{:type=>Object}, :hydrate=>{:type=>Module}}}

    hit_twin = Class.new(twin) do
      update_state!(:hydrate, {type: Class})
    end

  ## original state is still the same
    assert_equal twin._state.to_h.inspect, %{{:parser=>{:type=>Object}, :hydrate=>{:type=>Module}}}
  ## new state is changed
    assert_equal hit_twin._state.to_h.inspect, %{{:parser=>{:type=>Object}, :hydrate=>{:type=>Class}}}
  end
end
