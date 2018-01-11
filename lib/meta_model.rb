class MetaModel
  def initialize(**options)
    options.each do |variable, value|
      getter variable
      setter variable, value
    end
  end

  def method_missing(name, *args, &block)
    return getter($1) if name.to_s =~ /^(\w*)$/ and self.instance_variables.include?("@#{$1}".to_sym)
    return setter($1, *args) if name.to_s =~ /^(\w*)=$/ and self.instance_variables.include?("@#{$1}".to_sym)
    super
  end

  def respond_to_missing?
    super
  end

  # Naive getter method that is invoked by method_missing
  def getter(method)
    self.instance_variable_get("@#{method}")
  end

  # Naive setter method that is invoked by method_missing
  def setter(method, value)
    self.instance_variable_set("@#{method}", value)
  end
end