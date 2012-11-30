require 'spec_helper'

describe 'SemanticNavigation::Deprecations' do

  context :'SemanticNavigation::Renderers::RenderHelpers' do

  	it 'is availiable' do
  	  defined?(SemanticNavigation::Renderers::RenderHelpers).should == 'constant'
  	end

  	it 'includes module with new namespace' do

  	  class SomeRenderer
  	    begin
  	      include SemanticNavigation::Renderers::RenderHelpers
  	    rescue => e
  	      puts e
  	    end
  	  end
   
      (SomeRenderer.include?(
        SemanticNavigation::Renderers::MixIn::RenderHelpers
      ) rescue false).should be_true
  	end
  end

  context :'SemanticNavigation::Renderers::ActsAsBreadcrumb' do
  	it 'is availiable' do
  	  defined?(SemanticNavigation::Renderers::ActsAsBreadcrumb).should == 'constant'
  	end
  	
  	it 'includes module with new namespace' do
  	  class SomeRenderer
  	    begin
  	      include SemanticNavigation::Renderers::ActsAsBreadcrumb
  	    rescue => e
          puts e
  	    end
  	  end
   
      (SomeRenderer.include?(
        SemanticNavigation::Renderers::MixIn::ActsAsBreadcrumb
      ) rescue false).should be_true  	
  	end
  end

  context :'SemanticNavigation::Renderers::ActsAsList' do
  	it 'is availiable' do
  	  defined?(SemanticNavigation::Renderers::ActsAsList).should == 'constant'
  	end
  	
  	it 'includes module with new namespace' do
  	  class SomeRenderer
  	    begin
  	      include SemanticNavigation::Renderers::ActsAsList
  	    rescue => e
  	      puts e
  	    end
  	  end
   
      (SomeRenderer.include?(
        SemanticNavigation::Renderers::MixIn::ActsAsList
      ) rescue false).should be_true  		
  	end  	
  end  

end