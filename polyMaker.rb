require 'nokogiri'

coords = []
genDIR = 'generated'
coordDIR = 'coordinates'

file = 'coords.txt'

def init() do 
    initDir
end

def initDir() do
    if !File.directory?(genDIR)
        Dir.mkdir genDIR
    end
    if !File.directory?(coordDIR)
        Dir.mkdir coordDIR
    end
end

/Dir.foreach('/path/to/dir') do |item|
  next if item == '.' or item == '..'
  # do work on real items
end/

a = []
File.readlines(file).each do |line|
    if line == "\n"
        if !a.empty?
            a.push a[0]
            coords.push a
            a = []
        end
    else
        a.push line
    end
end

if !a.empty?
    a.push a[0]
    coords.push a
end

xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') { |xml| 
    xml.kml :xmlns => "http://www.opengis.net/kml/2.2" do
        xml.Document do
            xml.Style :id =>"transGreen" do
                xml.LineStyle do
                    xml.color '#DD1CACE8'
                    xml.width "2.5"
                end
                xml.PolyStyle do
                    xml.color '#5557FF2B'
                end
            end
            coords.each_with_index do |set, index|
                #placemark begin 
                xml.Placemark do
                    xml.styleUrl '#transGreen'
                    xml.name "crown #{index}"
                    xml.Polygon do
                        xml.extrude "1"
                        xml.altitudeMode "clampToGround"
                        xml.outerBoundaryIs do
                            xml.LinearRing do
                                xml.coordinates set.join
                            end
                        end
                    end
                end
                #placemark end
            end
        end
    end
}.to_xml

File.open("generated/new_gen.kml", 'w') { |file| file.write(xml) }