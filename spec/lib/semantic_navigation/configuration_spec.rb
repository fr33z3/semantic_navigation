require 'spec_helper'

describe SemanticNavigation::Configuration do
  
  before :all do
    @config_class = SemanticNavigation::Configuration
    default_renderers = @config_class.class_variable_get("@@renderers")
    default_renderers.keys.should == [:list, :breadcrumb, :bootstrap_breadcrumb, :bootstrap_list, :bootstrap_tabs, :bootstrap_pills]
  end
  
  describe '#navigate' do
    it 'should accept navigation method' do
      @config_class.class_variable_get("@@navigations").should == {}
      SemanticNavigation::Configuration.run do
        navigate :navigation
      end
      navigations = @config_class.class_variable_get("@@navigations")
      navigations[:navigation].should_not be_nil
      navigations[:navigation].id.should == :navigation
      navigations[:navigation].instance_variable_get("@i18n_name").should == 'semantic_navigation.navigation'
    end    
  end
    
  describe '#styles_for' do
    it 'should save the proc' do

      SemanticNavigation::Configuration.run do
        styles_for :navigation do
          navigation_default_classes [:default]
        end
      end

      render_styles = @config_class.class_variable_get("@@render_styles")
      render_styles[:navigation].should_not be_nil
      render_styles[:navigation].class.should == Proc
    end   
  end
  
  describe 'register_render' do
    it 'should get the name and render class and reg as renderer' do
      @config_class.register_renderer(:some_renderer,CustomRenderer)
      renderers = @config_class.class_variable_get("@@renderers")
      renderers[:some_renderer].should_not be_nil
      renderers[:some_renderer].should == CustomRenderer
    end
    
    it 'should receive only renderer class and make a renderer name for itself' do
      @config_class.register_renderer(CustomRenderer)
      renderers = @config_class.class_variable_get("@@renderers")
      renderers[:custom_renderer].should_not be_nil
      renderers[:custom_renderer].should == CustomRenderer
    end
  end
 
end