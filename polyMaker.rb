require 'nokogiri'

@coordSets = []
@genDIR = './generated/'
@coordDIR = './coordinates/'

def initDir
    if !File.directory?(@genDIR)
        Dir.mkdir @genDIR
    end
    if !File.directory?(@coordDIR)
        Dir.mkdir @coordDIR
    end
end

def readCoords 
    Dir.foreach(@coordDIR) do |file|
        next if file == '.' or file == '..'
        set = []
        File.readlines(@coordDIR + file).each do |line|
            set.push line
        end
        if !set.empty?
            set.push set[0]
            @coordSets.push set
        end
    end
end

def buildKML
    builtKML = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') { |xml| 
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
                @coordSets.each_with_index do |set, index|
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

    File.open(@genDIR + "new_gen.kml", 'w') { |file| file.write(builtKML) }
end

def init  
    initDir
    readCoords
end

init
buildKML

