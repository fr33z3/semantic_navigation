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

  describe '#mark_active' do
    before :each do
      @node = SemanticNavigation::Core::Node.new({:url => {:controller => :node_controller, :action => :action}},1)

      @view_object = mock
      @view_object.stub(:params).and_return({:action => "some", :action => "some"})      
      SemanticNavigation::Configuration.stub(:view_object).and_return @view_object
    end

    it 'should define @active variable to false if no active sub_elements and node url is not active' do
      @node.mark_active
      @node.instance_variable_get("@active").should be_false
    end

    it 'should define @active variable to true if at least one sub_element is active' do
      @node.item :first_item, '111'
      @node.item :second_item, '222'
      @view_object.should_receive(:current_page?).with('111').and_return true
      @view_object.should_receive(:current_page?).with('222').and_return false
      
      @node.mark_active
      @node.sub_elements[0].active.should be_true
      @node.sub_elements[1].active.should be_false
      @node.active.should be_true
    end

    it 'should define @active variable to false if all sub_elements is unactive' do
      @node.item :first_item, '333'
      @node.item :second_item, '444'
      @view_object.should_receive(:current_page?).with('333').and_return false
      @view_object.should_receive(:current_page?).with('444').and_return false

      @node.mark_active
      @node.sub_elements[0].active.should be_false
      @node.sub_elements[1].active.should be_false
      @node.active.should be_false
    end

    it 'should use custom current_page? for Hash url params' do
      @node.item :first_item, {:controller => "controller1", :action => "action"}
      @node.item :second_item, {:controller => "controller2", :action => "action"}
      @view_object.stub(:params).and_return({:controller => "controller1", :action => "action", :some_other_params => "blablabla"})
      
      @node.mark_active
      @node.sub_elements[0].active.should be_true
      @node.sub_elements[1].active.should be_false
      @node.active.should be true
    end

    it 'should work for route like urls as good as for Hash url params' do
      @node.item :first_item, "controller1#action"
      @node.item :second_item, "controller2#action"
      @view_object.stub(:params).and_return({:controller => "controller1", :action => "action", :some_other_params => "blablabla"})

      @node.mark_active
      @node.sub_elements[0].active.should be_true
      @node.sub_elements[1].active.should be_false
      @node.active.should be true      
    end

  end  

end