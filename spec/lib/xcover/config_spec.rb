describe Xcover::Config do
  subject { 'spec/fixtures/xcover.yml' }

  describe '#target_name' do
    it 'returns a target name configuration' do
      configuration = described_class.new(subject)

      expect(configuration.target_name).to eq mocked_configuration(subject)['target_name']
    end
  end

  describe '#derived_data_dir' do
    it 'returns a derived data directory configuration' do
      configuration = described_class.new(subject)

      expect(configuration.derived_data_dir).to eq "#{mocked_configuration(subject)['derived_data_directory']}/Logs/Test/*.xccovreport"
    end
  end

  describe '#output_dir' do
    it 'returns a output directory configuration' do
      configuration = described_class.new(subject)

      expect(configuration.output_dir).to eq mocked_configuration(subject)['output_directory']
    end
  end

  describe '#display_name' do
    it 'returns a display name configuration' do
      configuration = described_class.new(subject)

      expect(configuration.display_name).to eq mocked_configuration(subject)['display_name']
    end
  end

  describe '#display_logo' do
    it 'returns a display logo configuration' do
      configuration = described_class.new(subject)

      expect(configuration.display_logo).to eq mocked_configuration(subject)['display_logo']
    end
  end

  private

  def mocked_configuration(config_file)
    YAML.load_file(config_file)
  end
end
