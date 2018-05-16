require 'erb'

module Xcover
  class Html < Base
    def generate
      Dir.mkdir(output_dir) unless Dir.exist?(output_dir)

      report = ERB.new(File.read("#{__dir__}/templates/html.erb")).result(binding)
      File.open(File.expand_path('index.html', Dir.open(output_dir)), 'w+') do |f|
        f.write report
      end
    end
  end
end
