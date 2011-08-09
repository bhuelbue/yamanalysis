require 'date'
require 'optparse'

require './yam_config.rb'
require './lib/yam_database.rb'
require './lib/yam_getUserPhoto.rb'

def shortName(name)

  nname = name
  nname = nname[0, 8] if name.length > 8
  nname = nname.gsub("-", '')
  return nname

end

def writeGraphvizLabelByName(f, name)

  gvlabel = "label=\"\", shape=\"box\", width=.5, height=.5, image="
  users = Yuser.find :all, :select => "yamid, mugshot_url", 
    :conditions => "name = '#{name}'", :limit => 1
  users.each do |user|
    imgfile = "#{$YAM_IMG_PATH}/#{user.yamid}.jpg"
    getYamImage(user.yamid, imgfile, user.mugshot_url) unless File::exists?(imgfile)
    
    nname = shortName(name)
    nnode = "  #{nname} [#{gvlabel}\"#{imgfile}\"];"
    f.write "#{nnode}\n"
  end

end

#------------------------------------------------------------------------------#
# Yesterday's Thread Analysis                                                  #
#------------------------------------------------------------------------------#
date = DateTime.now - 1
dayfrom = date.strftime("%Y-%m-%d")
date = date + 1
dayto = date.strftime("%Y-%m-%d")
OPTIONS = { :dayfrom  => dayfrom, :dayto => dayto }

ARGV.options do |o|
  script_name = File.basename($0)
  o.banner =    "Usage: #{script_name} [OPTIONS]"
  o.define_head "Create Yammer Thread Analysis"
  o.separator   "[-ft] options yyyy-mm-dd"
  o.on("-f", "--from=yyyy-mm-dd", String, "Select the starting date") { |fromdate| OPTIONS[:dayfrom] = fromdate }
  o.on("-t", "--to=yyyy-mm-dd", String, "Select the end date") { |todate| OPTIONS[:dayto] = todate }
  o.on_tail("-h", "--help", "Show this help message.") { puts o; exit }
  o.separator ""
  o.parse!
end

dayfrom = OPTIONS[:dayfrom]
dayto = OPTIONS[:dayto]
puts "Between #{dayfrom} and #{dayto} ..."

#------------------------------------------------------------------------------#
# Connect to the database                                                      #
#------------------------------------------------------------------------------#
t0 = Time.new
activerecord_connect

#------------------------------------------------------------------------------#
# Fetch all thread_id's within a time frame                                    #
#------------------------------------------------------------------------------#
@cntthreads = Hash.new 0
@dailythreads = Ymessage.find :all, :select => "yamid, sender_id, thread_id",
  :conditions => "DATE(created_at) BETWEEN '#{dayfrom}' AND '#{dayto}'",
  :order => 'thread_id DESC'
@dailythreads.each do |m|
  @cntthreads[m.thread_id] += 1
end
puts "%d threads found between %s and %s" % [ @dailythreads.length, dayfrom, dayto ]

#------------------------------------------------------------------------------#
# Fetch all message_id's and sender_id's within each thread_id                 #
#------------------------------------------------------------------------------#
@usr2yamids = Hash.new
@usr2sndids = Hash.new
@dailythreads.each do |m|
  # Global Unique Message Id
  @dailymsgs = Ymessage.find :all, :select => "yamid, sender_id", 
    :conditions => "thread_id = '#{m.thread_id}'"
  @dailymsgs.each do |m|
    usrs = Yuser.find :all, :select => "name", 
      :conditions => "yamid = #{m.sender_id}"
    # Global Unique User Id ?
    usrs.each do |usr|
      @usr2yamids[m.yamid] = usr.name
      @usr2sndids[m.sender_id] = usr.name
    end
  end
end
puts "%d yamids (messages)" % @usr2yamids.length
puts "%d senderids (people)" % @usr2sndids.length

#------------------------------------------------------------------------------#
# Generate edges                                                               #
#------------------------------------------------------------------------------#
@edges = Hash.new
@toyam = Hash.new
@cntthreads.keys.sort.reverse.each do |k| 
  @threadmsgs = Ymessage.find :all, 
    :conditions => "thread_id = '#{k}' AND DATE(created_at) <= '#{dayto}'",
    :order => 'created_at ASC'
  @threadmsgs.each do |t|
    unless @usr2yamids[t.replied_to_id].nil?
      # We have a conversation
      if @usr2sndids[t.sender_id].nil?
        # We have a missing sender_id in the User table
        puts t.inspect
      else
        edge_key = "#{@usr2sndids[t.sender_id]}-#{@usr2yamids[t.replied_to_id]}"
        unless @edges.has_key?(edge_key)
          @edges[edge_key] = "#{@usr2sndids[t.sender_id]} -> #{@usr2yamids[t.replied_to_id]}"
          puts "#{@edges[edge_key]};" if $YAM_VERBOSE
        end
      end
    else
      # Initial Message in Yammer
      if @usr2sndids[t.sender_id].nil?
        # We have a missing sender_id in the User table
        puts t.inspect
      else
        edge_key = "#{@usr2sndids[t.sender_id]}-yammer"
        unless @toyam.has_key?(edge_key)
          @toyam[edge_key] = "#{@usr2sndids[t.sender_id]} -> yammer"
          puts "#{@toyam[edge_key]};" if $YAM_VERBOSE
        end
      end
    end
  end
end
puts "%d initial posts" % @toyam.length
puts "%d relations" % @edges.length

