= text_db

http://github.com/godrin/text_db

== DESCRIPTION:

text_db is a simple file- and text-based database.
It's completely written in Ruby. It's interface is / or should
be based on the interface of ActiveRecord. 

== FEATURES/PROBLEMS:

not much here yet

* indexes missing
* views missing
* transactions missing

== SYNOPSIS:

class Mail
  include TextDB::Base
  
  dbattr :mail => String
  dbattr :verified => [TrueClass,FalseClass]
end

mail=Mail.new
mail.mail="mailName" # => "mailName"
mail.mail=1234 # => exception
mail.verified=true
id=mail.save

recoveredMail=Mail.get_by_id(id)
recoveredMail==mail # => true

== REQUIREMENTS:

none so far

== INSTALL:

> git clone git@github.com:godrin/text_db.git
> cd text_db
> rake gem
> gem install pkg/text_db-*.gem

Later (No project on Gemcutter yet): 
gem install text_db

== LICENSE:

(The MIT License)

Copyright (c) 2010 David Kamphausen

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
