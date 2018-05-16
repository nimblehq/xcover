describe Xcover::Base do
  subject { described_class.new('spec/fixtures/xcover.yml') }

  describe '#processed_report_files' do
    it 'returns all filtered files with assigned line coverage percentage' do
      config = instance_double(Xcover::Config)
      allow(Xcover::Config).to receive(:new).and_return(config)
      allow(config).to receive(:ignored_patterns).and_return(['*Model.*'])
      allow_any_instance_of(subject.class).to receive(:raw_report).and_return(
        {
          "files" => [
            {
              "lineCoverage" => 0.1,
              "path" => 'RedPlanet/Detail/LocalAttractionDetailInfoModel.swift',
              "name" => 'LocalAttractionDetailInfoModel.swift',
            },
            {
              "lineCoverage" => 0.2,
              "path" => 'RedPlanet/Detail/LocalAttractionListModel.swift',
              "name" => 'LocalAttractionListModel.swift',
            },
            {
              "lineCoverage" => 0.3,
              "path" => 'RedPlanet/List/LocalAttractionTableViewCell.swift',
              "name" => 'LocalAttractionTableViewCell.swift',
            }
          ]
        }
      )
      processed_files = subject.send('processed_report_files')

      expect(processed_files.count).to eq 1
      expect(processed_files.first['lineCoveragePercentage']).to eq 30
    end
  end

  describe '#filtered_report_files' do
    context 'directory filtering' do
      it 'ignores all the files in the directory' do
        ignored_patterns = ['*/List/*']
        files = [
          {
            "lineCoverage" => 0,
            "path" => 'RedPlanet/Detail/LocalAttractionDetailInfoModel.swift',
            "name" => 'LocalAttractionDetailInfoModel.swift'
          },
          {
            "lineCoverage" => 0,
            "path" => 'RedPlanet/Detail/LocalAttractionListModel.swift',
            "name" => 'LocalAttractionListModel.swift'
          },
          {
            "lineCoverage" => 0,
            "path" => 'RedPlanet/List/LocalAttractionTableViewCell.swift',
            "name" => 'LocalAttractionTableViewCell.swift'
          }
        ]
        filtered_files = subject.send('filtered_report_files', files, ignored_patterns)

        expect(filtered_files.count).to eq 2
        expect(filtered_files[0]['path']).to eq 'RedPlanet/Detail/LocalAttractionDetailInfoModel.swift'
        expect(filtered_files[1]['path']).to eq 'RedPlanet/Detail/LocalAttractionListModel.swift'
      end
    end

    context 'file extension filtering' do
      it 'ignores all the file with the extension' do
        ignored_patterns = ['*.json']
        files = [
          {
            "lineCoverage" => 0,
            "path" => 'RedPlanet/Detail/LocalAttractionDetailInfoModel.swift',
            "name" => 'LocalAttractionDetailInfoModel.swift'
          },
          {
            "lineCoverage" => 0,
            "path" => 'RedPlanet/Detail/hotel.json',
            "name" => 'hotel.json'
          }
        ]
        filtered_files = subject.send('filtered_report_files', files, ignored_patterns)

        expect(filtered_files.count).to eq 1
        expect(filtered_files[0]['path']).to eq 'RedPlanet/Detail/LocalAttractionDetailInfoModel.swift'
      end
    end

    context 'path and name filtering' do
      it 'ignores the files and directories that is matched with the pattern' do
        ignored_patterns = ['*Attraction*']
        files = [
          {
            "lineCoverage" => 0,
            "path" => 'RedPlanet/Detail/LocalAttractionDetailInfoModel.swift',
            "name" => 'LocalAttractionDetailInfoModel.swift'
          },
          {
            "lineCoverage" => 0,
            "path" => 'RedPlanet/AttractionDetail/LocalAttraction.swift',
            "name" => 'LocalAttraction.swift'
          }
        ]
        filtered_files = subject.send('filtered_report_files', files, ignored_patterns)

        expect(filtered_files.count).to eq 0
      end
    end
  end

  describe '#glob_pattern' do
    it 'adds the proper wildcard to the directory pattern' do
      pattern1 = subject.send('glob_pattern', '/RP')
      pattern2 = subject.send('glob_pattern', 'RP/')
      pattern3 = subject.send('glob_pattern', '/RP/')

      expect(pattern1).to eq '*/RP/*'
      expect(pattern2).to eq '*/RP/*'
      expect(pattern3).to eq '*/RP/*'
    end
  end
end
