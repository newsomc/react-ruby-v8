# Server rendered React components with V8g

# Example

Run this example in irb to get an idea of what's going on:

```ruby

require 'react-ruby-v8'

rrjs = ReactJS.new('react.js', 'my_component.js')
rrjs.set_component('MyComponent', {'data' => [[1, 2, 3],[4, 5, 6],[7, 8, 9]]})

puts rrjs.get_markup
puts rrjs.get_js('#elem')

```
