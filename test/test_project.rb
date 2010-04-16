$:<<"lib"<<"model"
require 'text_db.rb'
require 'project.rb'
require 'mail.rb'
require 'user.rb'

u=User.new
u.name="Name"
u.mail=Mail.new
pp u
u.save