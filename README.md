# Trailblazer::Declarative


## State

`State` is a minimalistic state handling object, similar to a hash with
additional "inheritance" logic via `State#copy`. Every field in `state`
can have a specific copying strategy, ranging from simply referencing the
original object to subclassing.

```ruby
state = Declarative.State(key: ["value", ...])
state.add!
state.update!
state.get
state.copy # inheritance
```

