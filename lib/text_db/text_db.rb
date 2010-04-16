require 'assert'
require 'file_db.rb'

require 'yaml_marshal.rb'

module TextDB

  Marshal=YAMLMarshal

  @@dbIds=0
  def self.getNewDBId
    @@dbIds+=1
  end

  module ModelClass
    @@columnDefinition={}

    def dbattr(hash)
      @@columnDefinition[tableName]||={}
      hash.each{|k,v|
        @@columnDefinition[tableName][k]=v
        cl=caller[2].split(":")
        module_eval <<-EOT, cl[0],cl[1].to_i-1
        def #{k}
          if @#{k}.is_a?(LazyLoad)
            @#{k}=Marshal::load(TextDB::getDbTable(@#{k}.klass).get_by_id(@#{k}.dbid))
          end
          @#{k}
        end
        EOT
        module_eval <<-EOT, cl[0],cl[1].to_i-1
        def #{k}=(_#{k})
          TextDB::ModelClass::verify(_#{k},#{v})
          @#{k}=_#{k}
          __modify!
        end
        EOT
      }
    end

    def definedColumns
      @@columnDefinition[tableName].keys
    end

    def get_by_id(id)
      str=TextDB::getDbTable(tableName).get_by_id(id)
      u=TextDB::Marshal::load(str)
      u.instance_variable_set("@__dbid",id)
      u
    end

    def tableName
      self.to_s
    end

    def self.verify(value,klass)
      if klass.is_a?(Class)
        assert("#{value} is not of class #{klass}"){value.is_a?(klass)}
      end
    end

  end

  class LazyLoad
    attr_reader :klass,:dbid
    def initialize(klass,dbid)
      @klass=klass
      @dbid=dbid
    end
  end

  module Base
    def respond_to?(name)
    end

    def __dbid
      @__dbid
    end

    def __tableName
      self.class.to_s
    end

    def self.included(mod)
      mod.extend ModelClass
    end

    def __modified
      @__modified||true
    end

    def __modify!
      @__modified=true
    end


    def save
      if @__dbid and not __modified
        return @__dbid
      end
      table=__tableName
      unless __dbid
        @__dbid=TextDB::getNewDBId
      end
      str=TextDB::Marshal::dump(self,true)
      TextDB::getDbTable(table).put_by_id(__dbid,str)
      __dbid
    end

  end

  def self.getDbTable(name)
    @@dbTables||={}
    @@dbTables[name]||=FileDB::DBFile.new(FileDB::LineFile.new(name+"_db.txt"))
  end
end

