#encoding: utf-8
require 'csv'

AIRPORT_DATA = CSV.read(File.join(File.dirname(__FILE__), '..','data','airports.dat'))

def code2airport(code)
  AIRPORT_DATA.find{|airport| airport[4] == code}
end

def generate(input_file, start_node = 'LBA')

  flights = CSV.read(input_file, {:headers => true})
  airports = flights.map{|flight| [flight['From'], flight['To']]}.flatten.uniq

  routes = flights.map{|flight| {'From' => flight['From'], 'To' => flight['To'], 'Distance' => flight['Distance']}}.uniq

  start_node_index = airports.find_index(start_node.upcase).to_i + 1
  html = <<-EOF
<tw-storydata name="Open Flights" startnode="#{start_node_index}" creator="Twine" creator-version="2.1.3" ifid="DC223103-5C2D-4D5B-9A3C-2CF548DBB8FF" format="Harlowe" format-version="2.0.1" options="" hidden><style role="stylesheet" id="twine-user-stylesheet" type="text/twine-css">

.small {
  font-size: 10px;
  font-style: italic;
}


@import url(https://fonts.googleapis.com/css?family=Press+Start+2P);

tw-story {	
  /* The following changes the text */
  color: #3D9970; /* Set text to green or other color */
  text-shadow: 1px 1px #2ECC40; /* Green text shadow */
  font-size: 20px;
  font-family: "Press Start 2P","Helvetica","Arial",sans-serif;
  background: #7FDBFF; /* For old browsers */    
  background: -webkit-linear-gradient(#7FDBFF, #0074D9);
  background: -o-linear-gradient(#7FDBFF, #0074D9);
  background: -moz-linear-gradient(#7FDBFF, #0074D9);
  background: linear-gradient(#7FDBFF, #0074D9);
}

tw-passage {
  /* The following changes the text box */
  border: 5px groove #AAAAAA; /* Gray border around the box */
  border-radius: 25px; /* Rounded corners on the box */
  background: rgba(255,255,255,0.7); /* 30% transparent box */
  padding: 25px;
}

tw-link {
  color:#001f3f; /* Set the link color to darkblue */
  transition: color .5s ease-in-out;
}

tw-link:hover { /* Mouse over a link & it turns orange */
  color: #FF851B;
}

img { /* Images won't get wider than tw-passage container */
  max-width: 100%;
}
</style><script role="script" id="twine-user-script" type="text/twine-javascript">
</script>
  EOF

  airports.each_with_index do |airport, index|
    destinations = routes.select{|route| route['From'] == airport}.map{|route| "<li>(link: \"#{code2airport(route['To'])[1]} (#{route['To']})\")[(set: $visited to $visited + 1)(set: $distance to $distance + #{route['Distance']})(goto: '#{route['To']}')] &lt;span class=&#39;small&#39;&gt;#{code2airport(route['To'])[2]}, #{code2airport(route['To'])[3]}&lt;/span&gt;"}.join("\n")
    html << <<-EOF
<tw-passagedata pid="#{index+1}" name="#{airport}" tags="" position="#{index*50}, #{index*50}">
Flights from #{code2airport(airport)[1]}
&lt;span class=&#39;small&#39;&gt;#{code2airport(airport)[2]}, #{code2airport(airport)[3]} (#{airport})&lt;/span&gt;
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