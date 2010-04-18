require "test/unit"
require "text_db"
require "models/mail.rb"
require "models/user.rb"

class TestTextDb < Test::Unit::TestCase
  def test_sanity
    #flunk "write tests or I will kneecap you"
    u=User.new
    m=Mail.new
    m.mail="kjhsdfkjhsdf"
    u.mail=m
    id=u.save
    u2=User.get_by_id(id)
    m2=u2.mail
    
    assert_equals u,u2   
    assert_equals m,m2 
    
  end
end

if false

FIXME

$:<<"lib"<<"model"
require 'text_db.rb'
require 'mail.rb'
require 'user.rb'
require 'pp'

u=User.new
m=Mail.new
m.mail="kjhsdfkjhsdf"
u.mail=m
id=u.save

u2=User.get_by_id(id)
pp u2
pp u2.mail
  end