require './yam_config.rb'
require './lib/yam_database.rb'
require './lib/yam_getUserPhoto.rb'

def downloadPhotos(limit, offset)

  #----------------------------------------------------------------------------#
  # Download User Photos using the mugshot_url                                 #
  #----------------------------------------------------------------------------#
  cnt = 0
  users = Yuser.find :all, :limit =>  limit, :offset => offset
  puts "Downloading %d photos ..." % users.length
  users.each do |user|
    filename = "#{$YAM_IMG_PATH}/#{user.yamid}.jpg"
    unless File.exists?(filename)
      2.times do 
        if getYamImage(user.yamid, filename, user.mugshot_url).nil?
          File.delete(filename) if File.exists?(filename)
          sleep(1)
          puts "retry ..."
        else
          break
        end
      end
    end
  end
  return cnt

end

def genGraphviz(part, limit, offset)

  #----------------------------------------------------------------------------#
  # Generate a Graphviz .gv file                                               #
  #----------------------------------------------------------------------------#
  gv_name = "#{$YAM_GRAPH_PATH}/userwall_patchwork_p#{part}.gv"
  gv_start = "graph g {\n  size=\"11,11\";\n  ratio=\"fill\";\n  rankdir=\"LR\";\n\n"
  gv_end = "\n}"
  fgv = File.open(gv_name, 'w')
  fgv.write gv_start
  users = Yuser.find :all, :limit => limit, :offset => offset
  users.each do |user|
    imgfile = "#{$YAM_IMG_PATH}/#{user.yamid}.jpg"
    if File.exists?(imgfile)
      fgv.write "  #{user.yamid} [label=\"\", shape=\"box\", width=.3, height=.3, image=\"#{imgfile}\"];\n"
    else
      puts "%d missing" % user.yamid
    end
  end
  fgv.write gv_end
  fgv.close
  puts "GV File '#{gv_name}' created."

  #----------------------------------------------------------------------------#
  # Run Graphviz osage Layout                                                  #
  #----------------------------------------------------------------------------#
  png_name = gv_name.gsub('.gv', "_osage.png")
  cmdline = "osage -Tpng -o #{png_name} #{gv_name}"
  system(cmdline)
  puts "PNG file is '#{png_name}'"

end


#------------------------------------------------------------------------------#
# Yammer User Photos                                                           #
#------------------------------------------------------------------------------#
t0 = Time.new
activerecord_connect
puts "User Count: %d" % Yuser.count

part = 0      # add 1 for the next part
limit = 2000  # modify what you like
offset = 0 + part * limit
downloadPhotos(limit, offset)
genGraphviz(part, limit, offset)

t1 = Time.new
puts "Duration %.4f sec." % [t1 - t0]
