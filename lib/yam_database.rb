require 'active_record'

def activerecord_connect
  ActiveRecord::Base.establish_connection(:adapter => "mysql",
    :encode => "utf8",
    :host => "localhost",
    :username => $YAM_DB_USR,
    :password => $YAM_DB_PWD,
    :database => $YAM_MYSQL_DB)
end

class Ymessage < ActiveRecord::Base
end

class Yuser < ActiveRecord::Base
end

class Ylike < ActiveRecord::Base
end

class Yimg < ActiveRecord::Base 
end

class Yfile < ActiveRecord::Base
end

class Ymodule < ActiveRecord::Base
end
