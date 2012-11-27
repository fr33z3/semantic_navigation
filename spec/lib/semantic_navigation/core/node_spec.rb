require 'spec_helper'

describe SemanticNavigation::Core::Node do
  
  describe '#name' do

    it 'returns basic name even if renderer name sended' do
      node = SemanticNavigation::Core::Node.new({:id => :first, :name => 'first'},1)
      node.name(:renderer_name).should == 'first'      
    end

    it 'returns the name for renderer' do
      node = SemanticNavigation::Core::Node.new({:id => :first, 
                                                 :name => {:some_renderer => 'some_renderer_name'}},
                                                 1)
      node.name(:some_renderer).should == 'some_renderer_name'
    end

    it 'returns default name for unexpected renderer' do
      node = SemanticNavigation::Core::Node.new({:id => :first, 
                                                 :name => {:default => 'default_name',
                                                           :some_renderer => 'some_renderer_name'}},
                                                 1)
      node.name(:unexpected_renderer).should == 'default_name'
    end

    it 'returns nil if no name defined' do
      node = SemanticNavigation::Core::Node.new({:id => :first}, 1)
      node.name.should == ''
    end    

    it 'returns passed name while creating node' do
      node = SemanticNavigation::Core::Node.new({:name => 'some name'}, 1)
      node.name.should == 'some name'
    end
   
    it 'returns i18n name if passed name is nil' do
      node = SemanticNavigation::Core::Node.new({:id => :some_id, :i18n_name => :parent_name}, 1)
      I18n.should_receive(:t).with("parent_name.some_id", {:default=>""}).and_return 'some name'
      node.name.should == 'some name'
    end

    it 'returns result of proc if passed name is a proc' do
      node = SemanticNavigation::Core::Node.new({:name => proc{'some name'}},1)
      node.name.should == 'some name'
    end
  end

  describe '#url' do	
    it 'returns passed url' do
      node = SemanticNavigation::Core::Node.new({:url => {:controller => 'controller', :action => 'action'}},1)
      node.url.should == {:controller => 'controller', :action => 'action'}
    end

    it 'returns first url if passed array of urls' do
      node = SemanticNavigation::Core::Node.new({:url => [{:controller => 'controller1', :action => 'action'},
                                                          {:controller => 'controller2', :action => 'action'}]},1)
      node.url.should == {:controller => 'controller1', :action => 'action'}
    end
  end

  describe '#mark_active' do
    before :each do
      @node = SemanticNavigation::Core::Node.new({:url => [{:controller => :node_controller, :action => :action},
                                                           {:controller => :node_controller2, :action => :action}]},1)

      @view_object = mock
      @view_object.stub(:params).and_return({:action => "some", :action => "some"})      
      SemanticNavigation::Configuration.stub(:view_object).and_return @view_object
    end

    context :defines do

      it '@active variable to false if no active sub_elements and node url is not active' do
        @node.mark_active
        @node.instance_variable_get("@active").should be_false
      end
  
      it '@active variable to true if at least one sub_element is active' do
        @node.item :first_item, '111'
        @node.item :second_item, '222'
        @view_object.should_receive(:current_page?).with('111').and_return true
        @view_object.should_receive(:current_page?).with('222').and_return false
        
        @node.mark_active
        @node.sub_elements[0].active.should be_true
        @node.sub_elements[1].active.should be_false
        @node.active.should be_true
      end
  
      it '@active variable to false if all sub_elements is unactive' do
        @node.item :first_item, '333'
        @node.item :second_item, '444'
        @view_object.should_receive(:current_page?).with('333').and_return false
        @view_object.should_receive(:current_page?).with('444').and_return false
  
        @node.mark_active
        @node.sub_elements[0].active.should be_false
        @node.sub_elements[1].active.should be_false
        @node.active.should be_false
      end
    end

    it 'uses custom current_page? for Hash url params' do
      @node.item :first_item, {:controller => "controller1", :action => "action"}
      @node.item :second_item, {:controller => "controller2", :action => "action"}
      @view_object.stub(:params).and_return({:controller => "controller1", :action => "action", :some_other_params => "blablabla"})
      
      @node.mark_active
      @node.sub_elements[0].active.should be_true
      @node.sub_elements[1].active.should be_false
      @node.active.should be true
    end

    it 'works for route like urls as good as for Hash url params' do
      @node.item :first_item, "controller1#action"
      @node.item :second_item, "controller2#action"
      @view_object.stub(:params).and_return({:controller => "controller1", :action => "action", :some_other_params => "blablabla"})

      @node.mark_active
      @node.sub_elements[0].active.should be_true
      @node.sub_elements[1].active.should be_false
      @node.active.should be true      
    end

    it 'is active if at least one url in passed array is active' do
      @view_object.stub(:params).and_return(:controller => 'node_controller2', :action => 'action')
      @node.mark_active
      @node.active.should be_true
    end

    it 'accepts array like urls with other urls' do
      node = SemanticNavigation::Core::Node.new({:url => [['url','with','id'],
                                                          :symbol_url_name,
                                                          {:controller => 'hash', :action => 'url'},
                                                          "string_url"]}, 1)
      node.should_receive(:current_page?).with(['url','with','id'])
      node.should_receive(:current_page?).with(:symbol_url_name)
      node.should_receive(:current_page?).with({:controller => 'hash', :action => 'url'})
      node.should_receive(:current_page?).with("string_url")
      node.mark_active
    end

  end  

end