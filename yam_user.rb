require 'yammer4r'

require './yam_config.rb'
require './lib/yam_database.rb'
require './lib/yam_getUserInfo.rb'

#------------------------------------------------------------------------------#
# Create a new Yammer Client                                                   #
#------------------------------------------------------------------------------#
t0 = Time.new
yammer = Yammer::Client.new :config => $YAM_OAUTH
activerecord_connect

@new = 0
@upd = 0

#------------------------------------------------------------------------------#
# Print out all the 50 users per page                                          #
#------------------------------------------------------------------------------#
("A".."Z").each do |l|
  p = 1
  usr = yammer.users :letter => l, :page => p
  getInfo(usr)
  puts "Part #{l}-#{p} done ... %d messages" % usr.length
  sleep(2)
  
  while usr.length == 50
    p = p + 1
    usr = yammer.users :letter => l, :page => p
    getInfo(usr)
    puts "Part #{l}-#{p} done ... %d messages" % usr.length
    sleep(2)
  end
end

puts "Inserted %d" % @new
puts "Updated  %d" % @upd
t1 = Time.new
puts "Duration %.4f sec." % [t1 - t0]
