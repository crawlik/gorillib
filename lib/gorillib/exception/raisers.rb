Exception.class_eval do
  def self.caller_parts
    p caller[1]
    mg = %r{\A([^:]+):(\d+):in \`([^\']+)\'\z}.match(caller[1]) or return [caller[1], 1, 'unknown']
    [mg[1], mg[2].to_i, mg[3]]
  end
end

ArgumentError.class_eval do
  #
  #
  # @example `*args` distinguishes between no args and a nil arg, but we have to handle error ourselves
  #   define_method(field_name) do |*args|
  #     raise ArgumentError.wrong_number(*args.length, 1) unless *
  #   end
  #
  def self.wrong_number(expected, got)
    raise
  end

  def self.check_arity!(args, allowed_arity)
    allowed_arity = (allowed_arity .. allowed_arity) if allowed_arity.is_a?(Fixnum)
    return true if allowed_arity.include?(args.length)
    raise self.new("wrong number of arguments (#{args.length} for #{allowed_arity})")
  end

  def self.arity_at_least!(args, min_arity)
    return true if min_arity <= args.length
    raise self.new("wrong number of arguments (#{args.length} for #{min_arity}..#{min_arity})")
  end
end

NoMethodError.class_eval do
  MESSAGE = "undefined method `%s' for %s:%s"

  def self.undefined_method(obj)
    file, line, meth = caller_parts
    self.new(MESSAGE % [meth, obj, obj.class])
  end

  def self.unimplemented_method(obj)
    file, line, meth = caller_parts
    self.new("#{MESSAGE} -- not implemented yet" % [meth, obj, obj.class])
  end

  def self.abstract(obj)
    file, line, meth = caller_parts
    self.new("#{MESSAGE} -- must be implemented by the subclass" % [meth, obj, obj.class])
  end

end
