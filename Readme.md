Initial Tasks
=============
  
Start with reading the blog post [Word Clouds and Social Graphs in Yammer](http://bhuelbue.blogspot.com/2011/07/word-clouds-and-social-graphs-in-yammer.html). A detailed description is available in the blog post [Yamanalysis - A Ruby Yammer API Usage Example](http://bhuelbue.blogspot.com/2011/08/yamanalysis-ruby-yammer-api-usage.html).  
Please customize Yamanalysis usage like the location where you installed the IBM Word Cloud Generator, your mail domain, the database name, user and password for MySQL in:  
  
*  yam\_config.rb
*  db/yam\_development\_new.sql
  
Customize the font parameter for your word cloud:  
  
*  wordcloud/configuration.txt
  
Create the MySQL database:  
  
*  mysql < db/yam\_development\_new.sql -u root -p
  
Create an OAuth file for Yammer access:  
  
*  ruby yam\_create\_oauth\_yml.rb -k YourConsumerKey -s YourConsumerSecret
  
Yamanalysis Usage
=================
  
Use a command window and run the following Ruby programs.  
  
Download user information:  
  
*  ruby yam\_user.rb
  
-----
	...
	5983393-aaron-guest-Aaron Leon inserted ...
	...
	5544237-alf-guest-Alf Døj inserted ...
	5980792-alfredvanpaaschen-guest-Alfred van Paaschen inserted ...
	Part A-1 done ... 50 messages
	5702034-alison-guest-Alison Michalk inserted ...
	5530658-mckenziea-guest-Alissa McKenzie inserted ...
	...
	5842193-yholland-guest-Yvonne Holland inserted ... 
	Part Y-1 done ... 17 messages
	...
	3850574-dlehoang-guest-Zu LeHoang inserted ...
	Part Z-1 done ... 6 messages
	
	Inserted 1703
	Updated  0
	Duration 208.5936 sec.
----
  
Download user information for one Yammer user with a given Yammer ID:  
  
*  ruby yam\_user\_id.rb -h
  
----
	Usage: yam_user_id.rb [OPTIONS]
	Retrieve Yammer User by ID
	[-u] userid
    	-u, --userid=n                   A valid Yammer ID
	
    	-h, --help                       Show this help message.
----
  
Create a user wall png image:  
  
*  ruby yam\_user\_wall\_img.rb
  
----
	User Count: 1703
	Downloading 1703 photos ...
	Yammer ERROR: 5530256 No valid ext in https://www.yammer.com/yamage/photos/274144/New_Twitter_photo_small
	retry ...
	Yammer ERROR: 5530256 No valid ext in https://www.yammer.com/yamage/photos/274144/New_Twitter_photo_small
	retry ...
	5530256 missing
	GV File '/project/yam/graph/userwall_patchwork_p0.gv' created.
	PNG file is ' /project/yam/graph/userwall_patchwork_p0_osage.png'
	Duration 1649.2340 sec.
----
  
Download messages:  
  
*  ruby yam\_last\_msg.rb
  
----
	Messages: 0
	Likes   : 0
	Modules : 0
	Images  : 0
	Files   : 0
	Last yamid 103500000
	19 messages received ...
	2011-08-06:106698418 2 0
	2011-08-06:106688716 2 1
	2011-08-06:106682164 2 0
	...
	2010-04-15:40820231 2 0
	2010-04-15:40818740 2 0
	19 messages inserted ...
	Messages: 14721
	Likes   : 7671
	Modules : 763
	Images  : 562
	Files   : 203
	14721 messages retrieved
	Duration 3451.4682 sec.
----
  
Create a word cloud:  
  
*  ruby yam\_word\_cloud.rb -h
  
-----
	Usage: yam_word_cloud.rb [OPTIONS]
	Create Yammer Word Cloud
	[-ft] options yyyy-mm-dd
    	-f, --from=yyyy-mm-dd            Select the starting date
    	-t, --to=yyyy-mm-dd              Select the end date
	
    	-h, --help                       Show this help message.
-----
  
*  ruby yam\_word\_cloud.rb -f 2011-08-06 -t 2011-08-07
  
----
	Between 2011-08-06 and 2011-08-07 ...
	Messages: 3.7k
	IBM WCG for '/project/yam/wordcloud/wc_yam_20110806.png' ...
	IBM Word Cloud Generator build 32
	Copyright (c)2009 IBM
	IBM WCG '/project/yam/wordcloud/wc_yam_20110806.png'
----
  
Create thread analysis graphs:  
  
*  ruby yam\_thread\_img.rb -h
  
----
	Usage: yam_thread_img.rb [OPTIONS]
	Create Yammer Thread Analysis
	[-ft] options yyyy-mm-dd
    	-f, --from=yyyy-mm-dd            Select the starting date
    	-t, --to=yyyy-mm-dd              Select the end date

    	-h, --help                       Show this help message.
----
  
*  ruby yam\_thread\_img.rb -f 2011-08-06 -t 2011-08-07
  
----
	Between 2011-08-06 and 2011-08-07 ...
	19 threads found between 2011-08-06 and 2011-08-07
	39 yamids (messages)
	19 senderids (people)
	5 initial posts
	23 relations
	GV File '/project/yam/graph/thread_analysis_2011-08-06_2011-08-07.gv' created.
	PNG file is '/project/yam/graph/thread_analysis_2011-08-06_2011-08-07\_dot.png'
	PNG file is '/project/yam/graph/thread_analysis_2011-08-06_2011-08-07\_fdp.png'
	PNG file is '/project/yam/graph/thread_analysis_2011-08-06_2011-08-07\_sfdp.png'
	PNG file is '/project/yam/graph/thread_analysis_2011-08-06_2011-08-07\_twopi.png'
	PNG file is '/project/yam/graph/thread_analysis_2011-08-06_2011-08-07\_circo.png'
	PNG file is '/project/yam/graph/thread_analysis_2011-08-06_2011-08-07\_neato.png'
	Cytoscape File '/project/yam/graph/cyto_2011-08-06_2011-08-07.txt' created.
	Gephi File '/project/yam/graph/gephi_2011-08-06\_2011-08-07.sql' created.
	mysql yam_development < /project/yam/graph/gephi_2011-08-06_2011-08-07.sql running ...
	Duration 23.1798 sec.
----
