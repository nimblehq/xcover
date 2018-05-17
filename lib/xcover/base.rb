module Xcover
  class Base
    extend Forwardable

    def_delegators :config, :target_name, :derived_data_dir, :output_dir, :ignored_patterns

    def initialize(config_file_path = '.xcover.yml')
      @config = Config.new(config_file_path)
    end

    def generate
      puts
      puts "Target Name: #{target_name}"
      puts "Code Coverage: #{code_coverage_percentage}%"
      puts '-----------------------------------------'
      processed_report_files.map {|file| puts "#{file['name']} #{file['lineCoveragePercentage']}%"}
      puts

      true
    end

    private

    attr_reader :config, :cached_processed_report_files

    def code_coverage_percentage
      (total_covered_lines.to_f / total_executable_lines * 100).round(2)
    end

    def total_covered_lines
      processed_report_files.inject(0) {|sum, file| sum + file['coveredLines']}
    end

    def total_executable_lines
      processed_report_files.inject(0) {|sum, file| sum + file['executableLines']}
    end

    def processed_report_files
      return cached_processed_report_files unless cached_processed_report_files.nil?

      report_files = raw_report.first.fetch('files', [])
      processed_ignored_patterns = ignored_patterns&.map { |pattern| glob_pattern(pattern) }&.uniq || []

      @cached_processed_report_files ||= assign_line_coverage_percentage(filtered_report_files(report_files, processed_ignored_patterns))
    end

    def filtered_report_files(files, ignored_patterns)
      ignored_patterns.each do |pattern|
        files.reject! {|file| File.fnmatch(pattern, file['path'])}
      end

      files
    end

    def assign_line_coverage_percentage(files)
      files.each { |file| file['lineCoveragePercentage'] = (file['lineCoverage'] * 100).round(2) }

      files
    end

    def glob_pattern(pattern)
      return "*#{pattern}*" if pattern.end_with?('/') && pattern.start_with?('/')
      return "*/#{pattern}*" if pattern.end_with?('/')
      return "*#{pattern}/*" if pattern.start_with?('/')

      pattern
    end

    def raw_report
      report_result = %x(xcrun xccov view --files-for-target "#{target_name}" #{derived_data_dir} --json)
      @raw_report ||= JSON.parse(report_result)
    end
  end
end
