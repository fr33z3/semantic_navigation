require 'spec_helper'

describe SemanticNavigation::Core::Navigation do
  
  describe '#initialize' do
    
    it 'should create instance of navigation with level 0 and empty subitems' do
      navigation = SemanticNavigation::Core::Navigation.new({})
      navigation.level.should == 0
      navigation.sub_elements.should be_empty
    end

    it 'should create instance and save sended options' do
      navigation = SemanticNavigation::Core::Navigation.new :id => :some_id,
                                                            :classes => [:one, :two]
      navigation.id.should == :some_id
      navigation.classes.should == [:one,:two]
    end

    it 'should create instance and save unintended properties' do
      navigation = SemanticNavigation::Core::Navigation.new :some_attribute => :some_value
      navigation.instance_variable_get("@some_attribute").should == :some_value
    end

  end

  describe '#item' do
  	before :each do
  	  @navigation = SemanticNavigation::Core::Navigation.new({})
  	end

  	it "should receive item method and make the leaf" do
      @navigation.item :some_id, 'some_url'
      @navigation.sub_elements.size.should == 1
      @navigation.sub_elements.first.is_a?(SemanticNavigation::Core::Leaf).should be_true
  	end

  	it "should receive item method with block and create node" do
      @navigation.item :node_id, 'node_url' do
      	item :leaf_id, 'leaf_url'
      end
      @navigation.sub_elements.size.should == 1
      @navigation.sub_elements.first.is_a?(SemanticNavigation::Core::Node).should be_true
  	end
  end

  describe '#header' do
  	before :each do
  	  @navigation = SemanticNavigation::Core::Navigation.new({})
  	  @navigation.header :some_id
  	end

  	it "should create item with nil url" do
   	  @navigation.sub_elements.size.should == 1
   	  @navigation.sub_elements.first.url.should be_nil
  	end
  end

  describe "#divider" do
  	before :each do
  	  @navigation = SemanticNavigation::Core::Navigation.new({})
  	end

  	it "should create divider item with nil url and name" do
      @navigation.divider
  	  @navigation.sub_elements.size.should == 1
  	  @navigation.sub_elements.first.url.should be_nil
  	  @navigation.sub_elements.first.name.should be_empty
  	end

    it "should receive any length method containing char `_` and create divider" do
  	  
  	  (1..10).each do |c|
        @navigation.send ('_'*c).to_sym
  	  end
  	  @navigation.sub_elements.size.should == 10
  	  @navigation.sub_elements.map(&:id).should == [:divider]*10
  	end
  end

  describe "#decode_url" do
    
    before :each do
      @navigation = SemanticNavigation::Core::Navigation.new({})
    end

    it "while creating the item make support for urls in format controller#action" do
      view_object = mock
      @navigation.should_receive(:view_object).and_return view_object
      view_object.should_receive(:url_for).with({:controller => 'controller', :action => 'action'}).and_return '/controller/action'
      
      @navigation.item :some_id, 'controller#action'
      @navigation.sub_elements.size.should == 1
      @navigation.sub_elements.first.url.should == '/controller/action'
    end

    it 'should return the passed string if url_for raises error' do
      view_object = mock
      @navigation.should_receive(:view_object).and_return view_object
      view_object.should_receive(:url_for).with({:controller => 'controller', :action => 'action'}).and_raise :error
      
      @navigation.item :some_id, 'controller#action'
      @navigation.sub_elements.size.should == 1
      @navigation.sub_elements.first.url.should == 'controller#action'
    end

  end
end