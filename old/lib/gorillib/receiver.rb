require 'gorillib/object/blank'
require 'gorillib/object/try'
require 'gorillib/object/try_dup'
require 'gorillib/array/extract_options'
require 'gorillib/metaprogramming/class_attribute'

# dummy type for receiving True or False
class Boolean ; end unless defined?(Boolean)

# Receiver lets you describe complex (even recursive!) actively-typed data models that
# * are creatable or assignable from static data structures
# * perform efficient type conversion when assigning from a data structure,
# * but with nothing in the way of normal assignment or instantiation
# * and no requirements on the initializer
#
#    class Tweet
#      include Receiver
#      rcvr_accessor :id,           Integer
#      rcvr_accessor :user_id,      Integer
#      rcvr_accessor :created_at,   Time
#    end
#    p Tweet.receive(:id => "7", :user_id => 9, :created_at => "20101231010203" )
#     # => #<Tweet @id=7, @user_id=9, @created_at=2010-12-31 07:02:03 UTC>
#
# You can override receive behavior in a straightforward and predictable way:
#
#    class TwitterUser
#      include Receiver
#      rcvr_accessor :id,           Integer
#      rcvr_accessor :screen_name,  String
#      rcvr_accessor :follower_ids, Array, :of => Integer
#      # accumulate unique follower ids
#      def receive_follower_ids(arr)
#        @follower_ids = (@follower_ids||[]) + arr.map(&:to_i)
#        @follower_ids.uniq!
#      end
#    end
#
# The receiver pattern works naturally with inheritance:
#
#    class TweetWithUser < Tweet
#      rcvr_accessor :user, TwitterUser
#      after_receive do |hsh|
#        self.user_id = self.user.id if self.user
#      end
#    end
#    p TweetWithUser.receive(:id => 8675309, :created_at => "20101231010203", :user => { :id => 24601, :screen_name => 'bob', :follower_ids => [1, 8, 3, 4] })
#     => #<TweetWithUser @id=8675309, @created_at=2010-12-31 07:02:03 UTC, @user=#<TwitterUser @id=24601, @screen_name="bob", @follower_ids=[1, 8, 3, 4]>, @user_id=24601>
#
# TweetWithUser was able to add another receiver, applicable only to itself and its subclasses.
#
# The receive method works well with sparse data -- you can accumulate
# attributes without trampling formerly set values:
#
#    tw = Tweet.receive(:id => "7", :user_id => 9 )
#    p tw
#    # => #<Tweet @id=7, @user_id=9>
#
#    tw.receive!(:created_at => "20101231010203" )
#    p tw
#    # => #<Tweet @id=7, @user_id=9, @created_at=2010-12-31 07:02:03 UTC>
#
# Note the distinction between an explicit nil field and a missing field:
#
#    tw.receive!(:user_id => nil, :created_at => "20090506070809" )
#    p tw
#    # => #<Tweet @id=7, @user_id=nil, @created_at=2009-05-06 12:08:09 UTC>
#
# There are helpers for default and required attributes:
#
#    class Foo
#      include Receiver
#      rcvr_accessor :is_reqd,     String, :required => true
#      rcvr_accessor :also_reqd,   String, :required => true
#      rcvr_accessor :has_default, String, :default => 'hello'
#    end
#    foo_obj = Foo.receive(:is_reqd => "hi")
#    # => #<Foo:0x00000100bd9740 @is_reqd="hi" @has_default="hello">
#    foo_obj.missing_attrs
#    # => [:also_reqd]
#
module Receiver

  RECEIVER_BODIES           = {} unless defined?(RECEIVER_BODIES)
  RECEIVER_BODIES[Symbol]   = %q{ v.blank? ? nil : v.to_sym }
  RECEIVER_BODIES[Integer]  = %q{ v.blank? ? nil : v.to_i }
  RECEIVER_BODIES[Float]    = %q{ v.blank? ? nil : v.to_f }
  RECEIVER_BODIES[String]   = %q{ v.to_s }
  RECEIVER_BODIES[Time]     = %q{ v.nil?   ? nil : Time.parse(v.to_s).utc rescue nil }
  RECEIVER_BODIES[Date]     = %q{ v.nil?   ? nil : Date.parse(v.to_s)     rescue nil }
  RECEIVER_BODIES[Array]    = %q{ case when v.nil? then nil when v.blank? then [] else Array(v) end }
  RECEIVER_BODIES[Hash]     = %q{ case when v.nil? then nil when v.blank? then {} else v end }
  RECEIVER_BODIES[Boolean]  = %q{ case when v.nil? then nil when v.to_s.strip.blank? then false else v.to_s.strip != "false" end }
  RECEIVER_BODIES[NilClass] = %q{ raise ArgumentError, "This field must be nil, but [#{v}] was given" unless (v.nil?) ; nil }
  RECEIVER_BODIES[Object]   = %q{ v } # accept and love the object just as it is

  #
  # Give each base class a receive method
  #
  RECEIVER_BODIES.each do |k,b|
    if k.is_a?(Class) && b.is_a?(String)
      k.class_eval <<-STR, __FILE__, __LINE__ + 1
      def self.receive(v)
        #{b}
      end
      STR
    elsif k.is_a?(Class)
      k.class_eval do
        define_singleton_method(:receive, &b)
      end
    end
  end

  TYPE_ALIASES = {
    :null    => NilClass,
    :boolean => Boolean,
    :string  => String,  :bytes   => String,
    :symbol  => Symbol,
    :int     => Integer, :integer => Integer,  :long    => Integer,
    :time    => Time,    :date    => Date,
    :float   => Float,   :double  => Float,
    :hash    => Hash,    :map     => Hash,
    :array   => Array,
  } unless defined?(TYPE_ALIASES)

  #
  # modify object in place with new typecast values.
  #
  def receive! hsh={}
    raise ArgumentError, "Can't receive (it isn't hashlike): {#{hsh.inspect}}" unless hsh.respond_to?(:[]) && hsh.respond_to?(:has_key?)
    _receiver_fields.each do |attr|
      if    hsh.has_key?(attr.to_sym) then val = hsh[attr.to_sym]
      elsif hsh.has_key?(attr.to_s)   then val = hsh[attr.to_s]
      else  next ; end
      _receive_attr attr, val
    end
    impose_defaults!(hsh)
    replace_options!(hsh)
    run_after_receivers(hsh)
    self
  end

  # true if the attr is a receiver variable and it has been set
  def attr_set?(attr)
    receiver_attrs.has_key?(attr) && self.instance_variable_defined?("@#{attr}")
  end

