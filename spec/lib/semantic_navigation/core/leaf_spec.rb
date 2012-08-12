require 'spec_helper'

describe SemanticNavigation::Core::Leaf do
  describe '#name' do
  	
  	it 'should return saved name' do
      leaf = SemanticNavigation::Core::Leaf.new({:id => :first, :name => 'first'},1)
      leaf.name.should == 'first'
  	end

  	it 'should return i18n name if @name is nil' do
      leaf = SemanticNavigation::Core::Leaf.new({:id => :first, :i18n_name => 'some_navigation'},1)
      I18n.should_receive(:t).with("some_navigation.first", {:default => ""}).and_return 'first'
      leaf.name.should == 'first'
  	end

  	it 'should return result of proc block if name is_a? proc' do
      leaf = SemanticNavigation::Core::Leaf.new({:name => proc{["first", "item"].join(' ')}},1)
      leaf.name.should == "first item"
  	end
  end

  describe '#mark_active' do

  	before :each do
  	  @view_object = mock
  	  SemanticNavigation::Configuration.stub!(:view_object).and_return @view_object
  	end
  	
  	it 'should set as active if have active url with symbol names' do
      leaf = SemanticNavigation::Core::Leaf.new({:url => {:controller => :first, :action => :index}}, 1)
      @view_object.stub(:params).and_return({:controller => 'first', :action => 'index'})
      leaf.mark_active.should be_true
      leaf.active.should be_true
  	end

  	it 'should set as active if have active url with string names' do
      leaf = SemanticNavigation::Core::Leaf.new({:url => {:controller => "first", :action => "index"}}, 1)
      @view_object.stub(:params).and_return({:controller => 'first', :action => 'index'})
      leaf.mark_active.should be_true
      leaf.active.should be_true  		
  	end

  	it 'should set as inactive if have inactive url with symbol names' do
      leaf = SemanticNavigation::Core::Leaf.new({:url => {:controller => :first, :action => :index}}, 1)  		
  	  @view_object.stub(:params).and_return({controller: "second", action: 'index'})
  	  leaf.mark_active.should be_false
  	  leaf.active.should be_false
  	end

  	it 'should set as inactive if have inactive url with string names' do
      leaf = SemanticNavigation::Core::Leaf.new({:url => {:controller => "first", :action => "index"}}, 1)  		
  	  @view_object.stub(:params).and_return({controller: "second", action: 'index'})
  	  leaf.mark_active.should be_false
  	  leaf.active.should be_false
  	end

  	it 'should set as inactive if have nil url' do
      leaf = SemanticNavigation::Core::Leaf.new({},1)
      leaf.mark_active.should be_false
      leaf.active.should be_false
  	end

  end
end