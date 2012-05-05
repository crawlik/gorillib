require 'gorillib/metaprogramming/delegation'
require 'gorillib/metaprogramming/class_attribute'

module Gorillib
  class Collection
    # [String, Symbol] Method invoked on a new item to generate its collection key; :to_key by default
    attr_reader :key_method
    # The default `key_method` invoked on a new item to generate its collection key
    DEFAULT_KEY_METHOD = :to_key

    # [Class, #receive] Factory for generating a new collection item. Object by default (meaning items are adopted as-is
    class_attribute :factory, :instance_writer => false
    singleton_class.class_eval{ protected :factory= }
    
    # [{Symbol => Object}] The actual store of items, but not for you to mess with
    attr_reader :clxn
    protected   :clxn

    delegate :[], :[]=, :delete, :fetch,                  :to => :clxn
    delegate :keys, :values, :each_pair, :each_value,     :to => :clxn
    delegate :has_key?, :length, :size, :empty?, :blank?, :to => :clxn

    def initialize(clxn={}, factory=nil, key_method=DEFAULT_KEY_METHOD)
      @key_method  = key_method
      @factory     = factory unless factory.nil?
      @clxn        = convert_collection(clxn)
    end

    # @return [Array] an array holding the items
    def to_a    ; values    ; end
    # @return [{Symbol => Object}] a hash of key=>item pairs
    def to_hash ; clxn.dup  ; end

    # Merge the new items in-place; given items clobber existing items
    # @param  [{Symbol => Object}, Array<Object>] a hash of key=>item pairs or a list of items
    # @return [Gorillib::Collection] the collection
    def merge!(other)
      clxn.merge!( convert_collection(other) )
      self
    end
    alias_method :concat,   :merge!
    alias_method :receive!, :merge!

    def self.receive(clxn)
      raise NoMethodError.unimplemented_method(self)
    end

    # Merge the new items into a new collection; given items clobber existing items
    # @param  [{Symbol => Object}, Array<Object>] a hash of key=>item pairs or a list of items
    # @return [Gorillib::Collection] a new merged collection
    def merge(other)
      dup.merge!(other)
    end

    def create(raw_item)
      item = factory.receive(raw_item)
      self << item
      item
    end

    # Adds an item in-place
    # @return [Gorillib::Collection] the collection
    def <<(val)
      merge! [val]
      self
    end

    # @return [String] string describing the collection's array representation
    def to_s           ; to_a.to_s           ; end
    # @return [String] string describing the collection's array representation
    def inspect        ; to_a.inspect        ; end
    # @return [Array] serializable array representation of the collection
    def as_json(*args) ; to_a.as_json(*args) ; end
    # @return [String] JSON serialization of the collection's array representation
    def to_json(*args) ; to_a.to_json(*args) ; end

  protected

    # - if the given collection responds_to `to_hash`, it is merged into the internal collection; each hash key *must* match the id of its value or results are undefined.
    # - otherwise, it merges a hash generates from the id/value pairs of each object in the given collection.
    def convert_collection(cc)
      return cc.to_hash if cc.respond_to?(:to_hash)
      cc.inject({}) do |acc, val|
        key = val.public_send(key_method).to_sym
        acc[key] = val
        acc
      end
    end
  end

end