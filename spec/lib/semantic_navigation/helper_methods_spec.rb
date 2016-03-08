require "spec_helper"

RSpec.describe SemanticNavigation::HelperMethods do
  include_context "view_object"

  describe "#navigation_for" do
    let(:config_instance) { double }

    before do
      allow(SemanticNavigation::Configuration).to receive(:new).and_return config_instance
    end

    it "default renderer is :list" do
      expect(config_instance).to receive(:render).with(:some_menu, :list, {}, view_object)
      view_object.navigation_for :some_menu
    end

    context :sends do
      it "defined renderer name" do
        expect(config_instance).to receive(:render).with(:some_menu, :some_renderer, {}, view_object)
        view_object.navigation_for :some_menu, as: :some_renderer
      end

      it "received properties" do
        expect(config_instance).to receive(:render).with(:some_menu, :some_renderer, { level: 1, except_for: :some_id }, view_object)
        view_object.navigation_for :some_menu, as: :some_renderer, level: 1, except_for: :some_id
      end
    end
  end

  describe "#active_item_for" do
    context :returns do
      it "empty string if navigation is empty from items" do
        SemanticNavigation::Configuration.navigate :some_menu do
        end
        expect(view_object.active_item_for :some_menu).to be_empty
      end

      it "name for an active item" do
        SemanticNavigation::Configuration.navigate :some_menu do
          item :first, "/first", name: "First"
          item :second, "/second", name: "Second"
        end
        allow(view_object).to receive(:current_page?).with("/first").and_return false
        allow(view_object).to receive(:current_page?).with("/second").and_return true
        expect(view_object.active_item_for :some_menu).to eq "Second"
      end

      it "name for a last level" do
        SemanticNavigation::Configuration.navigate :some_menu do
          item :first_node, "/first_node", name: "First node" do
            item :first, "/first", name: "First"
          end
          item :second_node, "/second_node", name: "Second node" do
            item :second, "/second", name: "Second"
          end
        end
        allow(view_object).to receive(:current_page?).exactly(4).times.and_return(false, false,true,false)
        expect(view_object.active_item_for :some_menu).to eq "Second"
      end

      it "name for a requested level" do
        SemanticNavigation::Configuration.navigate :some_menu do
          item :first_node, "/first_node", name: "First node" do
            item :first, "/first", name: "First"
          end
          item :second_node, "second_node", name: "Second node" do
            item :second, "/second", name: "Second"
          end
        end
        allow(view_object).to receive(:current_page?).exactly(4).times.and_return(false, false,true,false)
        expect(view_object.active_item_for :some_menu, 1).to eq "Second node"
      end
    end
  end

end
