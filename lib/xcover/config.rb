module Xcover
  class Config < ::SimpleDelegator
    def initialize(config_file_path)
      super YAML.load_file(config_file_path)
    end

    def target_name
      self['target_name']
    end

    def display_name
      self['display_name'] || target_name
    end

    def display_logo
      self['display_logo']
    end

    def derived_data_dir
      (self['derived_data_directory']).to_s
    end

    def derived_data_dir_log_test
      "#{derived_data_dir}/Logs/Test"
    end

    def output_dir
      self['output_directory']
    end

    def ignored_patterns
      self['ignore']
    end
  end
end
