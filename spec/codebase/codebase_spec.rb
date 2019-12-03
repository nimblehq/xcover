describe 'Codebase', codebase: true do
  it 'does not offend Rubocop' do
    expect(`rubocop --format simple`).to include 'no offenses detected'
  end
end
