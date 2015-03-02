require 'v8'
require 'json'

# @author @newsomc

class ReactJS
  
  JSFileNotFound = Class.new(StandardError)
  
  # Initialize ReactJS in Ruby by passing source
  # as a string. The source is a concatinated string.
  #
  # @param libsrc [File] the React library
  # @param appsrc [File] the current app
  #
  def initialize(libsrc, appsrc)
    jslib = self.read_file(libsrc)
    jsapp = self.read_file(appsrc)
    
    react = Array.new
    react << "var console = {warn: function(){}, error: function(){}}"
    react << "var global = {}"

    # Load the React lib
    react << jslib
    react << "var React = global.React"
    
    # Custom React components
    react << jsapp
    react << ';'
    @react = react.join(";\n")

    # Setup a new V8 context
    @v8 = V8::Context.new
  end

  # Read-in the React source and application source relative to
  # location of this file.
  #
  # Return a Hash of the source
  #
  # @param libsrc [String] React library source
  # @param appsrc [String] Component library source
  #
  # @return [Hash] Indexed React and component files
  #
  def read_file(file)
    raise JSFileNotFound.new file unless File.exists?(File.expand_path(file, __FILE__))
    File.read(File.expand_path(file, __FILE__))
  end     

  # The components to be rendered along with its data
  # Ex.
  #   rrjs.set_component('MyTable', ['content' => q4_results])
  #
  # @param string [component] Component name
  # @param mixed [data] Any type of data to be passed as params
  #               when initializing the component. Optional.
  #
  # @return object self
  #
  def set_component(component, data = nil)
    @component = component
    @data = data.to_json
    self
  end

  # Custom error handler
  #
  # @return [Object] self instance
  #
  def set_error_handler(error)
    self.error_handler = error
    self
  end

  # Returns HTML markup to be printed to page.
  #
  # @return [String] HTML string
  #
  def get_markup
    js = @react
    js += sprintf('React.renderToString(%s(%s));', @component, @data)
    @v8.eval(js)
  end
  
  # Returns JS to be inlined in the page (without <script> tags)
  # Instantiates the client once JS arrives to the page
  #
  # @param where [String] DOM node 
  # @param return_var [String|nil] (defaults to nil)
  # 
  def get_js(where, return_var = nil)
    if !@component or !@data
      return '{error: "No component or data is currently set. Please `set_component`."}'
    end 
    
    if(where[0...1] === '#')
      where = sprintf('docuent.getElementById(%s)', where[1..-1])
    end

    if return_var
      prefix = "var $return_var = "
    else
      prefix = ""
    end 
      
    prefix + sprintf('React.render(%s(%s), %s);', @component, @data, where)
  end 
end
