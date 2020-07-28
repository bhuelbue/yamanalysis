require 'yammer4r'

require './yam_config.rb'
require './lib/yam_database.rb'

def countRows()

  cnt_msgs = Ymessage.count
  puts "Messages: %d" % cnt_msgs

  cnt_likes = Ylike.count
  puts "Likes   : %d" % cnt_likes

  cnt_modules = Ymodule.count
  puts "Modules : %d" % cnt_modules

  cnt_imgs = Yimg.count
  puts "Images  : %d" % cnt_imgs

  cnt_files = Yfile.count
  puts "Files   : %d" % cnt_files

end

def getAttYmodule(m, a)

  ymods = Ymodule.find :all, :conditions => { :ymod_id => a['id'], :yam_id => m.id }
  if ymods.length < 1
    Ymodule.create(:ymod_id => a['id'],
      :yam_id => m.id,
      :thread_id => m.thread_id,
      :name => a['name'],
      :web_url => a['web_url'],
      :inline_url => a['inline_url'],
      :inline_html => a['inline_html'],
      :icon_url => a['ymodule']['icon_url'],
      :app_id => a['ymodule']['app_id'],
      :created_at => m.created_at)
    if $YAM_VERBOSE
      puts "Attached Ymodule %d-%s-%s... inserted ..." % [a['id'], a['ymodule']['app_id'], a['name'][0..20]]
    end
  end

end

def getAttImage(yamid, a)

  imgs = Yimg.find :all, :conditions => { :yamid => yamid, :imgid => a['id'] }
  if imgs.length < 1
    Yimg.create(:yamid => yamid,
      :imgid => a['id'],
      :name => a['name'],
      :ftype => a['type'],
      :web_url => a['web_url'],
      :image_size => a['image']['size'],
      :image_url => a['image']['url'],
      :image_thumbnail_url => a['image']['thumbnail_url'])
    if $YAM_VERBOSE
      puts "Attached Image: %d-%s-%s inserted ..." % [yamid, a['name'], a['image']['url']]
    end
  end

end

def getAttFile(yamid, a)

  yfiles = Yfile.find :all, :conditions => { :yamid => yamid, :fileid => a['id'] }
  if yfiles.length < 1
    Yfile.create(:yamid => yamid,
      :fileid => a['id'],
      :name => a['name'],
      :ftype => a['type'],
      :web_url => a['web_url'],
      :file_size => a['file']['size'],
      :file_url => a['file']['url'])
    if $YAM_VERBOSE
      puts "Attached File : %d-%s-%s inserted ..." % [yamid, a['name'], a['file']['url']]
    end
  end

end

def getLikes(yamid, name, full_name)

  likes = Ylike.find :all, :conditions => { :yamid => yamid, :permalink => name }
  if likes.length < 1
    Ylike.create(:yamid => yamid,
      :permalink => name,
      :full_name => full_name)
    if $YAM_VERBOSE
      puts "Liked by %d-%s-%s inserted ..." % [yamid, name, full_name]
    end
  end

end

