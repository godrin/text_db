module TextDB
  module SimpleMarshal
    def self.load(data)
      case data[0..0]

      when "\""
        #pp "STRING"
        i=1
        str=""
        escaped=false
        loop do
          ch=data[i..i]
          i+=1
          if ch=="\""
            if escaped
              str<<ch
            else
              break
            end
            escaped=false
          elsif ch=="\\"
            if escaped
              str<<ch
              escaped=false
            else
              escaped=true
            end
          else
            if escaped
              if ch=="n"
                str<<"\n"
              else
                raise "Unexpected character !!!"
              end
              escaped=false
            else
              str<<ch
            end
          end
        end
        return [str,i]

      when /[0-9]/
        num=data[/^[0-9]+\.?[0-9]*/]
        pp num
        if num=~/\./
          [num.to_f,num.length]
        else
          [num.to_i,num.length]
        end
        exit
      when "<"
        # some type
        klassName=data.scan(/.([^ ]*)/){|p| break p[0] }
        obj=eval(klassName).new
        pp klassName
        start=(klassName.length+2)
        data=data[start..-1]
        while data[0..0]!='>'
          name=data.scan(/^([^=]+)/){|p| break p[0]}
          start+=name.length+1
          data=data[(name.length+1)..-1]
          value,npos=load(data)
          data=data[npos..-1]
          start+=npos
          obj.send(name+"=",value)
        end
        [obj,start]
      end
    end

    def self.dump(data,first)
      case data
      when Numeric
        data.to_s
      when String
        "\""+data.gsub("\\","\\\\").gsub("\n","\\n").gsub("\"","\\\"")+"\""
      when Hash
        "{"+data.map{|k,v|dump(k,false)+"=>"+dump(v,false)}.join(", ")+"}"
      when Array
        "["+data.map{|v|dump(v,false)}.join(", ")+"]"
      when TrueClass
        "true"
      when FalseClass
        "false"
      when NilClass
        "nil"
      when Base
        if first

          cols=data.class.definedColumns
          pp cols

          "<#{data.class.to_s} "+cols.map{|m|m.to_s+"="+dump(data.send(m),false)}.join(" ")+">"
        else
          id=data.save unless first
          "<#{data.class.to_s} #"+id.to_s+">"
        end
      when Struct
        "<#{data.class.to_s} "+data.members.map{|m|m+"="+dump(data.send(m),false)}.join(" ")+">"
      else
        if data.respond_to?(:dbid) and data.respond_to?(:type)
          "##{data.type}:#{data.id}"
        else
          raise "#{data} not dumpable!"
        end
      end
    end
  end
end