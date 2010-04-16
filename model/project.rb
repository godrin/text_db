class Project
  include TextDB::Base
  
  dbattr :user => String
  dbattr :name => String
  
end