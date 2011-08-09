#<Yammer::User:0x0000010110f930 
#@user=<Mash admin="false" 
#        birth_date="" 
#        can_broadcast="false" 
#        contact=<Mash email_addresses=[<Mash address="avian.kehoe@amd.com" type="primary">] 
#                      im=<Mash provider="" username=""> 
#                      phone_numbers=[<Mash number="5126023745" type="work">]> 
#        expertise="Intranet Content Management, Analytics, etc. " 
#        external_urls=[] 
#        full_name="Avian Kehoe" 
#        guid=nil 
#        hire_date=nil 
#        id=1391309 
#        interests=[] 
#        job_title="Content Manager" 
#        kids_names="" 
#        location="Austin, Tx" 
#        mugshot_url="https://www.yammer.com/yamage/photos/720646/just_me_small.jpg" 
#        name="avian-guest" 
#        network_domains=[] 
#        network_id=99807 
#        network_name="Yammer YCN" 
#        previous_companies=[] 
#        schools=[] 
#        settings=<Mash xdr_proxy="https://xdrproxy.yammer.com"> 
#        significant_other="" 
#        state="active" 
#        stats=<Mash followers=0 following=0 updates=3> 
#        summary="" 
#        timezone="Pacific Time (US & Canada)" 
#        type="user" 
#        url="https://www.yammer.com/api/v1/users/1391309" 
#        verified_admin="false" 
#        web_url="https://www.yammer.com/yammerycn/users/avian-guest">, 

def ins_upd_user(u)
  
  email = getEmail(u)
  
  dbusrs = Yuser.find :all, :conditions => { :yamid => u.id }
  if dbusrs.length < 1
    puts "%s-%s-%s inserted ... " % [u.id, u.name, u.full_name]
    Yuser.create(:yamid => u.id,
      :url => u.url,
      :job_title => u.job_title,
      :name => u.name,
      :full_name => u.full_name,
      :email => email,
      :network_id => u.network_id,
      :network_name => u.network_name,
      :stats_followers => u.stats['followers'],
      :stats_updates => u.stats['updates'],
      :stats_following => u.stats['following'],
      :web_url => u.web_url,
      :mugshot_url => u.mugshot_url,
      :state => u.state,
      :expertise => u.expertise,
      :location => u.location)
    @new += 1
  else
    dbusrs.each do |user|
      # Delete the downloaded user photo, if the user has a new one.
      unless user.mugshot_url.eql?(u.mugshot_url)
        filename = "#{$YAM_IMG_PATH}/#{u.id}.jpg"
        if File.exists?(filename)
          File.delete(filename)
          puts "#{filename} deleted ..."
        end
      end
      user.full_name = u.full_name
      user.job_title = u.job_title
      user.name = u.name
      user.email = email
      user.stats_followers = u.stats['followers']
      user.stats_updates = u.stats['updates']
      user.stats_following = u.stats['following']
      user.mugshot_url = u.mugshot_url
      user.state = u.state
      user.location = u.location
      user.expertise = u.expertise
      user.save
      @upd += 1
    end
  end
  
end

def getEmail(u)
  
  email = u.name + "@" + $YAM_MAIL_DOMAIN
  cont_email = u.contact['email_addresses']
  cont_email.each do |k|
    if k['type'].eql?('primary')
      email = k['address']
    end
  end
  return email
  
end

def getInfo(usr)
  
  usr.each do |u|
    ins_upd_user(u)
  end
  
end