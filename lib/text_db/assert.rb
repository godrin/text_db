def assert(value,&block)
  unless block.call
    raise value
  end
end