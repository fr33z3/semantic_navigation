require 'spec_helper'

describe SemanticNavigation::TwitterBootstrap::Tabs do

  context :renders do

    before :each do
      class ViewObject
        attr_accessor :output_buffer
        include ActionView::Helpers::TagHelper
        include SemanticNavigation::HelperMethods
        include ActionView::Helpers::UrlHelper
      end
      @configuration = SemanticNavigation::Configuration
      @configuration.register_renderer :bootstrap_tabs, SemanticNavigation::TwitterBootstrap::Tabs
      @view_object = ViewObject.new
    end

    it 'empty ul tag for empty navigation' do

      @configuration.run do
        navigate :menu do
        end
      end

      result = @view_object.navigation_for :menu, :as => :bootstrap_tabs
      result.should == "<ul class=\"nav nav-tabs  pull-left\"></ul>"
    end

    it 'one level navigation' do
      @configuration.run do
        navigate :menu do
          item :url1, 'url1', :name => 'url1'
          item :url2, 'url2', :name => 'url2'
        end
      end

      result = @view_object.navigation_for :menu, :as => :bootstrap_tabs
      result.should == ["<ul class=\"nav nav-tabs  pull-left\">",
                          "<li>",
                            "<a href=\"url1\">",
                              "url1",
                            "</a>",
                          "</li>",
                          "<li>",
                            "<a href=\"url2\">",
                              "url2",
                            "</a>",
                          "</li>",
                        "</ul>"].join
    end

    it 'icon' do
      @configuration.run do
        navigate :menu do
          item :url1, 'url1', :name => 'url1', :ico => 'user'
        end
      end

      result = @view_object.navigation_for :menu, :as => :bootstrap_tabs
      result.should == ["<ul class=\"nav nav-tabs  pull-left\">",
                          "<li>",
                            "<a href=\"url1\">",
                              "<i class=\"icon-user\"></i>",
                              "url1",
                            "</a>",
                          "</li>",
                        "</ul>"].join
    end

    it 'icon in node' do
      @configuration.run do
        navigate :menu do
          item :url1, 'url1', :name => 'url1', :ico => 'user' do
            item :url, 'url', :name => 'url'
          end
        end
      end

      result = @view_object.navigation_for :menu, :as => :bootstrap_tabs
      result.should == ["<ul class=\"nav nav-tabs  pull-left\">",
                          "<li class=\" dropdown\">",
                            "<a class=\" dropdown-toggle\" data-toggle=\"dropdown\" href=\"#\">",
                              "<i class=\"icon-user\">",
                              "</i>url1",
                              "<b class=\"caret\">",
                              "</b>",
                            "</a>",
                            "<ul class=\" dropdown-menu\">",
                              "<li>",
                                "<a href=\"url\">url",
                                "</a>",
                              "</li>",
                            "</ul>",
                          "</li>",
                        "</ul>"].join
    end

    it 'one multilevel navigation' do
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

      result = @view_object.navigation_for :menu, :as => :bootstrap_tabs
      result.should == ["<ul class=\"nav nav-tabs  pull-left\">",
                          "<li class=\" dropdown\">",
                            "<a class=\" dropdown-toggle\" data-toggle=\"dropdown\" href=\"#\">",
                              "url1",
                              "<b class=\"caret\"></b>",
                            "</a>",
                            "<ul class=\" dropdown-menu\">",
                              "<li>",
                                "<a href=\"suburl1\">",
                                "suburl1",
                                "</a>",
                              "</li>",
                            "</ul>",
                          "</li>",
                          "<li class=\" dropdown\">",
                            "<a class=\" dropdown-toggle\" data-toggle=\"dropdown\" href=\"#\">url2",
                              "<b class=\"caret\">",
                              "</b>",
                            "</a>",
                            "<ul class=\" dropdown-menu\">",
                              "<li>",
                                "<a href=\"suburl2\">",
                                "suburl2",
                                "</a>",
                              "</li>",
                            "</ul>",
                          "</li>",
                        "</ul>"].join
    end

    it 'only root level' do
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

      result = @view_object.navigation_for :menu, :level => 0, :as => :bootstrap_tabs
      result.should == ["<ul class=\"nav nav-tabs  pull-left\">",
                          "<li>",
                            "<a href=\"url1\">",
                              "url1",
                            "</a>",
                          "</li>",
                          "<li>",
                            "<a href=\"url2\">",
                              "url2",
                            "</a>",
                          "</li>",
                        "</ul>"].join
    end

    it 'second level if some item of first level is active' do
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

      @view_object.should_receive(:current_page?).and_return(false, true, false, false)

      result = @view_object.navigation_for :menu, :level => 1, :as => :bootstrap_tabs
      result.should == ["<ul class=\"nav nav-tabs active  pull-left\">",
                          "<li>",
                            "<a href=\"suburl1\">suburl1",
                            "</a>",
                          "</li>",
                        "</ul>"].join
    end

    it 'the exact levels' do
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

      result = @view_object.navigation_for :menu, :levels => 0..1, :as => :bootstrap_tabs
      result.should == ["<ul class=\"nav nav-tabs  pull-left\">",
                          "<li class=\" dropdown\">",
                            "<a class=\" dropdown-toggle\" data-toggle=\"dropdown\" href=\"#\">url1",
                              "<b class=\"caret\">",
                              "</b>",
                            "</a>",
                            "<ul class=\" dropdown-menu\">",
                              "<li>",
                                "<a href=\"suburl1\">suburl1",
                                "</a>",
                              "</li>",
                            "</ul>",
                          "</li>",
                          "<li class=\" dropdown\">",
                            "<a class=\" dropdown-toggle\" data-toggle=\"dropdown\" href=\"#\">url2",
                              "<b class=\"caret\">",
                              "</b>",
                            "</a>",
                            "<ul class=\" dropdown-menu\">",
                              "<li>",
                                "<a href=\"suburl2\">suburl2",
                                "</a>",
                              "</li>",
                            "</ul>",
                          "</li>",
                        "</ul>"].join
    end

    it 'navigation except some item' do
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

      result = @view_object.navigation_for :menu, :except_for => [:url1], :as => :bootstrap_tabs
      result.should == ["<ul class=\"nav nav-tabs  pull-left\">",
                          "<li class=\" dropdown\">",
                            "<a class=\" dropdown-toggle\" data-toggle=\"dropdown\" href=\"#\">url2",
                              "<b class=\"caret\">",
                              "</b>",
                            "</a>",
                            "<ul class=\" dropdown-menu\">",
                              "<li>",
                                "<a href=\"suburl2\">suburl2",
                                "</a>",
                              "</li>",
                            "</ul>",
                          "</li>",
                        "</ul>"].join
    end

    it 'navigation except some items' do
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

      result = @view_object.navigation_for :menu, :except_for => [:suburl1,:url2], :as => :bootstrap_tabs
      result.should == ["<ul class=\"nav nav-tabs  pull-left\">",
                          "<li class=\" dropdown\">",
                            "<a class=\" dropdown-toggle\" data-toggle=\"dropdown\" href=\"#\">url1",
                              "<b class=\"caret\">",
                              "</b>",
                            "</a>",
                            "<ul class=\" dropdown-menu\">",
                            "</ul>",
                          "</li>",
                        "</ul>"].join
    end

    it 'navigation only item name if url is nil' do
      @configuration.run do
        navigate :menu do
          item :url1, 'url1', :name => 'url1'
          item :url2, nil, :name => 'url2'
        end
      end

      result = @view_object.navigation_for :menu, :as => :bootstrap_tabs
      result.should == ["<ul class=\"nav nav-tabs  pull-left\">",
                          "<li>",
                            "<a href=\"url1\">",
                              "url1",
                            "</a>",
                          "</li>",
                          "<li>",
                            "url2",
                          "</li>",
                        "</ul>"].join
    end

  end
end
