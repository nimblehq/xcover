require 'erb'
require 'fileutils'

module Xcover
  class Html < Base
    def generate
      FileUtils.mkdir_p(output_dir) unless Dir.exist?(output_dir)

      export_report_page
      export_assets
    end

    private

    def export_assets
      logo_file_path = File.expand_path(current_working_dir, display_logo)
      FileUtils.cp(logo_file_path, output_dir) if display_logo && File.exist?(display_logo)
      FileUtils.cp("#{__dir__}/templates/styles.css", output_dir)
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
