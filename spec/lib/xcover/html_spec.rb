describe Xcover::Html do
  describe '#build_report' do
    it 'generates a index.html file' do
      allow_any_instance_of(described_class).to receive(:raw_report).and_return(mocked_raw_report)
      described_class.new('spec/fixtures/xcover.yml').build_report

      output_dir = mocked_configuration['output_directory']
      expect(File.exist?("#{output_dir}/index.html")).to be true
      expect(File.exist?("#{output_dir}/styles.css")).to be true
      expect(Dir.exist?("#{output_dir}/images")).to be true
      expect(Dir["#{output_dir}/images"].length).to eq Dir['lib/xcover/templates/images'].length
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
