# Server rendered React components with `therubyracer`

# Example

Run this example in irb to get an idea of what's going on:

```ruby

require 'react-ruby-v8'

rrjs = ReactJS.new('../../example/vendor/react.js', '../../example/table.js')
data = {'data' => [[1, 2, 3],[4, 5, 6],[7, 8, 9]]}

puts rrjs.set_component('Table', data).class
puts rrjs.get_markup
puts rrjs.get_js('#elem', "GLOB")

```
