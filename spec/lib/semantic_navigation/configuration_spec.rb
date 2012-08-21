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

  describe '#styles_for' do
  	it 'should save styles block as a proc' do
  	  proc_object = SemanticNavigation::Configuration.styles_for :some_renderer do
  	  	do_something1 true
  	  	do_something2 'some_attr'
  	  end
  	  styles = SemanticNavigation::Configuration.class_variable_get("@@render_styles")
  	  styles[:some_renderer].should == proc_object

  	  mock_renderer = mock
  	  mock_renderer.should_receive(:do_something1).with(true)
  	  mock_renderer.should_receive(:do_something2).with('some_attr')
  	  mock_renderer.instance_eval &proc_object
  	end
  end

  describe '#register_renderer' do
    before :each do
      class SomeRenderer; end
    end

    it 'should register renderer by passed name and class' do
      SemanticNavigation::Configuration.register_renderer :some_renderer, SomeRenderer
      renderers = SemanticNavigation::Configuration.class_variable_get("@@renderers")
      renderers[:some_renderer].should_not be_nil
      renderers[:some_renderer].should == SomeRenderer
    end

    it 'should register renderer by passed classes and generate the name for it' do
      SemanticNavigation::Configuration.register_renderer SomeRenderer
      renderers = SemanticNavigation::Configuration.class_variable_get("@@renderers")
      renderers[:some_renderer].should_not be_nil
      renderers[:some_renderer].should == SomeRenderer
    end

    it 'should register a new helper method based on name of a renderer and depending on method navigation_for' do
      SemanticNavigation::Configuration.register_renderer SomeRenderer
      SemanticNavigation::HelperMethods.method_defined?(:some_renderer_for).should be_true
      
      class SomeClass
        include SemanticNavigation::HelperMethods
      end
      some_class_instance = SomeClass.new
      some_class_instance.should_receive(:navigation_for).with(:some_menu, {:as => :some_renderer})

      some_class_instance.some_renderer_for :some_menu
    end
  end

  describe '#render' do

    before :each do 
      @view_object = mock
      @renderer = mock
      @renderer_instance = mock
      @renderer.should_receive(:new).and_return @renderer_instance

      @navigation = mock

      SemanticNavigation::Configuration.class_variable_set "@@renderers", {:renderer => @renderer}
      SemanticNavigation::Configuration.class_variable_set "@@navigations", {:some_menu => @navigation}
    end

    it 'should send render method to Renderer class; mark active navigation elements;' do
      @navigation.should_receive(:mark_active)
      @navigation.should_receive(:render).with(@renderer_instance)
      SemanticNavigation::Configuration.new.render(:some_menu, :renderer, {}, @view_object)
    end

    it 'should send renderer options' do
      @navigation.should_receive(:mark_active)
      @navigation.should_receive(:render).with(@renderer_instance)
      @renderer_instance.should_receive(:level=).with(1)
      SemanticNavigation::Configuration.new.render(:some_menu, :renderer, {:level => 1}, @view_object)      
    end

    it 'should exec default renderer styles from configuration' do
      render_styles = proc{}
      SemanticNavigation::Configuration.class_variable_set "@@render_styles", {:renderer => render_styles}
      @renderer_instance.should_receive(:instance_eval).with(&render_styles)
      @navigation.should_receive(:mark_active)
      @navigation.should_receive(:render).with(@renderer_instance)
      SemanticNavigation::Configuration.new.render(:some_menu, :renderer, {}, @view_object)
    end

    it 'should set @@view_object in configuration class' do
      @navigation.should_receive(:mark_active)
      @navigation.should_receive(:render).with(@renderer_instance)
      SemanticNavigation::Configuration.new.render(:some_menu, :renderer, {}, @view_object)
      SemanticNavigation::Configuration.view_object.should == @view_object
    end

  end

end