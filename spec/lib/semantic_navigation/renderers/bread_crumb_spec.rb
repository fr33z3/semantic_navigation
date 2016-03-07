require 'spec_helper'

RSpec.describe SemanticNavigation::Renderers::BreadCrumb do
  include_context "view_object"
  let(:configuration) { SemanticNavigation::Configuration }

  before do
    configuration.register_renderer :breadcrumb, SemanticNavigation::Renderers::BreadCrumb
  end

  context "empty navigation" do
    subject { view_object.navigation_for(:menu, as: :breadcrumb) }
    include_context "empty_navigation"

    it { is_expected.to have_tag("ul") }
    it { is_expected.to have_tag("ul", with: { id: "menu" }) }
    it { is_expected.to have_tag("ul", with: { class: "breadcrumb" }) }
    it { is_expected.to have_tag("ul", with: { id: "menu", class: "breadcrumb" }, text: "") }
  end

  context "one level navigation breadcrumb" do
    subject { view_object.navigation_for(:menu, as: :breadcrumb) }
    include_context "one_level_navigation"

    context "when second page is current" do
      before do
        allow(view_object).to receive(:current_page?).and_return(false, true)
      end

      it { is_expected.to have_tag("ul") }
      it "renders breadcrumb" do
        is_expected.to have_tag("ul", with: {id: "menu", class: "breadcrumb"}) do
          with_tag("li", with: { id: "url2" }, text: "url2")
        end
      end
    end

    context "when no any current page" do
      before do
        allow(view_object).to receive(:current_page?).and_return(false)
      end

      it { is_expected.to have_tag("ul", with: { id: "menu", class: "breadcrumb" }, text: "") }
    end
  end

  context "with specific html tag" do
    subject { view_object.navigation_for :menu, as: :my_breadcrumb }
    include_context "one_level_navigation"

    before do
      configuration.run do
        register_renderer :my_breadcrumb, :breadcrumb
        styles_for(:my_breadcrumb) { menu_tag :ol }
      end

      allow(view_object).to receive(:current_page?).and_return(false, true)
    end

    it "renders proper breadcramb" do
      is_expected.to have_tag("ol", with: {id: "menu", class: "breadcrumb"}) do
        with_tag("li", with: { id: "url2" }, text: "url2")
      end
    end

    context "when no any current page" do
      before do
        allow(view_object).to receive(:current_page?).and_return(false)
      end

      it { is_expected.to have_tag("ol", with: { id: "menu", class: "breadcrumb" }, text: "") }
    end
  end

  context "multilevel navigation breadcrumb" do
    subject { view_object.navigation_for :menu, as: :breadcrumb }
    include_context "two_level_navigation"

    before do
      allow(view_object).to receive(:current_page?).and_return(true, false, false, false)
    end

    it { is_expected.to have_tag("ul", with: { id: "menu", class: "breadcrumb" }) }
    it "renders proper navigation" do
      is_expected.to have_tag("ul", with: { id: "menu", class: "breadcrumb" }) do
        with_tag("li", with: { id: "url1" }) do
          with_tag("a", with: { id: "url1", href: "url1" }, text: "url1")
        end
        with_tag("li", text: "/")
        with_tag("li", with: { id: "suburl1"}, text: "suburl1")
      end
    end

    context "when no any current page" do
      before do
        allow(view_object).to receive(:current_page?).and_return(false)
      end

      it "renders empty navigation" do
        is_expected.to have_tag("ul", with: { id: "menu", class: "breadcrumb" }, text: "")
      end
    end

    context "when last_as_link is true" do
      subject { view_object.navigation_for :menu, as: :breadcrumb, last_as_link: true }

      it "renders proper breadcrumb" do
        is_expected.to have_tag("ul", with: { id: "menu", class: "breadcrumb"}) do
          with_tag("li", with: { id: "url1" }) do
            with_tag("a", with: { id: "url1", href: "url1" }, text: "url1")
          end
          with_tag("li", text: "/")
          with_tag("li", with: { id: "suburl1" }) do
            with_tag("a", with: { id: "suburl1", href: "suburl1" }, text: "suburl1")
          end
        end
      end
    end
  end

  context "rendering levels" do
    include_context "two_level_navigation"

    before do
      allow(view_object).to receive(:current_page?).and_return(true, false, false, false)
    end

    context "root level" do
      subject { view_object.navigation_for :menu, level: 0, as: :breadcrumb }

      it "renders only root level" do
        is_expected.to have_tag("ul", with: { id: "menu", class: "breadcrumb" }) do
          with_tag("li", with: { id: "url1" }, text: "url1")
        end
      end
    end

    context "second level" do
      subject { view_object.navigation_for :menu, level: 1, as: :breadcrumb }

      it "renders only second level" do
        is_expected.to have_tag("ul", with: { id: "menu", class: "breadcrumb" }) do
          with_tag("li", with: { id: "suburl1" }, text: "suburl1")
        end
      end
    end

    context "exact levels" do
      subject { view_object.navigation_for :menu, levels: 0..1, as: :breadcrumb }

      it "renders exact levels" do
        is_expected.to have_tag("ul", with: { id: "menu", class: "breadcrumb" }) do
          with_tag("li", with: { id: "url1" }) do
            with_tag("a", with: { id: "url1", href: "url1" }, text: "url1")
          end
          with_tag("li", text: "/")
          with_tag("li", with: { id: "suburl1" }, text: "suburl1")
        end
      end
    end

    context "except some level" do
      subject { view_object.navigation_for :menu, except_for: [:suburl1], as: :breadcrumb }

      it "renders navigation except some level" do
        is_expected.to have_tag("ul", with: { id: "menu", class: "breadcrumb" }) do
          with_tag("li", with: { id: "url1" }, text: "url1")
        end
      end
    end
  end
end
