$:<<"lib"<<"model"
require 'file_db.rb'
require 'pp'

f=FileDB::DBFile.new(FileDB::LineFile.new("test/test_db.txt"))
pp f
pp f.ids
pp f.get_by_id(50)
id=f.add("MUUUUU")
pp id
pp f.get_by_id(id)
f.rm(id)