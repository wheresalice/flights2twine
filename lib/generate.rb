require 'csv'

def generate(input_file)

# @TODO: Enrich with airport names
  flights = CSV.read(input_file, {:headers => true})
  airports = flights.map{|flight| [flight['From'], flight['To']]}.flatten.uniq
  routes = flights.map{|flight| {'From' => flight['From'], 'To' => flight['To']}}.uniq

  html = <<-EOF
<tw-storydata name="Open Flights" startnode="1" creator="Twine" creator-version="2.1.3" ifid="DC223103-5C2D-4D5B-9A3C-2CF548DBB8FF" format="Harlowe" format-version="2.0.1" options="" hidden><style role="stylesheet" id="twine-user-stylesheet" type="text/twine-css">
</style><script role="script" id="twine-user-script" type="text/twine-javascript">
</script>
  EOF

  airports.each_with_index do |airport, index|
    destinations = routes.select{|route| route['From'] == airport}.map{|route| "<li>[[#{route['To']}]]</li>"}.join("\n")
    html << <<-EOF
<tw-passagedata pid="#{index+1}" name="#{airport}" tags="" position="#{index*50}, #{index*50}">
Flights from #{airport}
<ul>
#{destinations}
</ul>
</tw-passagedata>
    EOF
  end

  html << <<-EOF
</tw-storydata>
  EOF

# @TODO write to arbitrary file
  return html
end