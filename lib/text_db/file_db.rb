module FileDB
  class LineFile
    def initialize(fileName)
      unless File.exists?(fileName)
        File.open(fileName,"w"){|f|}
      end
      @file=File.open(fileName,"r+")
      @linePosCache=[]
      initTable
    end

    def get_line(line)
      pos=@linePosCache[line]
      if pos
        @file.seek(pos,IO::SEEK_SET)
        l=@file.readline
        unescape(l)
      end
    end

    def rm(line)
      pos=@linePosCache[line]
      if pos
        @file.seek(pos,IO::SEEK_SET)
        @file.print("#")
      end
    end

    def add_line(line)
      @file.seek(0,IO::SEEK_END)
      @file.print " "
      @file.puts escape(line)
      @linePosCache<<@file.tell
      @linePosCache.length-2
    end

    def each_line(&block)
      @file.seek(0,IO::SEEK_SET)
      lineNo=0
      begin
        while line=@file.readline
          if block.arity==1
            block.call(unecape(line))
          else
            block.call(unescape(line),lineNo)
          end
          lineNo+=1
        end
      rescue EOFError
      end
    end

    private
    
    def escape(line)
      line.gsub("\\","\\\\").gsub("\n","\\n")
    end
    def unescape(line)
      line.gsub("\\n","\n").gsub("\\\\","\\")
    end

    def initTable

      @linePosCache<<0
      @lineCount=0
      each_line{|line,lineNo|
        @lineCount+=1
        @linePosCache<<@file.tell
      }
    end
  end

  class DBFile
    SEPARATOR="\\|"
    def initialize(lineFile)
      @lineFile=lineFile
      @id2LineNo={}
      @nextId=0
      initTable
    end

    def ids
      @id2LineNo.keys
    end

    def get_by_id(id)
      lineNo=@id2LineNo[id]
      return nil if lineNo.nil?
      rawline=@lineFile.get_line(lineNo)
      id,rest=rawline2pair(rawline)
      rest
    end

    def put_by_id(id,data)
      tdata=get_by_id(id)
      return id if data==tdata
      line=@id2LineNo[id]
      if line
        @lineFile.rm(line)
      end
      lineNo=@lineFile.add_line(mk_rawline(id,data))
      @id2LineNo[id]=lineNo
      id
    end

    def add(data)
      id=@nextId
      @nextId+=1
      lineNo=@lineFile.add_line(mk_rawline(id,data))
      @id2LineNo[id]=lineNo
      id
    end

    def rm(id)
      @lineFile.rm(@id2LineNo[id])
    end

    private

    def initTable
      @lineFile.each_line{|line,lineNo|
        id,rest=rawline2pair(line)
        @id2LineNo[id]=lineNo
        @nextId=[@nextId-1,id].max+1
      }
    end

    def mk_rawline(id,data)
      id.to_s+"|"+data
    end

    def rawline2pair(rawline)
      id,rest=rawline.scan(/^([^#{SEPARATOR}]*)#{SEPARATOR}(.*)$/m)[0]
      [id.to_i,rest]
    end
  end

end