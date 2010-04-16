class Todo
  dbattr :questions=>Question
  dbattr :content=>String
  dbattr :comments=>Comment
  dbattr :category=>Category
end