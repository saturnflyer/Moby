`git ls-files`.split($/).grep(%r{(test|spec|features).rb}).select {|f| require_relative("../#{f}")}

#require_relative 'Greeter_test'