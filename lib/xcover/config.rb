module Xcover
  class Config < ::SimpleDelegator
    def initialize(config_file_path)
      super YAML.load_file(config_file_path)
    end

    def target_name
      self['target_name']
    end

    def derived_data_dir
      self['derived_data_directory']
    end

    def output_dir
      self['output_directory']
    end

    def ignored_patterns
      self['ignore']
    end
  end
end

