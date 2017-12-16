require 'csv'

AIRPORT_DATA = CSV.read(File.join(File.dirname(__FILE__), '..','data','airports.dat'))

def code2airport(code)
  AIRPORT_DATA.find{|airport| airport[4] == code}
end

def generate(input_file)

  flights = CSV.read(input_file, {:headers => true})
  airports = flights.map{|flight| [flight['From'], flight['To']]}.flatten.uniq

  routes = flights.map{|flight| {'From' => flight['From'], 'To' => flight['To'], 'Distance' => flight['Distance']}}.uniq

  html = <<-EOF
<tw-storydata name="Open Flights" startnode="1" creator="Twine" creator-version="2.1.3" ifid="DC223103-5C2D-4D5B-9A3C-2CF548DBB8FF" format="Harlowe" format-version="2.0.1" options="" hidden><style role="stylesheet" id="twine-user-stylesheet" type="text/twine-css">
</style><script role="script" id="twine-user-script" type="text/twine-javascript">
</script>
  EOF

  airports.each_with_index do |airport, index|
    destinations = routes.select{|route| route['From'] == airport}.map{|route| "<li>(link: \"#{code2airport(route['To'])[1]}, #{code2airport(route['To'])[2]} #{code2airport(route['To'])[3]} (#{route['To']})\")[(set: $visited to $visited + 1)(set: $distance to $distance + #{route['Distance']})(goto: '#{route['To']}')]"}.join("\n")
    html << <<-EOF
<tw-passagedata pid="#{index+1}" name="#{airport}" tags="" position="#{index*50}, #{index*50}">
Flights from #{code2airport(airport)[1]}, #{code2airport(airport)[2]} #{code2airport(airport)[3]} (#{airport})
<ul>
#{destinations}
</ul>
You have taken $visited flights and traveled $distance miles
</tw-passagedata>
    EOF
  end

  html << <<-EOF
</tw-storydata>
  EOF

  return html
end