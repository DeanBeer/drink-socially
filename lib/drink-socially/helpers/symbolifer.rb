module NRB
  class KeyConflict < RuntimeError; end
end


class Array
  def nrb_symbolify
    collect { |e| e.nrb_symbolify }
  end
end


class Hash
  def nrb_symbolify
    inject({}) do |hash,pair|
      k = pair[0]
      s = k.to_sym
      raise NRB::KeyConflict.new("Hash contains symbol & string key: #{k} #{self[k]} #{self[s]}") if k != s && !! self[k] && !! self[s]
      hash[s] = pair[1].nrb_symbolify
      hash
    end
  end
end


class Object
  def nrb_symbolify
    self
  end
end
