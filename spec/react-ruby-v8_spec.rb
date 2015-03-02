require 'config'
require 'react-ruby-v8'

describe ReactJS do
  
  # Not good: shouldn't have to provide file paths like this.
  let(:rrjs) { ReactJS.new('../../spec/react.js', '../../spec/table.js') }
  
  let(:set_component) { rrjs.set_component('Table', {'data' => [[1, 2, 3], [4, 5, 6]]}) }

  let(:set_component_nil_data) {rrjs.set_component('Table') }
  
  let(:good_conversion) {
    'React.renderComponent({Hello({name: "John"}), document.getElementById(mynode));'
  }
  
  describe 'set_component' do
    
    context 'with no args' do
      subject do
        Proc.new { rrjs.set_component() }
      end
      it { should raise_error(ArgumentError) }
    end
    
    context 'with args' do
      subject do
        set_component.class
      end
      it { should eq ReactJS }
    end

    context 'nil data returns component' do
      subject do
        set_component_nil_data.class
      end
      it { should eq ReactJS }
    end
    
  end

  describe 'read file' do
    context 'with no file' do
      let(:missing_js_filename) { '/does/not/exist.js' }
      subject do
        Proc.new { ReactJS.new(missing_js_filename, missing_js_filename) }
      end
      it { should raise_error ReactJS::JSFileNotFound, missing_js_filename }
    end 
  end 
  
  describe 'get_js' do
    context 'with no args' do
      subject do
        Proc.new { rrjs.get_js() }
      end
      it { should raise_error(ArgumentError) }
    end
  end
end 
