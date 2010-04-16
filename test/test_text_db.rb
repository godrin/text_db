require "test/unit"
require "text_db"

class TestTextDb < Test::Unit::TestCase
  def test_sanity
    flunk "write tests or I will kneecap you"
  end
end


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