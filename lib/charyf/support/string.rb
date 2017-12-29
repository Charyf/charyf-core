class String
  def camelize
    self.split('_').collect(&:capitalize).join
  end

  def underscore
    self.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
  end

  def constantize
    camel_cased_word = self

    names = camel_cased_word.split('::')

    # Trigger a built-in NameError exception including the ill-formed constant in the message.
    Object.const_get(camel_cased_word) if names.empty?

    # Remove the first blank element in case of '::ClassName' notation.
    names.shift if names.size > 1 && names.first.empty?

    names.inject(Object) do |constant, name|
      if constant == Object
        constant.const_get(name)
      else
        candidate = constant.const_get(name)
        next candidate if constant.const_defined?(name, false)
        next candidate unless Object.const_defined?(name)

        # Go down the ancestors to check if it is owned directly. The check
        # stops when we reach Object or the end of ancestors tree.
        constant = constant.ancestors.inject do |const, ancestor|
          break const    if ancestor == Object
          break ancestor if ancestor.const_defined?(name, false)
          const
        end

        # owner is in Object, so raise
        constant.const_get(name, false)
      end
    end
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

  def squish
    dup.squish!
  end

  def squish!
    gsub!(/\A[[:space:]]+/, '')
    gsub!(/[[:space:]]+\z/, '')
    gsub!(/[[:space:]]+/, ' ')
    self
  end

  def trim(str=nil)
    return self.ltrim(str).rtrim(str)
  end

  def ltrim(str=nil)
    if (!str)
      return self.lstrip
    else
      escape = Regexp.escape(str)
    end

    return self.gsub(/^#{escape}+/, "")
  end

  def rtrim(str=nil)
    if (!str)
      return self.rstrip
    else
      escape = Regexp.escape(str)
    end

    return self.gsub(/#{escape}+$/, "")
  end

end