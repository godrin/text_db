$:<<"lib"<<"model"
require 'text_db'

A=Struct.new(:data)
TestKlass=Struct.new(:id,:data)

def testMarshal(orig)
  str=TextDB::Marshal.dump(orig,true)
  pp orig,str
  re=TextDB::Marshal.load(str)
  pp re
  if re!=orig
    raise "INvalid"
  end
end

testMarshal(789)
testMarshal(789.234)
#exit

def testStruct
  testMarshal(A.new("lkj"))
end

def testComplex
  testMarshal({1=>[1,2.34,"45",true,false,nil,TestKlass.new(456,"hupe")]})
end

testStruct
testComplex
