require 'erb'
require 'fileutils'
require 'uri'
require "open-uri"

module Xcover
  class Html < Base
    def generate
      Dir.mkdir(output_dir) unless Dir.exist?(output_dir)

      export_report_page
      export_assets
    end

    private

    def export_assets
      FileUtils.cp("#{__dir__}/templates/styles.css", output_dir)
      FileUtils.cp_r("#{__dir__}/templates/images/", output_dir)

      logo_file_path = "#{output_dir}/logo.png"

      if File.exist?(display_logo)
        FileUtils.cp(display_logo, logo_file_path)
      elsif display_logo =~ URI::regexp
        download_image(display_logo, logo_file_path)
      end
    end

    def export_report_page
      report = ERB.new(File.read("#{__dir__}/templates/html.erb")).result(binding)

      File.open(File.expand_path('index.html', Dir.open(output_dir)), 'w+') do |f|
        f.write report
      end
    end

    def download_image(url, dest)
      open(url) do |u|
        File.open(dest, 'wb') { |f| f.write(u.read) }
      end
    end
  end
end
