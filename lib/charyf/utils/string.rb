class String
  def camelize
    self.split('_').collect(&:capitalize).join
  end

  def deconstantize
    self.to_s[0, self.rindex("::") || 0]
  end

  def demodulize
    if (i = self.rindex("::"))
      self[(i + 2)..-1]
    else
      self
    end
  end
end