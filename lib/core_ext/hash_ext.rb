#
# credit: http://stackoverflow.com/questions/17451487/classic-hash-to-dot-notation-hash
#
class Hash

  def self.dot_notation(object, prefix = nil)
    if object.is_a? Hash
      object.map do |key, value|
        if prefix
          dot_notation value, "#{prefix.to_s.camelize}.#{key.to_s.camelize}"
        else
          dot_notation value, "#{key.to_s.camelize}"
        end
      end.reduce(&:merge)
    else
      {prefix.to_s.camelize => object}
    end
  end

end