require 'spec_helper'

describe SemanticNavigation::HelperMethods do
  before :each do
    class ViewObject
      include SemanticNavigation::HelperMethods
    end
    @view_instance = ViewObject.new
  end

  describe "#navigation_for" do

    before :each do
      allow(SemanticNavigation::Configuration).to receive(:new).and_return (@config_instance = double)
    end

    it 'default renderer is :list' do
      @config_instance.should_receive(:render).with(:some_menu, :list, {}, @view_instance)
      @view_instance.navigation_for :some_menu
    end

    context :sends do

      it 'defined renderer name' do
        @config_instance.should_receive(:render).with(:some_menu, :some_renderer, {}, @view_instance)
        @view_instance.navigation_for :some_menu, :as => :some_renderer
      end

      it 'received properties' do
        @config_instance.should_receive(:render).with(:some_menu, :some_renderer, {:level => 1, :except_for => :some_id}, @view_instance)
        @view_instance.navigation_for :some_menu, :as => :some_renderer, :level => 1, :except_for => :some_id
      end
    end
  end

  describe "#active_item_for" do

    context :returns do

      it 'empty string if navigation is empty from items' do
        SemanticNavigation::Configuration.navigate :some_menu do
        end
        result = @view_instance.active_item_for :some_menu
        result.should be_empty
      end

      it 'name for an active item' do
        SemanticNavigation::Configuration.navigate :some_menu do
          item :first, '/first', :name => 'First'
          item :second, '/second', :name => 'Second'
        end
        @view_instance.should_receive(:current_page?).with('/first').and_return false
        @view_instance.should_receive(:current_page?).with('/second').and_return true
        result = @view_instance.active_item_for :some_menu
        result.should == 'Second'
      end

      it 'name for a last level' do
        SemanticNavigation::Configuration.navigate :some_menu do
          item :first_node, '/first_node', :name => 'First node' do
            item :first, '/first', :name => 'First'
          end
          item :second_node, 'second_node', :name => 'Second node' do
            item :second, '/second', :name => 'Second'
          end
        end
        @view_instance.should_receive(:current_page?).exactly(4).times.and_return(false, false,true,false) # First, First node, Second, Second node
        result = @view_instance.active_item_for :some_menu
        result.should == 'Second'
      end

      it 'name for a requested level' do
        SemanticNavigation::Configuration.navigate :some_menu do
          item :first_node, '/first_node', :name => 'First node' do
            item :first, '/first', :name => 'First'
          end
          item :second_node, 'second_node', :name => 'Second node' do
            item :second, '/second', :name => 'Second'
          end
        end
        @view_instance.should_receive(:current_page?).exactly(4).times.and_return(false, false,true,false) # First, First node, Second, Second node
        result = @view_instance.active_item_for :some_menu, 1
        result.should == 'Second node'
      end
    end
  end

end
