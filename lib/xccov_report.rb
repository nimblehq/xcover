require 'yaml'
require 'json'

class XccovReport
  def initialize(config_file_path = 'xccov_report.yml')
    @config_file_path = config_file_path
    @filtered_files = filtered_files
  end

  def print
    puts ''
    puts "Target Name: #{config['target_name']}"
    puts "Code Coverage: #{code_coverage.round(2)}%"
    puts '-----------------------------------------'
    filtered_files.map { |file| puts "#{file['name']} #{file['lineCoverage']}"}
    puts ''

    true
  end

  private

  attr_reader :config_file_path

  def code_coverage
    total_covered_lines.to_f / total_executable_lines * 100
  end

  def total_covered_lines
    filtered_files.inject(0) { |sum, file| sum + file['coveredLines'] }
  end

  def total_executable_lines
    filtered_files.inject(0) { |sum, file| sum + file['executableLines'] }
  end

  def filtered_files
    files = raw_report['files']

    ignored_patterns.each do |pattern|
      files.reject! { |file| File.fnmatch(pattern, file['path']) }
    end
    files
  end

  def ignored_patterns
    @ignored_patterns ||= config['ignore']&.map { |pattern| pattern.end_with?('/') ? "*#{pattern}*" : pattern } || []
  end

  def config
    @config ||= YAML.load_file(config_file_path)
  end

  def raw_report
    # TODO: Execute xccov and parse the json result here
    @raw_report ||= JSON.parse(File.read('result.json'))
  end
end

