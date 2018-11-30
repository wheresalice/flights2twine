require './lib/generate'
require 'rspec'

describe 'code2airport' do

  it 'should return an airport name' do
    airport = code2airport('CDG')
    expect(airport[1]).to eq('Charles de Gaulle International Airport')
    expect(airport[2]).to eq('Paris')
  end
end