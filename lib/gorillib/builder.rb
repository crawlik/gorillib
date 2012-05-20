require 'gorillib/string/simple_inflector'
require 'gorillib/model'
require 'gorillib/model/field'
require 'gorillib/model/defaults'

module Gorillib
  module Builder
    extend  Gorillib::Concern
    include Gorillib::Model

    def initialize(attrs={}, &block)
      receive!(attrs, &block)
    end

    def receive!(*args, &block)
      super(*args)
      if block_given?
        (block.arity == 1) ? block.call(self) : self.instance_eval(&block)
      end
      self
    end

    def getset(field, *args, &block)
      ArgumentError.check_arity!(args, 0..1)
      if args.empty?
        read_attribute(field.name)
      else
        write_attribute(field.name, args.first)
      end
    end

    def getset_member(field, *args, &block)
      ArgumentError.check_arity!(args, 0..1)
      attrs = args.first
      if attrs.is_a?(field.type)        # actual object: assign it into field
        val = attrs
        write_attribute(field.name, val)
      else
        val = read_attribute(field.name)
        if val.present?
          val.receive!(*args, &block) if args.present?
        elsif attrs.blank?  # missing item (read): return nil
          return nil
        else                              # missing item (write): construct item and add to collection
          val = field.type.receive(*args, &block)
          write_attribute(field.name, val)
        end
      end
      val
    end

    def getset_collection_item(field, item_key, attrs={}, &block)
      clxn = collection_of(field.plural_name)
      if attrs.is_a?(field.item_type)     # actual object: assign it into collection
        val = attrs
        clxn[item_key] = val
      elsif clxn.include?(item_key)  # existing item: retrieve it, updating as directed
        val = clxn[item_key]
        val.receive!(attrs, &block)
      else                           # missing item: autovivify item and add to collection
        val = field.item_type.receive({ key_method => item_key, :owner => self }.merge(attrs), &block)
        clxn[item_key] = val
      end
      val
    end

    def key_method
      :name
    end

    def collection_of(plural_name)
      self.read_attribute(plural_name)
    end

    module ClassMethods
      include Gorillib::Model::ClassMethods

      def field(field_name, type, options={})
        super(field_name, type, {:field_type => ::Gorillib::Builder::GetsetField}.merge(options))
      end
      def member(field_name, type, options={})
        field(field_name, type, {:field_type => ::Gorillib::Builder::MemberField}.merge(options))
      end
      def collection(field_name, item_type, options={})
        field(field_name, Gorillib::Collection, {
            :item_type => item_type,
            :field_type => ::Gorillib::Builder::CollectionField}.merge(options))
      end
      def simple_field(field_name, type, options={})
        field(field_name, type, {:field_type => ::Gorillib::Model::Field}.merge(options))
      end

    protected

      def define_attribute_getset(field)
        field_name = field.name; type = field.type
        define_meta_module_method(field_name, field.visibility(:reader)) do |*args, &block|
          begin
            getset(field, *args, &block)
          rescue StandardError => err
            err.backtrace.
              detect{|l| l.include?(__FILE__) && l.include?("in define_attribute_getset'") }.
              gsub!(/define_attribute_getset'/, "define_attribute_getset for #{self.class}.#{field_name} type #{type} on #{args}'"[0..300]) rescue nil
            raise
          end
        end
      end

      def define_member_getset(field)
        field_name = field.name; type = field.type
        define_meta_module_method(field_name, field.visibility(:reader)) do |*args, &block|
          begin
            getset_member(field, *args, &block)
          rescue StandardError => err
            err.backtrace.
              detect{|l| l.include?(__FILE__) && l.include?("in define_member_getset'") }.
              gsub!(/define_member_getset'/, "define_member_getset for #{self.class}.#{field_name} type #{type} on #{args}'"[0..300]) rescue nil
            raise
          end
        end
      end

      def define_collection_getset(field)
        field_name = field.name; item_type = field.item_type
        define_meta_module_method(field.singular_name, field.visibility(:collection_getset)) do |*args, &block|
          begin
            getset_collection_item(field, *args, &block)
          rescue StandardError => err
            err.backtrace.
              detect{|l| l.include?(__FILE__) && l.include?("in define_collection_getset'") }.
              gsub!(/define_collection_getset'/, "define_collection_getset for #{self.class}.#{field_name} c[#{item_type}] on #{args}'"[0..300]) rescue nil
            raise
          end
        end
      end

      def define_collection_tester(field)
        plural_name = field.plural_name
        define_meta_module_method("has_#{field.singular_name}?", field.visibility(:collection_tester)) do |item_key|
          begin
            collection_of(plural_name).include?(item_key)
          rescue StandardError => err
            err.backtrace.
              detect{|l| l.include?(__FILE__) && l.include?("in define_collection_tester'") }.
              gsub!(/define_collection_tester'/, "define_collection_tester for #{self.class}.#{field_name} type #{type}'") rescue nil
            raise
          end
        end
      end

    end
  end

  module FancyBuilder
    extend  Gorillib::Concern
    include Gorillib::Builder

    def inspect(detailed=true)
      str = super
      detailed ? str : ([str[0..-2], " #{read_attribute(key_method)}>"].join)
    end

    included do |base|
      base.field :name,  Symbol
    end

    module ClassMethods
      include Gorillib::Builder::ClassMethods

      def belongs_to(field_name, type, options={})
        field = field(field_name, type, {:field_type => ::Gorillib::Builder::MemberField }.merge(options))
        define_meta_module_method "#{field.name}_name" do
          val = getset_member(field) or return nil
          val.name
        end
        field
      end

      def option(field_name, options={})
        type = options.delete(:type){ Whatever }
        field(field_name, type, {:field_type => ::Gorillib::Builder::GetsetField }.merge(options))
      end

      def collects(type, clxn_name)
        type_handle = type.handle
        define_meta_module_method type_handle do |item_name, attrs={}, options={}, &block|
          send(clxn_name, item_name, attrs, options.merge(:factory => type), &block)
        end
      end
    end
  end

  module Builder

    class GetsetField < Gorillib::Model::Field
      self.visibilities = visibilities.merge(:writer => false, :tester => false, :getset => true)
      def inscribe_methods(model)
        model.__send__(:define_attribute_getset,   self)
        model.__send__(:define_attribute_writer,   self)
        model.__send__(:define_attribute_tester,   self)
        model.__send__(:define_attribute_receiver, self)
      end
    end

    class MemberField < Gorillib::Model::Field
      self.visibilities = visibilities.merge(:writer => false, :tester => true)
      def inscribe_methods(model)
        model.__send__(:define_member_getset,      self)
        model.__send__(:define_attribute_writer,   self)
        model.__send__(:define_attribute_tester,   self)
        model.__send__(:define_attribute_receiver, self)
      end
    end

    class CollectionField < Gorillib::Model::Field
      field :singular_name, Symbol, :default => ->{ Gorillib::Inflector.singularize(name.to_s).to_sym }
      field :item_type, Class, :default => Whatever

      self.visibilities = visibilities.merge(:writer => false, :tester => false,
        :collection_getset => :public, :collection_tester => true)

      alias_method :plural_name, :name
      def singular_name
        @singular_name ||= Gorillib::Inflector.singularize(name.to_s).to_sym
      end

      def inscribe_methods(model)
        item_type      = self.item_type
        self.default   = ->{ Gorillib::Collection.new(item_type) }
        raise "Plural and singular names must differ: #{self.plural_name}" if (singular_name == plural_name)
        #
        @visibilities[:writer] = false
        super
        #
        model.__send__(:define_collection_getset,  self)
        model.__send__(:define_collection_tester,  self)
      end
    end

  end
end
