require 'spec_helper'

RSpec.describe SemanticNavigation::TwitterBootstrap::Tabs do
  include_context "view_object"
  let(:configuration) { SemanticNavigation::Configuration }

  context :renders do
    before do
      configuration.run do
        register_renderer :bootstrap_tabs, SemanticNavigation::TwitterBootstrap::Tabs
      end
    end

    it 'empty ul tag for empty navigation' do
      configuration.run do
        navigate :menu do
        end
      end

      result = view_object.navigation_for :menu, as: :bootstrap_tabs
      expect(result).to eq "<ul class=\"nav nav-tabs  pull-left\"></ul>"
    end

    it 'one level navigation' do
      configuration.run do
        navigate :menu do
          item :url1, 'url1', :name => 'url1'
          item :url2, 'url2', :name => 'url2'
        end
      end

      result = view_object.navigation_for :menu, as: :bootstrap_tabs
      expect(result).to have_tag("ul", with: { class: "nav nav-tabs pull-left" }) do
        with_tag("li") do
          with_tag("a", with: { href: "url1" }, text: "url1")
        end
        with_tag("li") do
          with_tag("a", with: { href: "url2" }, text: "url2")
        end
      end
    end

    it 'icon' do
      configuration.run do
        navigate :menu do
          item :url1, 'url1', :name => 'url1', :ico => 'user'
        end
      end

      result = view_object.navigation_for :menu, as: :bootstrap_tabs
      expect(result).to have_tag("ul", with: { class: "nav nav-tabs pull-left" }) do
        with_tag("li") do
          with_tag("a", with: { href: "url1" }) do
            with_tag("i", with: { class: "icon-user" })
          end
        end
      end
    end

    it 'icon in node' do
      configuration.run do
        navigate :menu do
          item :url1, 'url1', :name => 'url1', :ico => 'user' do
            item :url, 'url', :name => 'url'
          end
        end
      end

      result = view_object.navigation_for :menu, as: :bootstrap_tabs
      expect(result).to have_tag("ul", with: { class: "nav nav-tabs pull-left" }) do
        with_tag("li", with: { class: "dropdown" }) do
          with_tag("a", class: "dropdown-toggle", "data-toggle" => "dropdown", href: "#") do
            with_tag("i", with: { class: "icon-user" })
            with_tag("b", with: { class: "caret" })
          end
          with_tag("ul", with: { class: "dropdown-menu" }) do
            with_tag("li") do
              with_tag("a", with: { href: "url" }, text: "url")
            end
          end
        end
      end
    end

    it 'one multilevel navigation' do
      configuration.run do
        navigate :menu do
          item :url1, 'url1', :name => 'url1' do
            item :suburl1, 'suburl1', :name => 'suburl1'
          end
          item :url2, 'url2', :name => 'url2' do
            item :suburl2, 'suburl2', :name => 'suburl2'
          end
        end
      end

      result = view_object.navigation_for :menu, as: :bootstrap_tabs
      expect(result).to have_tag("ul", with: { class: "nav nav-tabs pull-left" }) do
        with_tag("li", with: { class: "dropdown" }) do
          with_tag("a", with: { class: "dropdown-toggle", "data-toggle" => "dropdown", href: "#" }) do
            with_tag("b", with: { class: "caret" })
          end
          with_tag("ul", with: { class: "dropdown-menu" }) do
            with_tag("li") do
              with_tag("a", with: { href: "suburl1" }, text: "suburl1")
            end
          end
        end
        with_tag("li", with: { class: "dropdown" }) do
          with_tag("a", with: { class: "dropdown-toggle", "data-toggle" => "dropdown", href: "#" }) do
            with_tag("b", with: { class: "caret" })
          end
          with_tag("ul", with: { class: "dropdown-menu" }) do
            with_tag("li") do
              with_tag("a", with: { href: "suburl2" }, text: "suburl2")
            end
          end
        end
      end
    end

    it 'only root level' do
      configuration.run do
        navigate :menu do
          item :url1, 'url1', :name => 'url1' do
            item :suburl1, 'suburl1', :name => 'suburl1'
          end
          item :url2, 'url2', :name => 'url2' do
            item :suburl2, 'suburl2', :name => 'suburl2'
          end
        end
      end

      result = view_object.navigation_for :menu, level: 0, as: :bootstrap_tabs
      expect(result).to have_tag("ul", with: { class: "nav nav-tabs pull-left" }) do
        with_tag("li") do
          with_tag("a", with: { href: "url1" }, text: "url1")
        end
        with_tag("li") do
          with_tag("a", with: { href: "url2" }, text: "url2")
        end
      end
    end

    it 'second level if some item of first level is active' do
      configuration.run do
        navigate :menu do
          item :url1, 'url1', :name => 'url1' do
            item :suburl1, 'suburl1', :name => 'suburl1'
          end
          item :url2, 'url2', :name => 'url2' do
            item :suburl2, 'suburl2', :name => 'suburl2'
          end
        end
      end

      allow(view_object).to receive(:current_page?).and_return(false, true, false, false)

      result = view_object.navigation_for :menu, level: 1, as: :bootstrap_tabs
      expect(result).to eq ["<ul class=\"nav nav-tabs active  pull-left\">",
                          "<li>",
                            "<a href=\"suburl1\">suburl1",
                            "</a>",
                          "</li>",
                        "</ul>"].join
    end

    it 'the exact levels' do
      configuration.run do
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

      result = view_object.navigation_for :menu, levels: 0..1, as: :bootstrap_tabs
      expect(result).to have_tag("ul", with: { class: "nav nav-tabs pull-left" }) do
        with_tag("li", with: { class: "dropdown" }) do
          with_tag("a", with: { href: "#", class: "dropdown-toggle", "data-toggle" => "dropdown" }) do
            with_tag("b", with: { class: "caret" })
          end
          with_tag("ul", with: { class: "dropdown-menu" }) do
            with_tag("li") do
              with_tag("a", with: { href: "suburl1" }, text: "suburl1")
            end
          end
        end
        with_tag("li", with: { class: "dropdown" }) do
          with_tag("a", with: { href: "#", class: "dropdown-toggle", "data-toggle" => "dropdown" }) do
            with_tag("b", with: { class: "caret" })
          end
          with_tag("ul", with: { class: "dropdown-menu" }) do
            with_tag("li") do
              with_tag("a", with: { href: "suburl2" }, text: "suburl2")
            end
          end
        end
      end
    end

    it 'navigation except some item' do
      configuration.run do
        navigate :menu do
          item :url1, 'url1', :name => 'url1' do
            item :suburl1, 'suburl1', :name => 'suburl1'
          end
          item :url2, 'url2', :name => 'url2' do
            item :suburl2, 'suburl2', :name => 'suburl2'
          end
        end
      end

      result = view_object.navigation_for :menu, :except_for => [:url1], as: :bootstrap_tabs
      expect(result).to have_tag("ul", with: { class: "nav nav-tabs pull-left" }) do
        with_tag("li", with: { class: "dropdown" }) do
          with_tag("a", with: { class: "dropdown-toggle", "data-toggle" => "dropdown", href: "#" }) do
            with_tag("b", with: { class: "caret" })
          end
          with_tag("ul", with: { class: "dropdown-menu" }) do
            with_tag("li") do
              with_tag("a", with: { href: "suburl2" }, text: "suburl2")
            end
          end
        end
      end
    end

    it 'navigation except some items' do
      configuration.run do
        navigate :menu do
          item :url1, 'url1', :name => 'url1' do
            item :suburl1, 'suburl1', :name => 'suburl1'
          end
          item :url2, 'url2', :name => 'url2' do
            item :suburl2, 'suburl2', :name => 'suburl2'
          end
        end
      end

      result = view_object.navigation_for :menu, :except_for => [:suburl1,:url2], as: :bootstrap_tabs
      expect(result).to have_tag("ul", with: { class: "nav nav-tabs pull-left" }) do
        with_tag("li", with: { class: "dropdown" }) do
          with_tag("a", with: { class: "dropdown-toggle", "data-toggle" => "dropdown", href: "#" }) do
            with_tag("b", with: { class: "caret" })
          end
          with_tag("ul", with: { class: "dropdown-menu" })
        end
      end
    end

    it 'navigation only item name if url is nil' do
      configuration.run do
        navigate :menu do
          item :url1, 'url1', :name => 'url1'
          item :url2, nil, :name => 'url2'
        end
      end

      result = view_object.navigation_for :menu, as: :bootstrap_tabs
      expect(result).to have_tag("ul", with: { class: "nav nav-tabs pull-left" }) do
        with_tag("li") do
          with_tag("a", with: { href: "url1" }, text: "url1")
        end
        with_tag("li", text: "url2")
      end
    end

  end
end
