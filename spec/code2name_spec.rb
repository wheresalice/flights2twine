require './lib/generate'
require 'rspec'

describe 'code2airport' do

  it 'should return an airport name' do

    expect(code2airport('CDG')).to eq('Charles De Gaulle')
  end
end