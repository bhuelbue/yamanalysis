require 'optparse'
require 'date'

require './yam_config.rb'
require './lib/yam_database.rb'

#------------------------------------------------------------------------------#
# Yesterday's Word Cloud                                                       #
#------------------------------------------------------------------------------#
date = DateTime.now - 1
dayfrom = date.strftime("%Y-%m-%d")
date = date + 1
dayto = date.strftime("%Y-%m-%d")
ndate = dayfrom.gsub('-', '')
OPTIONS = { :dayfrom  => dayfrom, :dayto => dayto }

ARGV.options do |o|
  script_name = File.basename($0)
  o.banner =    "Usage: #{script_name} [OPTIONS]"
  o.define_head "Create Yammer Word Cloud"
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

activerecord_connect
fname = "#{$YAM_IBM_WCG_WORK_PATH}/msgcloud.txt"
f = File.open(fname, 'w')

kk = 0
dbmsgs = Ymessage.find :all, :select => "body_plain",
  :conditions => "DATE(created_at) >= '#{dayfrom}' AND DATE(created_at) <= '#{dayto}'",
  :order  => "yamid DESC"
dbmsgs.each do |m|
  kk += m.body_plain.length
  words = m.body_plain.split(/[^a-zA-Z0-9]/)
  words.each do |word|
    if word.length > 2
      f.write "#{word.downcase}\n"
    end
  end
end

f.close
puts "Messages: %.1fk" % [kk / 1024.0]

outfile =  "#{$YAM_IBM_WCG_WORK_PATH}/wc_yam_#{ndate}.png"
puts "IBM WCG for '#{outfile}' ..."
cmdline = "java -jar \"#{$YAM_IBM_WCG_JAR}\" "
cmdline += "-c \"#{$YAM_IBM_WCG_WORK_PATH}/configuration.txt\" -w 800 -h 800 < "
cmdline += "#{fname} > #{outfile}"
system(cmdline)
puts "IBM WCG '#{outfile}'"
puts " "