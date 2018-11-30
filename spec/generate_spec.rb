require './lib/generate'
require 'rspec'
require 'tempfile'

describe 'generate' do
  before(:all) do
    file = Tempfile.new('openflights')
    @path = file.path
    file.puts('Date,From,To,Flight_Number,Airline,Distance,Duration,Seat,Seat_Type,Class,Reason,Plane,Registration,Trip,Note,From_OID,To_OID,Airline_OID,Plane_OID')
    file.puts('2013-04-08 10:05:00,MAN,LHR,BA1389,British Airways,150,01:00,,,Y,B,AIRBUS A320-100/200,,,"",478,507,1355')
    file.close
    @html = generate(@path, 'MAN')
  end

  after(:all) do
    File.unlink(@path)
  end

  describe 'generate' do
    it 'should have a startnode' do
      expect(@html).to include('startnode="1"')
    end

    it 'should generate a passage for the start airport' do
      # <tw-passagedata pid="#{index+1}" name="#{airport}" tags="" position="#{index*50}, #{index*50}">
      expect(@html).to include('name="MAN"')
    end

    it 'should generate a passage for the end airport' do
      # <tw-passagedata pid="#{index+1}" name="#{airport}" tags="" position="#{index*50}, #{index*50}">
      expect(@html).to include('name="LHR"')
    end

    it 'should list flights from the airport' do
      # Flights from #{code2airport(airport)[1]}
      expect(@html).to include('Flights from Manchester')
      expect(@html).to include('Flights from London Heathrow')
    end
  end
end