require 'erb'

module Xcover
  class Html < Base
    def generate
      dir = Dir.exist?(output_dir) ? Dir.open(output_dir) : Dir.mkdir(output_dir)

      report = ERB.new(File.read("#{__dir__}/templates/html.erb")).result(binding)
      File.open(File.expand_path('index.html', dir), 'w+') do |f|
        f.write report
      end
    end
  end
end
