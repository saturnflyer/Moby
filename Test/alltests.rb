`git ls-files`.split($/).grep(%r{(test|spec|features).rb}).select { |f| p f; require_relative("../#{f}") }
