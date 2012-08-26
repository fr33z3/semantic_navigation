require 'spec_helper'

describe SemanticNavigation::Renderers::BreadCrumb do
  before :each do
  	class ViewObject
  	  attr_accessor :output_buffer
  	  include ActionView::Helpers::TagHelper
  	  include SemanticNavigation::HelperMethods
  	  include ActionView::Helpers::UrlHelper
  	end
    @configuration = SemanticNavigation::Configuration
  	@configuration.register_renderer :breadcrumb, SemanticNavigation::Renderers::BreadCrumb
  	@view_object = ViewObject.new
  end

  it 'should render empty ul tag for empty navigation' do
  
    @configuration.run do
      navigate :menu do
      end
    end
    
    result = @view_object.navigation_for :menu, :as => :breadcrumb
    result.should == "<ul class=\"breadcrumb\" id=\"menu\"></ul>"
  end  

  it 'should render one level navigation breadcrumb' do
    @configuration.run do
      navigate :menu do
      	item :url1, 'url1', :name => 'url1'
      	item :url2, 'url2', :name => 'url2'
      end
    end

    @view_object.should_receive(:current_page?).and_return(false,true)

    result = @view_object.navigation_for :menu, :as => :breadcrumb
    result.should == ["<ul class=\"breadcrumb\" id=\"menu\">",
                        "<li id=\"url2\">",
                          "url2",
                        "</li>",
                      "</ul>"].join
  end

it 'should render one multilevel navigation breadcrumb' do
    @configuration.run do
      navigate :menu do
      	item :url1, 'url1', :name => 'url1' do
          item :suburl1, 'suburl1', :name => 'suburl1'
      	end
      	item :url2, 'url2', :name => 'url2' do
          item :suburl2, 'suburl2', :name => 'suburl2'
      	end
      end
    end

    @view_object.should_receive(:current_page?).and_return(true,false,false,false)

    result = @view_object.navigation_for :menu, :as => :breadcrumb
    result.should == ["<ul class=\"breadcrumb\" id=\"menu\">",
                        "<li id=\"url1\">",
                          "<a href=\"url1\" id=\"url1\">",
                            "url1",
                          "</a>",
                        "</li>",
                        "<li>/",
                        "</li>",
                        "<li id=\"suburl1\">",
                          "suburl1",
                        "</li>",
                      "</ul>"].join
  end  

  it 'should render last item as link if :last_as_link => true' do
    @configuration.run do
      navigate :menu do
      	item :url1, 'url1', :name => 'url1' do
          item :suburl1, 'suburl1', :name => 'suburl1'
      	end
      	item :url2, 'url2', :name => 'url2' do
          item :suburl2, 'suburl2', :name => 'suburl2'
      	end
      end
    end

    @view_object.should_receive(:current_page?).and_return(true,false,false,false)

    result = @view_object.navigation_for :menu, :as => :breadcrumb, :last_as_link => true
    result.should == ["<ul class=\"breadcrumb\" id=\"menu\">",
                        "<li id=\"url1\">",
                          "<a href=\"url1\" id=\"url1\">",
                            "url1",
                          "</a>",
                        "</li>",
                        "<li>",
                          "/",
                        "</li>",
                        "<li id=\"suburl1\">",
                          "<a href=\"suburl1\" id=\"suburl1\">",
                            "suburl1",
                          "</a>",
                        "</li>",
                      "</ul>"].join  	
  end

  it 'should render only root level' do
    @configuration.run do
      navigate :menu do
      	item :url1, 'url1', :name => 'url1' do
          item :suburl1, 'suburl1', :name => 'suburl1'
      	end
      	item :url2, 'url2', :name => 'url2' do
          item :suburl2, 'suburl2', :name => 'suburl2'
      	end
      end
    end

    @view_object.should_receive(:current_page?).and_return(true,false,false,false)

    result = @view_object.navigation_for :menu, :level => 0, :as => :breadcrumb
    result.should == ["<ul class=\"breadcrumb\" id=\"menu\">",
    	                "<li id=\"url1\">",
    	                  "url1",
    	                "</li>",
                      "</ul>"].join  	
  end

  it 'should render second level' do
    @configuration.run do
      navigate :menu do
      	item :url1, 'url1', :name => 'url1' do
          item :suburl1, 'suburl1', :name => 'suburl1'
      	end
      	item :url2, 'url2', :name => 'url2' do
          item :suburl2, 'suburl2', :name => 'suburl2'
      	end
      end
    end

    @view_object.should_receive(:current_page?).and_return(true, false, false, false)

    result = @view_object.navigation_for :menu, :level => 1, :as => :breadcrumb
    result.should == ["<ul class=\"breadcrumb\" id=\"menu\">",
                        "<li id=\"suburl1\">",
                          "suburl1",
                        "</li>",
                      "</ul>"].join  	
  end

  it 'should render the exact levels' do
    @configuration.run do
      navigate :menu do
      	item :url1, 'url1', :name => 'url1' do
          item :suburl1, 'suburl1', :name => 'suburl1' do
          	item :subsub1, 'subsub1', :name => 'subsub1'
          end
      	end
      	item :url2, 'url2', :name => 'url2' do
          item :suburl2, 'suburl2', :name => 'suburl2' do
          	item :subsub2, 'subsub2', :name => 'subsub2'
          end
      	end
      end
    end

    @view_object.should_receive(:current_page?).and_return(true, false, false, false, false, false)

    result = @view_object.navigation_for :menu, :levels => 0..1, :as => :breadcrumb
    result.should == ["<ul class=\"breadcrumb\" id=\"menu\">",
                        "<li id=\"url1\">",
                          "<a href=\"url1\" id=\"url1\">",
                            "url1",
                          "</a>",
                        "</li>",
                        "<li>/",
                        "</li>",
                        "<li id=\"suburl1\">",
                          "suburl1",
                        "</li>",
                      "</ul>"].join
  end

  it 'should render navigation except some item' do
    @configuration.run do
      navigate :menu do
      	item :url1, 'url1', :name => 'url1' do
          item :suburl1, 'suburl1', :name => 'suburl1'
      	end
      	item :url2, 'url2', :name => 'url2' do
          item :suburl2, 'suburl2', :name => 'suburl2'
      	end
      end
    end
    
    @view_object.should_receive(:current_page?).and_return(true, false, false, false)
    result = @view_object.navigation_for :menu, :except_for => [:suburl1], :as => :breadcrumb
    result.should == ["<ul class=\"breadcrumb\" id=\"menu\">",
    	                "<li id=\"url1\">",
    	                  "url1",
                        "</li>",
                      "</ul>"].join  	
  end
end