protected

  def unset!(attr)
    self.send(:remove_instance_variable, "@#{attr}") if self.instance_variable_defined?("@#{attr}")
  end

  def _receive_attr attr, val
    self.send("receive_#{attr}", val)
  end

  def _receiver_fields
    self.class.receiver_attr_names
  end

  def _receiver_defaults
    self.class.receiver_defaults
  end

  def _after_receivers
    self.class.after_receivers
  end

  def impose_defaults!(hsh)
    _receiver_defaults.each do |attr, val|
      next if attr_set?(attr)
      self.instance_variable_set "@#{attr}", val.try_dup
    end
  end

  # class Foo
  #   include Receiver
  #   include Receiver::ActsAsHash
  #   rcvr_accessor :attribute, String, :default => 'okay' :replace => { 'bad' => 'good' }
  # end
  #
  # f = Foo.receive({:attribute => 'bad'})
  # => #<Foo:0x10156c820 @attribute="good">
  #
  def replace_options!(hsh)
    self.receiver_attrs.each do |attr, info|
      val = self.instance_variable_get("@#{attr}")
      if info[:replace] and info[:replace].has_key? val
        self.instance_variable_set "@#{attr}", info[:replace][val]
      end
    end
  end

  def run_after_receivers(hsh)
    _after_receivers.each do |after_receiver|
      self.instance_exec(hsh, &after_receiver)
    end
  end

