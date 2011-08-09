require 'uri'
require 'curb'
require 'RMagick'


def getYamImage(yamid, filename, imagename)
  
  uri = URI.parse(imagename)
  if uri.path.include?('.')
    extension = uri.path.reverse.split('.')[0].reverse
    if extension.downcase.eql?('png') || extension.downcase.eql?('gif') || 
      extension.downcase.eql?('bmp') || extension.downcase.eql?('jpeg') || 
      extension.downcase.eql?('jpg')
      
      filedown = "#{$YAM_IMG_PATH}/#{yamid}.#{extension}"
      file = open(filedown, "wb")
      c = Curl::Easy.new
      c.url = imagename
      c.verbose = false
      begin
        c.perform
        file.write(c.body_str)
      rescue
        puts "Curb ERROR: %d Filename %s - %s" % [yamid, filedown, imagename]
      end
      file.close
      
      if File.zero?(filedown)
        return nil
      else
        image = Magick::Image.read(filedown).first
        image.crop_resized!(48, 48, Magick::NorthGravity)
        image.write(filename)
        return filename
      end
      
    end
  else
    puts "Yammer ERROR: %d No valid ext in %s" % [yamid, imagename]
    return nil
  end
  
end