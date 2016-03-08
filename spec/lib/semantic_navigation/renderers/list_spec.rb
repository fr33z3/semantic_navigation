require 'spec_helper'

describe SemanticNavigation::Renderers::List do
  include_context "view_object"
  let(:configuration) { SemanticNavigation::Configuration }

  context :renders do

    before :each do
      configuration.run do
        register_renderer :list, SemanticNavigation::Renderers::List
      end
    end

    it 'empty ul tag for empty navigation' do
      configuration.run do
        navigate :menu do
        end
      end

      result = view_object.navigation_for :menu
      expect(result).to have_tag("ul", with: { class: "list", id: "menu" }, text: "")
    end

    it 'one level navigation' do
      configuration.run do
        navigate :menu do
          item :url1, 'url1', :name => 'url1'
          item :url2, 'url2', :name => 'url2'
        end
      end

      result = view_object.navigation_for :menu
      expect(result).to have_tag("ul", with: { class: "list", id: "menu" }) do
        with_tag("li", with: { id: "url1" }) do
          with_tag("a", with: { href: "url1", id: "url1" }, text: "url1")
        end
        with_tag("li", with: { id: "url2" }) do
          with_tag("a", with: { href: "url2", id: "url2" }, text: 'url2')
        end
      end
    end

    it 'one level navigation with specific menu tag' do
      configuration.run do

        register_renderer :my_list, :list

        styles_for :my_list do
          menu_tag :ol
        end

        navigate :menu do
          item :url1, 'url1', :name => 'url1'
          item :url2, 'url2', :name => 'url2'
        end
      end

      result = view_object.navigation_for :menu, as: :my_list
      expect(result).to have_tag("ol", with: { class: "list", id: "menu" }) do
        with_tag("li", with: { id: "url1" }) do
          with_tag("a", with: { href: "url1", id: "url1" }, text: "url1")
        end
        with_tag("li", with: { id: "url2" }) do
          with_tag("a", with: { href: "url2", id: "url2" }, text: "url2")
        end
      end
    end

    it "one level navigation with specific menu tag" do
      configuration.run do
        register_renderer :my_list, :list

        styles_for :my_list do
          menu_tag :ol
        end

        navigate :menu do
          item :url1, 'url1', :name => 'url1' do
            item :url2, 'url2', :name => 'url2'
          end
        end
      end

      result = view_object.navigation_for :menu, as: :my_list
      expect(result).to have_tag("ol", with: { class: "list", id: "menu" }) do
        have_tag("li", with: { id: "url1" }) do
          have_tag("a", with: { href: "url1", id: "url1" }, text: "url1")
          have_tag("ol", with: { id: "url1" }) do
            have_tag("li", with: { id: "url2" }) do
              have_tag("a", with: { href: "url2", id: "url2" }, text: "url2")
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

      result = view_object.navigation_for :menu
      expect(result).to have_tag("ul", with: { class: "list", id: 'menu' }) do
        with_tag("li", with: { id: "url1"}) do
          with_tag("a", with: { href: "url1", id: "url1" }, text: "url1")
          with_tag("ul", with: { id: "url1" }) do
            with_tag("li", with: { id: "suburl1" }) do
              with_tag("a", with: { href: "suburl1", id: "suburl1" }, text: "suburl1")
            end
          end
        end
        with_tag("li", with: { id: "url2" }) do
          with_tag("a", with: { href: "url2", id: "url2" }, text: "url2")
          with_tag("ul", with: { id: "url2" }) do
            with_tag("li", with: { id: "suburl2" }) do
              with_tag("a", with: { href: "suburl2", id: "suburl2" }, text: "suburl2")
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

      result = view_object.navigation_for :menu, :level => 0
      expect(result).to have_tag("ul", with: { class: "list", id: "menu" }) do
        with_tag("li", with: { id: "url1" }) do
          with_tag("a", with: { href: "url1", id: "url1" }, text: "url1")
        end
        with_tag("li", with: { id: "url1" }) do
          with_tag("a", with: { href: "url2", id: "url2" }, text: "url2")
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

      view_object.should_receive(:current_page?).and_return(false, true, false, false)

      result = view_object.navigation_for :menu, :level => 1
      expect(result).to have_tag("ul", with: { class: "list active", id: "menu" }) do
        with_tag("li", with: { id: "suburl1" }) do
          with_tag("a", with: { href: "suburl1" }, text: "suburl1")
        end
      end
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

      #NOTE: this gem does not check the level and ordering
      result = view_object.navigation_for :menu, levels: 0..1
      expect(result).to have_tag("ul", with: { class: "list", id: "menu" }) do
        with_tag("li", with: { id: "url1" }) do
          with_tag("a", with: { href: "url1", id: "url1" }, text: "url1")
          with_tag("ul", with: { id: "url1" }) do
            with_tag("li", with: { id: "suburl1" }) do
              with_tag("a", with: { id: "suburl1", href: "suburl1" }, text: "suburl1")
            end
          end
        end
        with_tag("li", with: { id: "url2" }) do
          with_tag("a", with: { href: "url2", id: "url2" }, text: "url2")
          with_tag("ul", with: { id: "url2" }) do
            with_tag("li", with: { id: "suburl2" }) do
              with_tag("a", with: { id: "suburl2", href: "suburl2" }, text: "suburl2")
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

      result = view_object.navigation_for :menu, :except_for => [:url1]
      expect(result).to have_tag("ul", with: { class: "list", id: "menu" }) do
        with_tag("li", with: { id: "url2" }) do
          with_tag("a", with: { href: "url2", id: "url2" }, text: "url2")
        end
        with_tag("ul", with: { id: "url2" }) do
          with_tag("li", with: { id: "suburl2" }) do
            with_tag("a", with: { id: "suburl2", href: "suburl2" }, text: "suburl2")
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

      result = view_object.navigation_for :menu, :except_for => [:suburl1,:url2]
      expect(result).to have_tag("ul", with: { class: "list", id: "menu" }) do
        have_tag("li", with: { id: "url1" }) do
          with_tag("a", with: { href: "url1", id: "url1" }, text: "url1")
        end
        have_tag("ul", with: { id: "url1" })
      end
    end

    it 'considers scopes' do
      allow(view_object).to receive(:role?).with('manager').and_return false
      allow(view_object).to receive(:role?).with('trader').and_return true
      configuration.run do
        navigate :menu do
          item :trader_space, '#', render_if: proc{role?('trader')} do
          end

          scope render_if: proc{role?('manager')} do
            divider
            item :manager_space, '#' do
              item :one, 'url1'
              item :two, 'url2'
            end
          end
        end
      end

      allow(view_object).to receive(:current_page?).and_return false
      allow(view_object).to receive(:current_page?).with("url1").and_return true

      result = view_object.navigation_for :menu, from_level: 1
      expect(result).to have_tag("ul", with: { class: "list active", id: "menu" })
    end

  end
end