def checkMessages(messages)

  mnr = 0
  messages.each do |m|
    puts "%s:%d %d %d" % [m.created_at.to_date, m.id, m.liked_by.count, m.attachments.length]
    m.attachments.each do |a|
      if $YAM_VERBOSE
        puts "AttId     : %s" % a['id']
        puts "AttName   : %s" % a['name']
        puts "AttType   : %s" % a['type']
        puts "AttWebUrl : %s" % a['web_url']
      end
      if a['type'].eql?('ymodule')
        if a['name'].nil?
          puts "ERROR    --------->"
          puts a.inspect
          puts "END      <---------"
        elsif a['name'].include?('Links: ')
          if $YAM_VERBOSE
            puts "LINKS --------->"
            puts "YamMsgId  : %s" % m.id
            puts "YamThread : %s" % m.thread_id
            puts "LinkId    : %s" % a['id']
            puts "Name      : %s" % a['name']
            puts "WebUrl    : %s" % a['web_url']
            puts "icon-url  : %s" % a['ymodule']['icon_url']
            puts "app_id    : %s" % a['ymodule']['app_id']
            puts "created_at: %s" % m.created_at
            puts "END      <---------"
          end
          getAttYmodule(m, a)
        elsif a['name'].include?('Questions: ')
          if $YAM_VERBOSE
            puts "QUESTIONS--------->"
            puts "YamMsgId  : %s" % m.id
            puts "YamThread : %s" % m.thread_id
            puts "QaId      : %s" % a['id'] 
            puts "Name      : %s" % a['name']
            puts "WebUrl    : %s" % a['web_url']
            puts "InlineUrl : %s" % a['inline_url']
            puts "InlineHtml: %s" % a['inline_html']
            puts "icon-url  : %s" % a['ymodule']['icon_url']
            puts "app_id    : %s" % a['ymodule']['app_id']
            puts "created_at: %s" % m.created_at
            puts "END      <---------"
          end
          getAttYmodule(m, a)
        elsif a['name'].include?('Polls: ')
          if $YAM_VERBOSE
            puts "POLLS    --------->"
            puts "YamMsgId  : %s" % m.id
            puts "YamThread : %s" % m.thread_id
            puts "QaId      : %s" % a['id'] 
            puts "Name      : %s" % a['name']
            puts "WebUrl    : %s" % a['web_url']
            puts "InlineUrl : %s" % a['inline_url']
            puts "InlineHtml: %s" % a['inline_html']
            puts "icon-url  : %s" % a['ymodule']['icon_url']
            puts "app_id    : %s" % a['ymodule']['app_id']
            puts "created_at: %s" % m.created_at
            puts "END      <---------"
          end
          getAttYmodule(m, a)
        elsif a['name'].include?('Ideas: ')
          if $YAM_VERBOSE
            puts "IDEAS    --------->"
            puts "YamMsgId  : %s" % m.id
            puts "YamThread : %s" % m.thread_id
            puts "IdeaId    : %s" % a['id'] 
            puts "Name      : %s" % a['name']
            puts "WebUrl    : %s" % a['weburl']
            puts "InlineUrl : %s" % a['inline_url']
            puts "InlineHtml: %s" % a['inline_html']
            puts "icon-url  : %s" % a['ymodule']['icon_url']
            puts "app_id    : %s" % a['ymodule']['app_id']
            puts "created_at: %s" % m.created_at
            puts "END      <---------"
          end
          getAttYmodule(m, a)
        else
          if $YAM_VERBOSE
            puts "UNKNOWN  --------->"
            puts "YamMsgId  : %s" % m.id
            puts "YamThread : %s" % m.thread_id
            puts "UnknownId : %s" % a['id'] 
            puts "Name      : %s" % a['name']
            puts "WebUrl    : %s" % a['weburl']
            puts "InlineUrl : %s" % a['inline_url']
            puts "InlineHtml: %s" % a['inline_html']
            puts "icon-url  : %s" % a['ymodule']['icon_url']
            puts "app_id    : %s" % a['ymodule']['app_id']
            puts "created_at: %s" % m.created_at
            puts "END      <---------"
          end
          getAttYmodule(m, a)
        end
      elsif a['type'].eql?('image')
        if $YAM_VERBOSE
          puts "IMAGE    --------->"
          puts "ImgSize   : %s" % a['image']['size']
          puts "ImgUrl    : %s" % a['image']['url']
          puts "ImgThmbUrl: %s" % a['image']['thumbnail_url']
          puts "END      <---------"
        end
        begin
          getAttImage(m.id, a)
        rescue 
          print "Failed to write image: ", $!, "\n"
        end 
      elsif a['type'].eql?('file')
        if $YAM_VERBOSE
          puts "FILE     --------->"
          puts "FileSize  : %s" % a['file']['size']
          puts "FileUrl   : %s" % a['file']['url']
          puts "END      <---------"
        end
        getAttFile(m.id, a)
      end
    end
    m.liked_by.names.each do |l|
      if $YAM_VERBOSE
        puts "%s - %s" % [l['permalink'], l['full_name']]
      end
      getLikes(m.id, l['permalink'], l['full_name'])
    end

    dbmsgs = Ymessage.find :all, :conditions => { :yamid => m.id }
    if dbmsgs.length < 1
      Ymessage.create(:yamid => m.id,
        :url => m.url,
        :client_type => m.client_type,
        :thread_id => m.thread_id,
        :created_at => m.created_at,
        :message_type => m.message_type,
        :replied_to_id => m.replied_to_id,
        :sender_type => m.sender_type,
        :body_parsed => m.body.parsed,
        :web_url => m.web_url,
        :sender_id => m.sender_id,
        :body_plain => m.body.plain)
      mnr += 1
    end
  end
  puts "%d messages inserted ..." % mnr

end

#------------------------------------------------------------------------------#
# Connect to database                                                          #
# Create a new Yammer Client                                                   #
#------------------------------------------------------------------------------#
t0 = Time.new
activerecord_connect
countRows()
@yammer = Yammer::Client.new :config => $YAM_OAUTH

#------------------------------------------------------------------------------#
# Set the download mode: H is for the historical data chunks                   #
# mode = 'H' means download the message history in data chunks                 #
# 199999999 - 98000000                                                         #
#  98000000 - 95000000                                                         #
#------------------------------------------------------------------------------#
mode = "H"
@high_watermark = 199999999 # 82000000
@low_watermark  = 103500000 # 79500000
@cntmsg = 0
    
#------------------------------------------------------------------------------#
# Save messages and attachments into the database                              #
#------------------------------------------------------------------------------#
if mode.eql?("H")
  messages = @yammer.messages :all, :older_than => @high_watermark
else
  @low_watermark = 0
  dbmsgs = Ymessage.find :all, :order => "yamid DESC", :limit => 1
  dbmsgs.each do |m|
    @low_watermark = m.yamid
  end
  messages = @yammer.messages :all, :newer_than => @low_watermark
end
puts "Last yamid %d" % @low_watermark
puts "%d messages received ..." % messages.length
@cntmsg += messages.length
checkMessages(messages)
sleep(2)

unless messages.last.nil?

  n = "#{$YAM_HIST_CNT}".to_i
  puts "Retrieving %d messages ..." % [n * 20]
  n.times do
    # while @low_watermark < messages.last.id
    messages = @yammer.messages :all, :older_than => messages.last.id.to_s
    if messages.last.nil?
      break
    end
    puts "%d messages received ..." % messages.length
    @cntmsg += messages.length
    checkMessages(messages)
    sleep(2)
  end
end

countRows()

puts "%d messages retrieved" % @cntmsg
t1 = Time.new
puts "Duration %.4f sec." % [t1 - t0]
