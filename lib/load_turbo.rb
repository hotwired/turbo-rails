require "zeitwerk"

root = "#{__dir__}/turbo"

loader = Zeitwerk::Loader.new

loader.push_dir(root, namespace: Turbo)
loader.collapse("#{root}/controllers")
loader.collapse("#{root}/helpers")
loader.collapse("#{root}/models")
loader.ignore("#{root}/test")
loader.inflector.inflect("version" => "VERSION")

loader.setup
loader.eager_load
