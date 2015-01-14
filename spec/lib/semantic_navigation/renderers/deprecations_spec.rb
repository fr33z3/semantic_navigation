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
      
      expect(SomeRenderer).to be_include(SemanticNavigation::Renderers::MixIn::RenderHelpers)
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

      expect(SomeRenderer).to be_include(SemanticNavigation::Renderers::MixIn::ActsAsBreadcrumb)
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

      expect(SomeRenderer).to be_include(SemanticNavigation::Renderers::MixIn::ActsAsList)
    end
  end

end
