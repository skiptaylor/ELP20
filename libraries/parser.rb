class Parse


# Parses URL response into a variable

  def self.simple(url)
    Net::HTTP.get_response(URI.parse(url)).body
  end


# Trims the response from self.simple
  
  def self.string(url)
    self.simple(url).chop.reverse.chop.reverse
  end
  
  
 # Parses json response into a Ruby array
  
  def self.json(url)
    JSON.parse self.simple(url)
  end
  
  
 # Parses xml response into a Ruby array
  
  def self.xml(url)
    XmlSimple.xml_in self.simple(url)
  end
  
  
end
