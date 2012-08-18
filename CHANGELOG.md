# Gorillib Changelog

## Version 1.0


### 2012-08 - Version 1.0.3-pre

#### Deprecations

The following have been relocated to `gorillib/deprecated/{old name}`. So, if you were using `gorillib/array/random` and can't stand to migrate yet, just include `gorillib/deprecated/array/random` instead.

* deprecated `Array#random_element` -- `Array#sample` exists.
* combined `array/average`, `array/sorted_median` and `array/sorted_percentile` under `array/simple_statistics`. Just include that instead.
  - `Array#average`, `Array#sorted_median` and `Array#sorted_percentile` are not deprecated, just moved.
  - `Array#sorted_sample` is now `Array#sorted_nths`. There is a `sample` method on array with a non-similar purpose. Also modified it to land on the half-stride: `[1,2,3,4,5].sorted_nths(2)` is `[2,4]` not `[3,5]`.
  - metaprogramming/aliasing.rb


#### Organized files in `gorillib/model`

* `gorillib/model/factories` is now `gorillib/factories.rb`
* `gorillib/builder/field` was empty, removed it

#### Questions

* move `compact_blank`, `deep_compact` to `enumerable/compact`? 

#### Other

* stripping back the gem dependencies.
  - `json` & `OJ` alongside bundler and rake in the `:development` group


### 2012-06 - Version 1.0.2-pre: First wave of refactors

**positional args**:

* You must explicitly declare the field to be positional in its definition: 

      class Smurf
        include Gorillib::Model
        field :smurfiness, Integer, :position => 0
        field :weapon, String, :position => 1
      end
    
    Positions must be non-conflicting and in minimal order: if a subclass would bomb out if it declared `field :foo, Whatever, :position => 1` (or any position besides `2`).

* Builder's `receive!` method returns the *block*'s return value, not `self`.


### 2012-06 - Version 1.0.1-pre: First wave of refactors

**model**: 

* `receive!` is now called from the initiailizer.

* the initializer now takes `(*positional_args, attrs)`, assembles the `positional_args` into the attrs, and hands them to `receive!`.

* the way you get a "magic get-set attribute" in builder is by saying `magic`, not `field` -- `field` means the same thing as it does in model.

**collection**: 

Gorillib::Collection has been broken up as follows:

* A generic collection stores objects uniquely, in the order added. It responds to:
  - receive!, values, to_a, each and each_value;
  - length, size, empty?, blank?

* `Gorillib::Collection` additionally lets you store and retrieve things by label:
  - [], []=, include?, fetch, delete, each_pair, to_hash.

* `Gorillib::ModelCollection` adds:
  - `key_method`: called on objects to get their key; `to_key` by default.
  - `factory`: generates new objects, converts received objects
  - `<<`: adds object under its `key_method` key
  - `receive!`s an array by auto-keying the elements, or a hash by trusting what you give it
  - `update_or_create: if absent, creates object with given attributes and
    `key_method => key`; if present, updates with given attributes.

what this means for you:
* `Collection` no longer has factory functionality -- that is now in `ModelCollection`. 
* The signature of `ModelCollection#initialize` is `initialize(key_meth, factory)` -- the reverse of what was.


### 2012-04 - Version 1.0.0-pre: DSL Magic

#### New functionality

* `pathname/path_to`            -- templated file paths
* `serialization/to_zaml`       -- predictable, structured YAML writer
* `test_helpers/capture_output` -- swallows $stdout/$stderr for testing purposes

#### Renamed

* moved `gorillib/serialization` to `gorillib/serialization/to_wire`
* renamed `datetime/flat` to `datetime/to_flat`

#### Removed:

* `receiver` and `receiver/*`                 -- see `property` and others
* `hash/tree_merge` and `hashlike/tree_merge` -- use overlays
* `hash/indifferent_access`                   -- use `mash`
* `metaprogramming/cattr_accessor`            -- use `class_attribute`
* `metaprogramming/mattr_accessor`            -- discouraged
* `struct/*`                                  -- discouraged

## Version 0.x

### 2011-12-11 - Version 0.1.8: Gemfile fixes; Log.dump shows caller

* Gorillib has no real dependencies on spork, rcov, Redcloth, etc; these are only useful for rake tasks. Dialed down the urgency of version req's on rspec, yard, etc, and moved the esoterica (spork, rcov, watchr, RedCloth) into bundler groups. Bundler will still install them if you 'bundle install' from the gorillib directory, but the gemspec no longer forces upstream requirers to consider them dependencies
* Log.dump adds the immediate caller to the end of its output
* fix to Gemfile so that early versions of jruby don't hate on it

### 2011-08-21 - Version 0.1.6: Serialization and DeepHash

* Serialization with #to_wire -- like #to_hash, but hands #to_wire down the line to any element that contains it (as opposed to `#to_hash`, which should just do that)
* Hashlike#tree_merge: combined into the one version; gave it a block in the middle to do any fancy footwork
* deep_hash -- allows dotted (a.b.c) access to a nested hash
* Array#random_element -- gets a random member of the array.

Will soon be deprecating Receiver, in favor of the far more powerful Icss::ReceiverModel in the icss library.

### 2011-06-29 - Version 0.1.3: Fancier receivers

* can now mix activemodel into a receiver, getting all its validation and other awesomeness
* added receiver_model as an experimental 'I'm a fancy cadillac-style receiver'

### 2011-06-24 Version 0.1.2: Receiver body fixes

* Better @Object.try@ (via active_support)
* Receiver body can now be an interpolated string or a hash; this lets you use anonymous classes. Added tuple methods (does an in-order traversal).
* Bugfix for inclusion order in ActsAsHash

### Version 0.1.0: Hashlike refactor, Receiver arrives

v0.1.0 brings:

* Receiver module
* refeactoring of hash decorations into a new hashlike class
* ability to inject hashlike behavior into Struct

### Version 0.0.7: full test coverage!

        lib/
        |-- gorillib.rb
        `-- gorillib
            |-- array
            |   |-- compact_blank.rb
            |   |-- deep_compact.rb
            |   `-- extract_options.rb
            |-- base.rb
            |-- datetime
            |   |-- #flat.rb#
            |   |-- flat.rb
            |   `-- parse.rb
            |-- enumerable
            |   `-- sum.rb
            |-- hash
            |   |-- compact.rb
            |   |-- deep_compact.rb
            |   |-- deep_merge.rb
            |   |-- keys.rb
            |   |-- reverse_merge.rb
            |   |-- slice.rb
            |   `-- zip.rb
            |-- logger
            |   `-- log.rb
            |-- metaprogramming
            |   |-- aliasing.rb
            |   |-- cattr_accessor.rb
            |   |-- class_attribute.rb
            |   |-- delegation.rb
            |   |-- mattr_accessor.rb
            |   |-- remove_method.rb
            |   `-- singleton_class.rb
            |-- numeric
            |   `-- clamp.rb
            |-- object
            |   |-- blank.rb
            |   |-- try.rb
            |   `-- try_dup.rb
            |-- some.rb
            `-- string
                |-- constantize.rb
                |-- human.rb
                |-- inflections.rb
                `-- truncate.rb