#------------------------------------------------------------------------------#
# Write the Graphviz .gv file                                                  #
#------------------------------------------------------------------------------#
gv_name = "#{$YAM_GRAPH_PATH}/thread_analysis_#{dayfrom}_#{dayto}.gv"
gv_start = "digraph g {\n  size=\"8,8\";\n  ratio=\"fill\";\n  rankdir=\"LR\";\n\n"
gv_end = "\n}"
fgv = File.open(gv_name, 'w')
fgv.write gv_start
@edges.keys.sort.each do |k|
  f = @edges[k].split("->")
  source_name = shortName(f[0].strip)
  target_name = shortName(f[1].strip)
  
  writeGraphvizLabelByName(fgv, f[0].strip)
  writeGraphvizLabelByName(fgv, f[1].strip)
  edge = "  #{source_name} -> #{target_name}"
  fgv.write "#{edge};\n"
end
fgv.write gv_end
fgv.close
puts "GV File '#{gv_name}' created."

#------------------------------------------------------------------------------#
# Run all the Graphviz programs using the generated .gv file                   #
#------------------------------------------------------------------------------#
["dot", "fdp", "sfdp", "twopi", "circo", "neato"].each do |grf|
  pngx = "_#{grf}.png"
  png_name = gv_name.gsub('.gv', pngx)
  cmdline = "#{grf} -Tpng -o #{png_name} #{gv_name}"
  system(cmdline)
  puts "PNG file is '#{png_name}'"
end

#------------------------------------------------------------------------------#
# Write the Cytoscape .txt file                                                #
#------------------------------------------------------------------------------#
cyto_name = "#{$YAM_GRAPH_PATH}/cyto_#{dayfrom}_#{dayto}.txt"
fcyto = File.open(cyto_name, 'w')

@toyam.keys.sort.each do |k|
  f = @toyam[k].split("->")
  source_name = shortName(f[0].strip)
  target_name = shortName(f[1].strip)
  edge = "#{source_name} #{target_name}"
  fcyto.write "#{edge}\n"
end

@edges.keys.sort.each do |k|
  f = @edges[k].split("->")
  source_name = shortName(f[0].strip)
  target_name = shortName(f[1].strip)
  edge = "#{source_name} #{target_name}"
  fcyto.write "#{edge}\n"
end
fcyto.close
puts "Cytoscape File '#{cyto_name}' created."

#------------------------------------------------------------------------------#
# Write Gephi MySQL DDL for tables: nodes and edges                            #
#------------------------------------------------------------------------------#
gephi_sql = <<-EOT
DROP TABLE IF EXISTS `nodes`;
CREATE TABLE IF NOT EXISTS `nodes` (
  `id` varchar(10) NOT NULL,
  `label` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `edges`;
CREATE TABLE IF NOT EXISTS `edges` (
  `source` varchar(10) NOT NULL,
  `target` varchar(10) NOT NULL,
  `weight` double NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

EOT

gephi_name = "#{$YAM_GRAPH_PATH}/gephi_#{dayfrom}_#{dayto}.sql"
fgephi = File.open(gephi_name, 'w')
fgephi.write gephi_sql

gephi_nodes = Hash.new 0
@toyam.keys.sort.each do |k|
  f = @toyam[k].split("->")
  source_name = shortName(f[0].strip)
  target_name = shortName(f[1].strip)
  gephi_nodes[source_name] += 1
  gephi_nodes[target_name] += 1
end

@edges.keys.sort.each do |k|
  f = @edges[k].split("->")
  source_name = shortName(f[0].strip)
  target_name = shortName(f[1].strip)
  gephi_nodes[source_name] += 1
  gephi_nodes[target_name] += 1
end

insert_nodes = "INSERT INTO `nodes` (`id`, `label`) VALUES\n"
fgephi.write insert_nodes
node_names = Hash.new
insert_data = ''
nn = 0
gephi_nodes.each_key do |k|
  node_names[k] = "n%d" % nn
  insert_data += "('n%d', '#{k}'),\n" % nn
  nn += 1
end
insert_data = insert_data.chomp
insert_data = insert_data.chop + ";\n\n"
fgephi.write insert_data

insert_edges = "INSERT INTO `edges` (`source`, `target`, `weight`) VALUES\n"
fgephi.write insert_edges
insert_data = ''
@toyam.keys.sort.each do |k|
  f = @toyam[k].split("->")
  source_name = shortName(f[0].strip)
  target_name = shortName(f[1].strip)
  insert_data += "('#{source_name}', '#{target_name}', 0.0),\n"
end

@edges.keys.sort.each do |k|
  f = @edges[k].split("->")
  source_name = shortName(f[0].strip)
  target_name = shortName(f[1].strip)
  insert_data += "('#{source_name}', '#{target_name}', 0.0),\n"
end
insert_data = insert_data.chomp
insert_data = insert_data.chop + ";"
fgephi.write insert_data

fgephi.close
puts "Gephi File '#{gephi_name}' created."

#------------------------------------------------------------------------------#
# Load Gephi tables into the MySQL db                                          #
#------------------------------------------------------------------------------#
cmdline = "mysql yam_development < #{gephi_name} -u #{$YAM_DB_USR} -p#{$YAM_DB_PWD}"
puts "mysql yam_development < #{gephi_name} running ..."
system(cmdline)

t1 = Time.new
puts "Duration %.4f sec." % [t1 - t0]