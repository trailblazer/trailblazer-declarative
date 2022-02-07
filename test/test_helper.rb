$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "trailblazer/declarative"

require "minitest/autorun"

Minitest::Spec.class_eval do
  def assert_equal(asserted, expected)
    super(expected, asserted)
  end
end
