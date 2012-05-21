module Gorillib
  module Model

    # Represents a field for reflection
    #
    # @example Usage
    #   Gorillib::Model::Field.new(:name => 'problems', type => Integer, :doc => 'Count of problems')
    #
    #
    class Field
      include Gorillib::Model
      remove_possible_method(:type)

      # [Gorillib::Model] Model owning this field
      attr_reader :model

      # [Hash] all options passed to the field not recognized by one of its own current fields
      attr_reader :extra_attributes

      # Note: `Gorillib::Model::Field` is assembled in two pieces, so that it
      # can behave as a model itself. Defining `name` here, along with some
      # fudge in #initialize, provides enough functionality to bootstrap.
      # The fields are then defined properly at the end of the file.

      attr_reader :name
      attr_reader :type

      class_attribute :visibilities, :instance_writer => false
      self.visibilities = { :reader => :public, :writer => :public, :receiver => :public, :tester => false }


      # @param [#to_sym]                name    Field name
      # @param [#receive]               type    Factory for field values. To accept any object as-is, specify `Object` as the type.
      # @param [Gorillib::Model]       model   Field's owner
      # @param [Hash{Symbol => Object}] options Extended attributes
      # @option options [String] doc Description of the field's purpose
      # @option options [true, false, :public, :protected, :private] :reader   Visibility for the reader (`#foo`) method; `false` means don't create one.
      # @option options [true, false, :public, :protected, :private] :writer   Visibility for the writer (`#foo=`) method; `false` means don't create one.
      # @option options [true, false, :public, :protected, :private] :receiver Visibility for the receiver (`#receive_foo`) method; `false` means don't create one.
      #
      def initialize(name, type, model, options={})
        Validate.identifier!(name)
        @model            = model
        @name             = name.to_sym
        @type             = self.factory_for(type)
        default_visabilities = visibilities
        @visibilities     = default_visabilities.merge( options.extract!(*default_visabilities.keys) )
        @doc              = options.delete(:name){ "#{name} field" }
        receive!(options)
      end

      # __________________________________________________________________________

      # @return [String] the field name
      def to_s
        name.to_s
      end

      def factory_for(type)
        Gorillib::Factory(type)
      end

      # @return [String] Human-readable presentation of the field definition
      def inspect
        args = [name.inspect, type.to_s]
        "field(#{args.join(", ")})"
      end

      def to_hash
        attributes.merge!(@visibility).merge!(@extra_attributes)
      end

      def ==(val)
        super && (val.extra_attributes == self.extra_attributes) && (val.model == self.model)
      end

      def self.receive(hsh)
        name  = hsh.fetch(:name)
        type  = hsh.fetch(:type)
        model = hsh.fetch(:model)
        new(name, type, model, hsh)
      end

      #
      # returns the visibility
      #
      # @example reader is protected, no writer:
      #   Foo.field :granuloxity, :reader => :protected, :writer => false
      #
      def visibility(meth_type)
        Validate.included_in!("method type", meth_type, @visibilities.keys)
        @visibilities[meth_type]
      end

    protected

      #
      #
      #
      def inscribe_methods(model)
        model.__send__(:define_attribute_reader,   self.name, self.type, visibility(:reader))
        model.__send__(:define_attribute_writer,   self.name, self.type, visibility(:writer))
        model.__send__(:define_attribute_tester,   self.name, self.type, visibility(:tester))
        model.__send__(:define_attribute_receiver, self.name, self.type, visibility(:receiver))
      end

    public

      #
      # Now we can construct the actual fields.
      #

      # Name of this field. Must start with `[A-Za-z_]` and subsequently contain only `[A-Za-z0-9_]` (required)
      # @macro [attach] field
      #   @attribute $1
      #   @return [$2] the $1 field $*
      field :name, String, :writer => false, :doc => "The field name. Must start with `[A-Za-z_]` and subsequently contain only `[A-Za-z0-9_]` (required)"

      # Factory for the field's values
      field :type, Class

      # Field's description
      field :doc, String

      # remove the attr_reader method (needed for scaffolding), leaving the meta_module method to remain
      remove_possible_method(:name)

    end
  end
end

# * aliases
# * order
# * dirty
# * lazy
# * mass assignable
# * identifier / index
# * hook
# * validates / required
#   - presence     => true
#   - uniqueness   => true
#   - numericality => true             # also :==, :>, :>=, :<, :<=, :odd?, :even?, :equal_to, :less_than, etc
#   - length       => { :<  => 7 }     # also :==, :>=, :<=, :is, :minimum, :maximum
#   - format       => { :with => /.*/ }
#   - inclusion    => { :in => [1,2,3] }
#   - exclusion    => { :in => [1,2,3] }
