class Mail
  include TextDB::Base
  
  dbattr :mail => String
  dbattr :verified => [TrueClass,FalseClass]
end