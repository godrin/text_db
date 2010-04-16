class User
  include TextDB::Base
  
  dbattr :name => String
  dbattr :mail => Mail
end