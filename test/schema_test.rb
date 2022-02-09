require "test_helper"

class SchemaTest < Minitest::Spec
  Instance = Class.new do
    extend Trailblazer::Declarative::Schema::State
    extend Trailblazer::Declarative::Schema::State::Inherited

    initialize_state!("reform/properties" => [Array.new, {}])
  end

    # we want a "normalizer" pipe per DSL call (e.g. `step` or `property`)
    # we want "immutable" inheritance
  it "what" do
    song = Class.new do # Reform::Form
      extend Trailblazer::Declarative::Schema::State
      extend Trailblazer::Declarative::Schema::State::Inherited
      # THIS we only want once?
      initialize_state!(
        "artifact/deserializer" => [Hash.new, {}],
        "artifact/hydrate"      => [Array.new, {}],
      )

      # alternatively, call state.add!("artifact/deserializer")
      state.add!(:sequence, Instance, copy: Trailblazer::Declarative::State.method(:subclass))
    end

    assert_equal song.state.get("artifact/deserializer").inspect, %{{}}
    assert_equal song.state.get("artifact/hydrate").inspect, %{[]}
    assert_equal song.state.get(:sequence).inspect, %{SchemaTest::Instance}

    hit = Class.new(song) do
      state.update!(:sequence) { |instance| instance.state.update!("reform/properties") { |ary| ary << 99; ary }; instance }
    end

    banger = Class.new(hit) do
  ## mutate field, it should not bleed through to other classes.
      state.update!("artifact/hydrate") { |ary| ary << 1}
      state.update!(:sequence) { |instance| instance.state.update!("reform/properties") { |ary| ary << 999; ary }; instance }
    end


    assert_equal song.state.get("artifact/deserializer").inspect, %{{}}
    assert_equal song.state.get("artifact/hydrate").inspect, %{[]}
    assert_equal song.state.get(:sequence).state.get("reform/properties").inspect, %{[]}

    assert_equal hit.state.get("artifact/deserializer").inspect, %{{}}
    assert_equal hit.state.get("artifact/hydrate").inspect, %{[]}
    assert_equal hit.state.get(:sequence).state.get("reform/properties").inspect, %{[99]}

    assert_equal banger.state.get("artifact/deserializer").inspect, %{{}}
    assert_equal banger.state.get("artifact/hydrate").inspect, %{[1]}
    assert_equal banger.state.get(:sequence).state.get("reform/properties").inspect, %{[99, 999]}
  end

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

end
