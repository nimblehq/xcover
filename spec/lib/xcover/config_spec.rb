describe Xcover::Config do
  describe '#target_name' do
    it 'returns a target name configuration' do
      configuration = described_class.new('spec/fixtures/xcover.yml')

      expect(configuration.send('target_name')).to eq mocked_configuration['target_name']
    end
  end

  describe '#derived_data_dir' do
    it 'returns a derived data directory configuration' do
      configuration = described_class.new('spec/fixtures/xcover.yml')

      expect(configuration.send('derived_data_dir')).to eq "#{mocked_configuration['derived_data_directory']}/Logs/Test/*.xccovreport"
    end
  end

  describe '#output_dir' do
    it 'returns a output directory configuration' do
      configuration = described_class.new('spec/fixtures/xcover.yml')

      expect(configuration.send('output_dir')).to eq mocked_configuration['output_directory']
    end
  end

  private

  def mocked_configuration
    YAML.load_file('spec/fixtures/xcover.yml')
  end
end

