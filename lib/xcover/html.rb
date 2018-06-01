require 'erb'
require 'fileutils'

module Xcover
  class Html < Base
    def generate
      Dir.mkdir(output_dir) unless Dir.exist?(output_dir)

      export_image_assets
      export_report_page
    end

    private

    def export_image_assets
      FileUtils.cp_r("#{__dir__}/templates/images/", output_dir)
    end

    def export_report_page
      report = ERB.new(File.read("#{__dir__}/templates/html.erb")).result(binding)

      File.open(File.expand_path('index.html', Dir.open(output_dir)), 'w+') do |f|
        f.write report
      end
    end
  end
end
