require 'spec_helper'

describe SemanticNavigation::Configuration do
  
  describe "#run" do
  	it 'should receive class eval if block passed' do
      SemanticNavigation::Configuration.should_receive(:class_eval)
      SemanticNavigation::Configuration.run do
      	do_something
      end
  	end

  	it 'should not receive class_eval if block not passed' do
      SemanticNavigation::Configuration.run
  	end
  end

  describe '#navigate' do
  	it 'should receive at least only id and save navigation instance in class variables' do
  	  nav_instance = SemanticNavigation::Configuration.navigate :some_menu
  	  navigations = SemanticNavigation::Configuration.class_variable_get("@@navigations")
  	  navigations.keys.should == [:some_menu]
  	  navigations[:some_menu].should == nav_instance
  	end

    it 'should receive id and pass to Navigation instance create options hash' do
      SemanticNavigation::Core::Navigation.should_receive(:new).with({:id=>:some_menu, 
      	                                                              :i18n_name=>"semantic_navigation.some_menu"})
      SemanticNavigation::Configuration.navigate :some_menu
    end

    it 'should pass received block to navigation class instance' do
      navigation = mock
      navigation.should_receive(:instance_eval)
      SemanticNavigation::Core::Navigation.should_receive(:new).and_return navigation
      SemanticNavigation::Configuration.navigate :some_menu do
      	do_something
      end
    end

    it 'should merge id, i18n_name and received params and pass them to navigation instance create method' do
      SemanticNavigation::Core::Navigation.should_receive(:new).with({:id => :some_menu,
      	                                                              :i18n_name=>"semantic_navigation.some_menu",
      	                                                              :some_attr => 1,
      	                                                              :some_attr2 => 2})
      SemanticNavigation::Configuration.navigate :some_menu, :some_attr => 1, :some_attr2 => 2
    end
  end

  describe '#navigation' do
  	it 'should return navigation instance by name' do
  	  nav_instance = SemanticNavigation::Configuration.navigate :some_menu
      SemanticNavigation::Configuration.navigation(:some_menu).should == nav_instance
  	end
  end

end