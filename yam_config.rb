$YAM_PATH = File.expand_path(File.dirname(__FILE__))
$YAM_MAIL_DOMAIN = "user.yammer.com"          # adjust for your network e.g. ford.com
$YAM_OAUTH = $YAM_PATH + "/oauth.yml"         # name your oauth file e.g. ford_oauth.xml
$YAM_MYSQL_DB = "yam_development"             # your MySQL db name, see also db/yam_development_new.sql
$YAM_DB_USR = "root"                          # name your db user
$YAM_DB_PWD = "password"                      # name your db password
$YAM_IMG_PATH = $YAM_PATH + "/img"
$YAM_GRAPH_PATH = $YAM_PATH + "/graph"
# linux
# mac
# $YAM_IBM_WCG_JAR = "/Users/bhuelbue/Downloads/IBM Word Cloud/ibm-word-cloud.jar"
# windows
$YAM_IBM_WCG_JAR = "C:/Downloads/wordcloud-build-32/IBM Word Cloud/ibm-word-cloud.jar"
$YAM_IBM_WCG_WORK_PATH = $YAM_PATH  + "/wordcloud"
$YAM_HIST_CNT = 250                           # number of baskets with 20 messages = 5000 msessages
$YAM_VERBOSE = false                          # set true for verbose output