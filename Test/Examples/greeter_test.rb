#Thanks to Ted Milken for updating the original example
require 'test/unit'
require_relative '../test_helper'

class Person
  attr_accessor :name
  attr_accessor :greeting
end

class GreeterTest < Test::Unit::TestCase
  def test_greet
    Context.generate_dependency_graph = true
    Context.generate_code = true
    ctx = Context.define :Greet_Someone do
      role :greeter do
        def welcome
          greeter.greeting
        end
      end

      role :greeted do
      end

      def greet
        greeter.name.to_s + ': ' + greeter.welcome.to_s + ' ' + greeted.name.to_s + '!'
      end

      def initialize(greeter, greeted)
        @greeter = greeter
        @greeted = greeted
      end
    end

    p1 = Person.new
    p1.name = 'Bob'
    p1.greeting = 'Hello'

    p2 = Person.new
    p2.name = 'World'
    p2.greeting = 'Greetings'

    res = Greet_Someone.new(p1, p2).greet
    assert_equal("Bob: Hello World!",res)
    puts ""
    p ctx.dependencies.to_dot
  end

end
