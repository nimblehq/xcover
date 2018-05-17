describe Xcover::Html do
  describe '#generate' do
    it 'generates a index.html file' do
      allow_any_instance_of(described_class).to receive(:raw_report).and_return(mocked_raw_report)
      described_class.new('spec/fixtures/xcover.yml').generate

      expect(File.exist?("#{mocked_configuration['output_directory']}/index.html")).to be true
    end
  end

  private

  def mocked_configuration
    YAML.load_file('spec/fixtures/xcover.yml')
  end

  def mocked_raw_report
    JSON.parse(File.read('spec/fixtures/report.json'))
  end
end
