require 'yaml'
require 'json'

module Xcover
  class Base
    def initialize(config_file_path = 'xcover.yml')
      @config_file_path = config_file_path
      @filtered_files = filtered_files
    end

    def generate
      puts
      puts "Target Name: #{target_name}"
      puts "Code Coverage: #{code_coverage_percentage}%"
      puts '-----------------------------------------'
      filtered_files.map {|file| puts "#{file['name']} #{file['lineCoveragePercentage']}%"}
      puts

      true
    end

    private

    attr_reader :config_file_path

    def target_name
      config['target_name']
    end

    def derived_data_directory
      config['derived_data_directory']
    end

    def output_dir
      config['output_directory']
    end

    def code_coverage_percentage
      "#{code_coverage.round(2)}%"
    end

    def code_coverage
      total_covered_lines.to_f / total_executable_lines * 100
    end

    def total_covered_lines
      filtered_files.inject(0) {|sum, file| sum + file['coveredLines']}
    end

    def total_executable_lines
      filtered_files.inject(0) {|sum, file| sum + file['executableLines']}
    end

    def filtered_files
      files = raw_report['files']

      ignored_patterns.each do |pattern|
        files.reject! {|file| File.fnmatch(pattern, file['path'])}
      end

      files.map { |file| file['lineCoveragePercentage'] = (file['lineCoverage'] * 100).round(2) }
      files
    end

    def ignored_patterns
      @ignored_patterns ||= config['ignore']&.map {|pattern| pattern.end_with?('/') ? "*#{pattern}*" : pattern} || []
    end

    def config
      @config ||= OpenStruct.new(YAML.load_file(config_file_path))
    end

    def raw_report
      report_result = %x(xcrun xccov view --files-for-target "#{target_name}" #{derived_data_directory} --json)
      @raw_report ||= JSON.parse(report_result)
    end
  end
end