public

  module ClassMethods

    #
    # Returns a new instance with the given hash used to set all rcvrs.
    #
    # All args up to the last one are passed to the initializer.
    # The last arg must be a hash -- its attributes are set on the newly-created object
    #
    # @param hsh [Hash] attr-value pairs to set on the newly created object.
    # @param *args [Array] arguments to pass to the constructor
    # @return [Object] a new instance
    def receive *args
      hsh = args.pop || {}
      raise ArgumentError, "Can't receive (it isn't hashlike): {#{hsh.inspect}} -- the hsh should be the *last* arg" unless hsh.respond_to?(:[]) && hsh.respond_to?(:has_key?)
      obj = self.new(*args)
      obj.receive!(hsh)
    end

    #
    # define a receiver attribute.
    # automatically generates an attr_accessor on the class if none exists
    #
    # @option [Boolean] :required - Adds an error on validation if the attribute is never set
    # @option [Object]  :default  - After any receive! operation, attribute is set to this value unless attr_set? is true
    # @option [Class]   :of       - For collections (Array, Hash, etc), the type of the collection's items
    #
    def rcvr name, type, info={}
      name = name.to_sym
      type = type_to_klass(type)
      body = receiver_body_for(type, info)
      if body.is_a?(String)
        class_eval(%Q{
        def receive_#{name}(v)
          self.instance_variable_set("@#{name}", (#{body}))
        end}, __FILE__, __LINE__ + 1)
      else
        define_method("receive_#{name}") do |*args|
          v = body.call(*args)
          self.instance_variable_set("@#{name}", v)
          v
        end
      end
      # careful here: don't modify parent's class_attribute in-place
      self.receiver_attrs = self.receiver_attrs.dup
      self.receiver_attr_names += [name] unless receiver_attr_names.include?(name)
      self.receiver_attrs[name] = info.merge({ :name => name, :type => type })
    end

    # make a block to run after each time  .receive! is invoked
    def after_receive &block
      self.after_receivers += [block]
    end

    # defines a receiver attribute, an attr_reader and an attr_writer
    # attr_reader is skipped if the getter method is already defined;
    # attr_writer is skipped if the setter method is already defined;
    def rcvr_accessor name, type, info={}
      attr_reader(name) unless method_defined?(name)
      attr_writer(name) unless method_defined?("#{name}=")
      rcvr name, type, info
    end
    # defines a receiver attribute and an attr_reader
    # attr_reader is skipped if the getter method is already defined.
    def rcvr_reader name, type, info={}
      attr_reader(name) unless method_defined?(name)
      rcvr name, type, info
    end
    # defines a receiver attribute and an attr_writer
    # attr_writer is skipped if the setter method is already defined.
    def rcvr_writer name, type, info={}
      attr_writer(name) unless method_defined?("#{name}=")
      rcvr name, type, info
    end

    #
    # Defines a receiver for attributes sent to receive! that are
    # * not defined as receivers
    # * attribute name does not start with '_'
    #
    # @example
    #     class Foo ; include Receiver
    #       rcvr_accessor  :bob, String
    #       rcvr_remaining :other_params
    #     end
    #     foo_obj = Foo.receive(:bob => 'hi, bob", :joe => 'hi, joe')
    #     # => <Foo @bob='hi, bob' @other_params={ :joe => 'hi, joe' }>
    def rcvr_remaining name, info={}
      rcvr_reader name, Hash, info
      after_receive do |hsh|
        remaining_vals_hsh = hsh.reject{|k,v| (receiver_attrs.include?(k)) || (k.to_s =~ /^_/) }
        self._receive_attr name, remaining_vals_hsh
      end
    end

    # a hash from attribute names to their default values if given
    def receiver_defaults
      defs = {}
      receiver_attrs.each do |name, info|
        defs[name] = info[:default] if info.has_key?(:default)
      end
      defs
    end

    # returns an in-order traversal of the
    #
    def tuple_keys
      return @tuple_keys if @tuple_keys
      @tuple_keys = self
      @tuple_keys = receiver_attrs.map do |attr, info|
        info[:type].try(:tuple_keys) || attr
      end.flatten
    end

    def consume_tuple(tuple)
      obj = self.new
      receiver_attrs.each do |attr, info|
        if info[:type].respond_to?(:consume_tuple)
          val = info[:type].consume_tuple(tuple)
        else
          val = tuple.shift
        end
        # obj.send("receive_#{attr}", val)
        obj.send("#{attr}=", val)
      end
      obj
    end

  protected
    def receiver_body_for type, info
      type = type_to_klass(type)
      # Note that Array and Hash only need (and only get) special treatment when
      # they have an :of => SomeType option.
      case
      when info[:of] && (type == Array)
        receiver_type = info[:of]
        lambda{|v|  v.nil? ? nil : v.map{|el| receiver_type.receive(el) } }
      when info[:of] && (type == Hash)
        receiver_type = info[:of]
        lambda{|v| v.nil? ? nil : v.inject({}){|h, (el,val)| h[el] = receiver_type.receive(val); h } }
      when Receiver::RECEIVER_BODIES.include?(type)
        Receiver::RECEIVER_BODIES[type]
      when type.is_a?(Class)
        lambda{|v| v.blank? ? nil : type.receive(v) }
      else
        raise("Can't receive #{type} #{info}")
      end
    end

    def type_to_klass(type)
      case
      when type.is_a?(Class)                             then return type
      when TYPE_ALIASES.has_key?(type)                   then TYPE_ALIASES[type]
      # when (type.is_a?(Symbol) && type.to_s =~ /^[A-Z]/) then type.to_s.constantize
      else raise ArgumentError, "Can\'t handle type #{type}: is it a Class or one of the TYPE_ALIASES?"
      end
    end
  end

  def to_tuple
    tuple = []
    self.each_value do |val|
      if val.respond_to?(:to_tuple)
        tuple += val.to_tuple
      else
        tuple << val
      end
    end
    tuple
  end

  module ClassMethods
    # By default, the hashlike methods iterate over the receiver attributes.
    # If you want to filter our add to the keys list, override this method
    #
    # @example
    #     def self.members
    #       super + [:firstname, :lastname] - [:fullname]
    #     end
    #
    def members
      receiver_attr_names
    end
  end

  # set up receiver attributes, and bring in methods from the ClassMethods module at class-level
  def self.included base
    base.class_eval do
      unless method_defined?(:receiver_attrs)
        class_attribute :receiver_attrs
        class_attribute :receiver_attr_names
        class_attribute :after_receivers
        self.receiver_attrs      = {} # info about the attr
        self.receiver_attr_names = [] # ordered set of attr names
        self.after_receivers     = [] # blocks to execute following receive!
        extend ClassMethods
      end
    end
  end

end
