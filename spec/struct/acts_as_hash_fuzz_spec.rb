require File.dirname(__FILE__)+'/../spec_helper'
require 'gorillib/hashlike'
require 'gorillib/struct/acts_as_hash'
require 'gorillib/hash/indifferent_access'
require File.dirname(__FILE__)+'/../support/hashlike_fuzzing_helper'
require File.dirname(__FILE__)+'/../support/hashlike_helper'
require File.dirname(__FILE__)+'/../support/hashlike_struct_helper'

#
# Don't test the built-in Struct methods.
#
# Also, all the enumerable methods behave differently -- they build off each
# (which iterates like an array), not each_pair (which iterates like a hash)
#
STRUCT_HASHLIKE_METHODS_TO_SKIP = [:each, :flatten, :clear, :values_at] +
  Enumerable.public_instance_methods.map(&:to_sym) +
  HashlikeFuzzingHelper::HASH_METHODS_MISSING_FROM_VERSION

include HashlikeFuzzingHelper

describe "Hash vs Gorillib::Struct::ActsAsHash" do
  before do
    @total = 0
    @hsh      = HASH_TO_TEST_HASHLIKE_STRUCT.dup
    @hshlike  = StructUsingHashlike.new.merge(HASH_TO_TEST_HASHLIKE_STRUCT)
  end

  ( HashlikeFuzzingHelper::METHODS_TO_TEST - STRUCT_HASHLIKE_METHODS_TO_SKIP ).each do |method_to_test|
    describe "##{method_to_test}" do

      (HashlikeFuzzingHelper::INPUTS_FOR_ALL_HASHLIKES).each do |input|
        next if HashlikeFuzzingHelper::SPECIAL_CASES_FOR_HASHLIKE_STRUCT[method_to_test].include?(input)

        it "on #{input.inspect}" do
          behaves_the_same(@hsh, @hshlike, method_to_test, input)
        end
      end
    end
  end
end

describe "Gorillib::HashWithIndifferentSymbolKeys vs Gorillib::Struct::ActsAsHash" do
  before do
    @total = 0
    @hsh      = Gorillib::HashWithIndifferentSymbolKeys.new_from_hash_copying_default(
      HASH_TO_TEST_HASHLIKE_STRUCT)
    @hshlike  = StructUsingHashlike.new.merge(
      HASH_TO_TEST_HASHLIKE_STRUCT)
  end

  ( HashlikeFuzzingHelper::METHODS_TO_TEST - STRUCT_HASHLIKE_METHODS_TO_SKIP
    ).each do |method_to_test|
    describe "##{method_to_test}" do

      ( HashlikeFuzzingHelper::INPUTS_WHEN_INDIFFERENT_ACCESS +
        HashlikeFuzzingHelper::INPUTS_FOR_ALL_HASHLIKES
        ).each do |input|
        next if HashlikeFuzzingHelper::SPECIAL_CASES_FOR_HASHLIKE_STRUCT[method_to_test].include?(input)

        it "on #{input.inspect}" do
          behaves_the_same(@hsh, @hshlike, method_to_test, input)
        end

      end
    end
  end
end
