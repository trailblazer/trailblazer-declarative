require "test_helper"

class StateTest < Minitest::Spec
  let(:declarative) { Trailblazer::Declarative }

  # DISCUSS: does State have to be immutable? I imagine it being very slow, and it might not be necessary.
  it "mutable API" do
    state = declarative.State() # TODO: how to initialize certain fields?

    # state.record!(%{property/:validate/{id: "my_validate"}}, :property, positionals: [:validate], keywords: {id: "my_validate"})
    # state.record!(:defaults, keywords: {prefix: "_"})

    # copy
    state.set!(:sequence, [1,2])
    state.set!(:nodes, {"my_validate" => 1})

    # if you don't want to replay it, set it.
    state.set!("property/:validate/{id: \"my_validate\"}", [:property, {positionals: [:validate], keywords: {id: "my_validate"}}])
    assert_equal state.get("property/:validate/{id: \"my_validate\"}").inspect, %{[:property, {:positionals=>[:validate], :keywords=>{:id=>\"my_validate\"}}]}




    # state.record("property/:validate/{id: \"my_validate\"}")


    # property :validate, id: "my_validate", In() => [:params]
      # 0. get normalizer
      # 1. run normalizer until we got an ID
      # 2. state.record!("property/:validate/{id: \"my_validate\"}") # this is what we call "native DSL options"
      # 3. rest of normalizer
      # 4. compile sequence or activities
      # 5. create a DSL artifact via `state.set!(sequence: ...)`

    # property :my_validate, inherit: "my_validate"
      # 0. retrieve property/:validate/{id: \"my_validate\"}" *native* DSL options
      # 0. merge those with user options
      # 1. get normalizer
      # 2... see above
  end

  it "initialize" do
    deserializer = Array.new
    original_deserializer_id = deserializer.object_id

    state = declarative.State("artifact/deserializer/activity" => [deserializer, copy: declarative::State.method(:dup)]) # TODO: how to initialize certain fields?

    # copy
    state.add!(:sequence, [1,2])
    # TODO: {inherit: :self} etc

    state.update!("artifact/deserializer/activity") do |value, **|
      value + [2,3] # DISCUSS: this is using the immutable way, but it's up to the user.
    end

    updated_deserializer = state.get("artifact/deserializer/activity")
    assert_equal updated_deserializer.inspect, %{[2, 3]}
  ## two different objects
    refute_equal deserializer, updated_deserializer

  #~ {#copy}
    new_state = state.copy # TODO: test {inheriter: inherited} for replay
    #= new_state is a copy of original state
    assert_equal new_state.get("artifact/deserializer/activity").inspect, %{[2, 3]}
    assert_equal new_state.get(:sequence).inspect, %{[1, 2]}


    state.update!("artifact/deserializer/activity") do |value, **| value + [4,5] end
    new_state.update!("artifact/deserializer/activity") do |value, **| value + [4,5,6] end

  #= no leakage
    assert_equal state.get("artifact/deserializer/activity").inspect, %{[2, 3, 4, 5]}
    assert_equal new_state.get("artifact/deserializer/activity").inspect, %{[2, 3, 4, 5, 6]}
  end
end

# # Files to be loaded/"finalized"
# # create.rb
#   class Create < Trailblazer::Operation
#     step :model
#     step :validate
#     # lot of more DSL
#   end.finalize! # this will mark the OP as "definitions are complete, we're finished, let's compute the actual DSL artifacts"

#   # update.rb
#   class Update < Trailblazer::Operation
#     step :find_model
#     step :validate
#     # lot of more DSL
#   end.finalize!

# # or, with dry-system, we could omit the {.finalize!}

# Dry::System.load("create.rb", "update.rb", call_finalize_on_each_loaded_component: true) # pseudo-code.
