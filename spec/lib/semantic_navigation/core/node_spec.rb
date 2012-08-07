require 'spec_helper'

describe SemanticNavigation::Core::Node do
  
  describe '#name' do

    it 'should return passed name while creating node' do
      node = SemanticNavigation::Core::Node.new({:name => 'some name'}, 1)
      node.name.should == 'some name'
    end
   
    it 'should return i18n name if passed name is nil' do
      node = SemanticNavigation::Core::Node.new({:id => :some_id, :i18n_name => :parent_name}, 1)
      I18n.should_receive(:t).with("parent_name.some_id", {:default=>""}).and_return 'some name'
      node.name.should == 'some name'
    end

    it 'should return result of proc if passed name is a proc' do
      node = SemanticNavigation::Core::Node.new({:name => proc{'some name'}},1)
      node.name.should == 'some name'
    end

  end	
end