# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "gorillib"
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Infochimps"]
  s.date = "2012-10-21"
  s.description = "Gorillib: infochimps lightweight subset of ruby convenience methods"
  s.email = "coders@infochimps.org"
  s.extra_rdoc_files = [
    "CHANGELOG.md",
    "LICENSE.md",
    "README.md",
    "TODO.md",
    "notes/HOWTO.md",
    "notes/bucket.md",
    "notes/builder.md",
    "notes/collection.md",
    "notes/factories.md",
    "notes/model-overlay.md",
    "notes/model.md",
    "notes/structured-data-classes.md"
  ]
  s.files = [
    ".gitignore",
    ".rspec",
    ".yardopts",
    "CHANGELOG.md",
    "Gemfile",
    "Guardfile",
    "LICENSE.md",
    "README.md",
    "Rakefile",
    "TODO.md",
    "VERSION",
    "examples/benchmark/factories_benchmark.rb",
    "examples/builder/ironfan.rb",
    "examples/hash/slicing_methods.rb",
    "examples/model/simple.rb",
    "gorillib.gemspec",
    "lib/gorillib.rb",
    "lib/gorillib/array/compact_blank.rb",
    "lib/gorillib/array/deep_compact.rb",
    "lib/gorillib/array/extract_options.rb",
    "lib/gorillib/array/hashify.rb",
    "lib/gorillib/array/simple_statistics.rb",
    "lib/gorillib/array/wrap.rb",
    "lib/gorillib/base.rb",
    "lib/gorillib/builder.rb",
    "lib/gorillib/collection.rb",
    "lib/gorillib/collection/model_collection.rb",
    "lib/gorillib/configurable.rb",
    "lib/gorillib/data_munging.rb",
    "lib/gorillib/datetime/parse.rb",
    "lib/gorillib/datetime/to_flat.rb",
    "lib/gorillib/deprecated/array/average.rb",
    "lib/gorillib/deprecated/array/random.rb",
    "lib/gorillib/deprecated/array/sorted_median.rb",
    "lib/gorillib/deprecated/array/sorted_percentile.rb",
    "lib/gorillib/deprecated/array/sorted_sample.rb",
    "lib/gorillib/deprecated/metaprogramming/aliasing.rb",
    "lib/gorillib/enumerable/sum.rb",
    "lib/gorillib/exception/raisers.rb",
    "lib/gorillib/factories.rb",
    "lib/gorillib/hash/compact.rb",
    "lib/gorillib/hash/deep_compact.rb",
    "lib/gorillib/hash/deep_dup.rb",
    "lib/gorillib/hash/deep_merge.rb",
    "lib/gorillib/hash/keys.rb",
    "lib/gorillib/hash/mash.rb",
    "lib/gorillib/hash/reverse_merge.rb",
    "lib/gorillib/hash/slice.rb",
    "lib/gorillib/hash/zip.rb",
    "lib/gorillib/hashlike.rb",
    "lib/gorillib/hashlike/compact.rb",
    "lib/gorillib/hashlike/deep_compact.rb",
    "lib/gorillib/hashlike/deep_dup.rb",
    "lib/gorillib/hashlike/deep_hash.rb",
    "lib/gorillib/hashlike/deep_merge.rb",
    "lib/gorillib/hashlike/hashlike_via_accessors.rb",
    "lib/gorillib/hashlike/keys.rb",
    "lib/gorillib/hashlike/reverse_merge.rb",
    "lib/gorillib/hashlike/slice.rb",
    "lib/gorillib/logger/log.rb",
    "lib/gorillib/metaprogramming/class_attribute.rb",
    "lib/gorillib/metaprogramming/concern.rb",
    "lib/gorillib/metaprogramming/delegation.rb",
    "lib/gorillib/metaprogramming/remove_method.rb",
    "lib/gorillib/metaprogramming/singleton_class.rb",
    "lib/gorillib/model.rb",
    "lib/gorillib/model/active_model_conversion.rb",
    "lib/gorillib/model/active_model_naming.rb",
    "lib/gorillib/model/active_model_shim.rb",
    "lib/gorillib/model/base.rb",
    "lib/gorillib/model/defaults.rb",
    "lib/gorillib/model/doc_string.rb",
    "lib/gorillib/model/errors.rb",
    "lib/gorillib/model/factories.rb",
    "lib/gorillib/model/field.rb",
    "lib/gorillib/model/fixup.rb",
    "lib/gorillib/model/indexable.rb",
    "lib/gorillib/model/lint.rb",
    "lib/gorillib/model/named_schema.rb",
    "lib/gorillib/model/overlay.rb",
    "lib/gorillib/model/positional_fields.rb",
    "lib/gorillib/model/reconcilable.rb",
    "lib/gorillib/model/schema_magic.rb",
    "lib/gorillib/model/serialization.rb",
    "lib/gorillib/model/serialization/csv.rb",
    "lib/gorillib/model/serialization/json.rb",
    "lib/gorillib/model/serialization/lines.rb",
    "lib/gorillib/model/serialization/tsv.rb",
    "lib/gorillib/model/validate.rb",
    "lib/gorillib/numeric/clamp.rb",
    "lib/gorillib/object/blank.rb",
    "lib/gorillib/object/try.rb",
    "lib/gorillib/object/try_dup.rb",
    "lib/gorillib/pathname.rb",
    "lib/gorillib/pathname/utils.rb",
    "lib/gorillib/serialization/to_wire.rb",
    "lib/gorillib/some.rb",
    "lib/gorillib/string/constantize.rb",
    "lib/gorillib/string/human.rb",
    "lib/gorillib/string/inflections.rb",
    "lib/gorillib/string/inflector.rb",
    "lib/gorillib/string/simple_inflector.rb",
    "lib/gorillib/string/truncate.rb",
    "lib/gorillib/type/boolean.rb",
    "lib/gorillib/type/extended.rb",
    "lib/gorillib/type/ip_address.rb",
    "lib/gorillib/type/url.rb",
    "lib/gorillib/utils/capture_output.rb",
    "lib/gorillib/utils/console.rb",
    "lib/gorillib/utils/edge_cases.rb",
    "lib/gorillib/utils/nuke_constants.rb",
    "notes/HOWTO.md",
    "notes/bucket.md",
    "notes/builder.md",
    "notes/collection.md",
    "notes/factories.md",
    "notes/model-overlay.md",
    "notes/model.md",
    "notes/structured-data-classes.md",
    "spec/examples/builder/ironfan_spec.rb",
    "spec/extlib/hash_spec.rb",
    "spec/extlib/mash_spec.rb",
    "spec/gorillib/array/compact_blank_spec.rb",
    "spec/gorillib/array/extract_options_spec.rb",
    "spec/gorillib/array/hashify_spec.rb",
    "spec/gorillib/array/simple_statistics_spec.rb",
    "spec/gorillib/builder_spec.rb",
    "spec/gorillib/collection_spec.rb",
    "spec/gorillib/configurable_spec.rb",
    "spec/gorillib/datetime/parse_spec.rb",
    "spec/gorillib/datetime/to_flat_spec.rb",
    "spec/gorillib/enumerable/sum_spec.rb",
    "spec/gorillib/exception/raisers_spec.rb",
    "spec/gorillib/factories_spec.rb",
    "spec/gorillib/hash/compact_spec.rb",
    "spec/gorillib/hash/deep_compact_spec.rb",
    "spec/gorillib/hash/deep_merge_spec.rb",
    "spec/gorillib/hash/keys_spec.rb",
    "spec/gorillib/hash/reverse_merge_spec.rb",
    "spec/gorillib/hash/slice_spec.rb",
    "spec/gorillib/hash/zip_spec.rb",
    "spec/gorillib/hashlike/behave_same_as_hash_spec.rb",
    "spec/gorillib/hashlike/deep_hash_spec.rb",
    "spec/gorillib/hashlike/hashlike_behavior_spec.rb",
    "spec/gorillib/hashlike/hashlike_via_accessors_spec.rb",
    "spec/gorillib/hashlike_spec.rb",
    "spec/gorillib/logger/log_spec.rb",
    "spec/gorillib/metaprogramming/class_attribute_spec.rb",
    "spec/gorillib/metaprogramming/delegation_spec.rb",
    "spec/gorillib/metaprogramming/singleton_class_spec.rb",
    "spec/gorillib/model/defaults_spec.rb",
    "spec/gorillib/model/indexable_spec.rb",
    "spec/gorillib/model/lint_spec.rb",
    "spec/gorillib/model/overlay_spec.rb",
    "spec/gorillib/model/reconcilable_spec.rb",
    "spec/gorillib/model/serialization/tsv_spec.rb",
    "spec/gorillib/model/serialization_spec.rb",
    "spec/gorillib/model_spec.rb",
    "spec/gorillib/numeric/clamp_spec.rb",
    "spec/gorillib/object/blank_spec.rb",
    "spec/gorillib/object/try_dup_spec.rb",
    "spec/gorillib/object/try_spec.rb",
    "spec/gorillib/pathname_spec.rb",
    "spec/gorillib/string/constantize_spec.rb",
    "spec/gorillib/string/human_spec.rb",
    "spec/gorillib/string/inflections_spec.rb",
    "spec/gorillib/string/inflector_test_cases.rb",
    "spec/gorillib/string/truncate_spec.rb",
    "spec/gorillib/type/extended_spec.rb",
    "spec/gorillib/type/ip_address_spec.rb",
    "spec/gorillib/utils/capture_output_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/factory_test_helpers.rb",
    "spec/support/gorillib_test_helpers.rb",
    "spec/support/hashlike_fuzzing_helper.rb",
    "spec/support/hashlike_helper.rb",
    "spec/support/hashlike_struct_helper.rb",
    "spec/support/hashlike_via_delegation.rb",
    "spec/support/matchers/be_array_eql.rb",
    "spec/support/matchers/be_hash_eql.rb",
    "spec/support/matchers/enumerate_method.rb",
    "spec/support/matchers/evaluate_to_true.rb",
    "spec/support/model_test_helpers.rb",
    "spec/support/shared_examples/included_module.rb"
  ]
  s.homepage = "https://github.com/infochimps-labs/gorillib"
  s.licenses = ["Apache 2.0"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "include only what you need. No dependencies, no creep"
  s.test_files = ["spec/examples/builder/ironfan_spec.rb", "spec/extlib/hash_spec.rb", "spec/extlib/mash_spec.rb", "spec/gorillib/array/compact_blank_spec.rb", "spec/gorillib/array/extract_options_spec.rb", "spec/gorillib/array/hashify_spec.rb", "spec/gorillib/array/simple_statistics_spec.rb", "spec/gorillib/builder_spec.rb", "spec/gorillib/collection_spec.rb", "spec/gorillib/configurable_spec.rb", "spec/gorillib/datetime/parse_spec.rb", "spec/gorillib/datetime/to_flat_spec.rb", "spec/gorillib/enumerable/sum_spec.rb", "spec/gorillib/exception/raisers_spec.rb", "spec/gorillib/factories_spec.rb", "spec/gorillib/hash/compact_spec.rb", "spec/gorillib/hash/deep_compact_spec.rb", "spec/gorillib/hash/deep_merge_spec.rb", "spec/gorillib/hash/keys_spec.rb", "spec/gorillib/hash/reverse_merge_spec.rb", "spec/gorillib/hash/slice_spec.rb", "spec/gorillib/hash/zip_spec.rb", "spec/gorillib/hashlike/behave_same_as_hash_spec.rb", "spec/gorillib/hashlike/deep_hash_spec.rb", "spec/gorillib/hashlike/hashlike_behavior_spec.rb", "spec/gorillib/hashlike/hashlike_via_accessors_spec.rb", "spec/gorillib/hashlike_spec.rb", "spec/gorillib/logger/log_spec.rb", "spec/gorillib/metaprogramming/class_attribute_spec.rb", "spec/gorillib/metaprogramming/delegation_spec.rb", "spec/gorillib/metaprogramming/singleton_class_spec.rb", "spec/gorillib/model/defaults_spec.rb", "spec/gorillib/model/indexable_spec.rb", "spec/gorillib/model/lint_spec.rb", "spec/gorillib/model/overlay_spec.rb", "spec/gorillib/model/reconcilable_spec.rb", "spec/gorillib/model/serialization/tsv_spec.rb", "spec/gorillib/model/serialization_spec.rb", "spec/gorillib/model_spec.rb", "spec/gorillib/numeric/clamp_spec.rb", "spec/gorillib/object/blank_spec.rb", "spec/gorillib/object/try_dup_spec.rb", "spec/gorillib/object/try_spec.rb", "spec/gorillib/pathname_spec.rb", "spec/gorillib/string/constantize_spec.rb", "spec/gorillib/string/human_spec.rb", "spec/gorillib/string/inflections_spec.rb", "spec/gorillib/string/inflector_test_cases.rb", "spec/gorillib/string/truncate_spec.rb", "spec/gorillib/type/extended_spec.rb", "spec/gorillib/type/ip_address_spec.rb", "spec/gorillib/utils/capture_output_spec.rb", "spec/spec_helper.rb", "spec/support/factory_test_helpers.rb", "spec/support/gorillib_test_helpers.rb", "spec/support/hashlike_fuzzing_helper.rb", "spec/support/hashlike_helper.rb", "spec/support/hashlike_struct_helper.rb", "spec/support/hashlike_via_delegation.rb", "spec/support/matchers/be_array_eql.rb", "spec/support/matchers/be_hash_eql.rb", "spec/support/matchers/enumerate_method.rb", "spec/support/matchers/evaluate_to_true.rb", "spec/support/model_test_helpers.rb", "spec/support/shared_examples/included_module.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<multi_json>, [">= 1.1"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<configliere>, [">= 0.4.13"])
      s.add_development_dependency(%q<bundler>, ["~> 1.1"])
      s.add_development_dependency(%q<jeweler>, [">= 1.6"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.8"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0.7"])
    else
      s.add_dependency(%q<multi_json>, [">= 1.1"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<configliere>, [">= 0.4.13"])
      s.add_dependency(%q<bundler>, ["~> 1.1"])
      s.add_dependency(%q<jeweler>, [">= 1.6"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.8"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0.7"])
    end
  else
    s.add_dependency(%q<multi_json>, [">= 1.1"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<configliere>, [">= 0.4.13"])
    s.add_dependency(%q<bundler>, ["~> 1.1"])
    s.add_dependency(%q<jeweler>, [">= 1.6"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.8"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0.7"])
  end
end

