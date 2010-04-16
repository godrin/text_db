require 'yaml'

module TextDB
  module YAMLMarshal
    def self.load(str)
      YAML::load(str)
    end

    def self.dump(obj,first)
      YAML::dump(obj)
    end
  end

  module Base
    def to_yaml(p)
      unless p.is_a?(StringIO)
        save
        TextDB::LazyLoad.new(self.class.tableName,__dbid).to_yaml(p)
      else
        super(p)
      end
    end

  end
end