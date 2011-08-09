require 'optparse'
require 'yammer4r'

require './yam_config.rb'
require './lib/yam_database.rb'
require './lib/yam_getUserInfo.rb'

#------------------------------------------------------------------------------#
# Parse the Yammer ID                                                          #
#------------------------------------------------------------------------------#
t0 = Time.new

OPTIONS = { :yamid => nil }
ARGV.options do |o|
  script_name = File.basename($0)
  o.banner =    "Usage: #{script_name} [OPTIONS]"
  o.define_head "Retrieve Yammer User by ID"
  o.separator   "[-u] userid"
  o.on("-u", "--userid=n", String, "A valid Yammer ID") { |yamid| OPTIONS[:yamid] = yamid }
  o.on_tail("-h", "--help", "Show this help message.") { puts o; exit }
  o.separator ""
  o.parse!
end
if OPTIONS[:yamid].nil?
  puts "Missing required option for '#{File.basename($0)}': -h or -u userid"
  exit
else 
  begin 
    Integer(OPTIONS[:yamid])
  rescue Exception => e
    puts e
    puts "Invalid parameter: '%s'. Use a valid Yammer ID." % OPTIONS[:yamid]
    exit
  end
end

#------------------------------------------------------------------------------#
# Create a new Yammer Client                                                   #
#------------------------------------------------------------------------------#
t0 = Time.new
yammer = Yammer::Client.new :config => $YAM_OAUTH
activerecord_connect

#------------------------------------------------------------------------------#
# User per id                                                                  #
#------------------------------------------------------------------------------#
@new = 0
@upd = 0
begin
  usr = yammer.user OPTIONS[:yamid]  # 6217914, 6202358, 6217905, 6217907, 3113188, 6551120
  puts "Yammer: %s - %s - %s" % [usr.id, usr.name, usr.full_name]
  ins_upd_user(usr)
rescue Exception => e
  puts e
  puts "Invalid %s" % OPTIONS[:yamid]
  exit
end

puts "Inserted %d" % @new
puts "Updated  %d" % @upd
t1 = Time.new
puts "Duration %.4f sec." % [t1 - t0]