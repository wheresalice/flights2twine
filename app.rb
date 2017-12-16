require 'sinatra'
require 'tempfile'
require './lib/generate'

class App < Sinatra::Base
  get '/' do
    erb :home
  end

  post '/generate' do
    @filename = params[:file][:filename]
    file = params[:file][:tempfile]
    html = generate(file)
    output_file = Tempfile.new(['openflights', '.csv'])
    output_file.write(html)
    output_file_name = output_file.path
    output_file.close
    send_file(output_file_name, :disposition => 'attachment', :filename => output_file_name)
  end
end