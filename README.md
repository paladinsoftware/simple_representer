[![Build Status](https://paladin-software.semaphoreci.com/badges/simple_representer/branches/master.svg?style=shields&key=88648f3f-f100-4e0f-9fca-48ea65537ec3)](https://paladin-software.semaphoreci.com/projects/simple_representer)
# SimpleRepresenter
Simple solution to represent your objects as hash or json.

## Usage
Create a class that inherits from `SimpleRepresenter::Representer`
and define your representation using `property` (to access methods defined in represented object)
and `computed` (to use methods defined inside representer) class methods.

```ruby
class UserRepresenter < SimpleRepresenter::Representer
    property :id
    computed :full_name
    computed :is_active

    def full_name
      "#{represented.first_name} #{represented.last_name}"
    end

    def is_active
      !represented.activated_at.nil?
    end
end
```
Pass your object as argument in initializer and call `to_h`/`to_hash` or `to_json`.
You can also represent hashes like normal objects (see: [SimpleRepresenter::CallableHash](./lib/simple_representer/callable_hash.rb))
```ruby
user = User.find(1)
UserRepresenter.new(user).to_json
 => "{\"id\":1,\"full_name\":\"Jon Doe\",\"is_active\":false}"
UserRepresenter.new(user).to_hash
 => {:id=>1, :full_name=>"Jon Doe", :is_active=>false}
```

### Collections
To use SimpleRepresenter with collection of objects use `for_collection` method:
```ruby
 UserRepresenter.for_collection(users).to_json
 => "[{\"id\":1,\"full_name\":\"Jon Doe\",\"is_active\":false},{\"id\":2,\"full_name\":\"Jon Wick\",\"is_active\":true}]"
```

### Options
Both `property` and `computed` have following options:
- `if` to make execution dependent on condition:
```ruby
property :full_name, if: -> { first_name && last_name }
```
- `as` to rename field in representation:
```ruby
property :is_active?, as: :is_active
```
- `default` to set default value:
```ruby
property :name, default: 'Paladin'
```
- `render_nil` to render or skip nil value (default is false):
```ruby
# will render { name: nil } if name is nil
property :name, render_nil: true
```
- `representer` to use different representer for nested objects.
If it's an array `for_collection` will be automatically called.
```ruby
property :comments, representer: CommentsRepresenter
```

### Additional arguments
You can pass additional arguments to initializer. You can access them inside computed methods or any other place using `options`:
```ruby
class UserRepresenter < SimpleRepresenter::Representer
    property :id
    property :full_name, if: -> { options[:display_name] }
end
```
```ruby
user = OpenStruct.new({ id: 5, full_name: 'Batman' })
UserRepresenter.new(user, display_name: false).to_json
 => "{\"id\":5}"
```
You can set default options for properties by using `defaults`:
```ruby
class UserRepresenter < SimpleRepresenter::Representer
    defaults render_nil: true # render nil properties
    property :id
end
```
## Migrating from Roar
Replace all occurrences of `exec_context: :decorator` to `computed`:
```ruby
property :full_name, exec_context: :decorator
=>
computed :full_name
```
Replace `decorator` with `representer` and `collection` with `computed` or `property` for nested objects:
```ruby
collection :songs, decorator: SongRepresenter
=>
property :songs, representer: SongRepresenter
```

## Specs
Just run `rspec`.
