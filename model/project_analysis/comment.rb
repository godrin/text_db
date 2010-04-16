class Comment
  include TextDB::Base

  dbattr :author => User
  dbattr :content => String
end
