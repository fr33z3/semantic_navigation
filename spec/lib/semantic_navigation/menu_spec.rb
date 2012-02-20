require 'spec_helper'

describe SemanticNavigation::Menu do
  
  it 'should create instance' do
    SemanticNavigation::Menu.new({}).is_a?(SemanticNavigation::Menu).should == true
  end
  
  it 'should set local variables through options variable' do
    options = {:menu_id => 'new_menu_id'}
    menu = SemanticNavigation::Menu.new(options)
    menu.menu_id.should == 'new_menu_id'
  end
  
  it 'should create item set' do
    view_object = mock
    view_object.should_receive(:current_page?).with('/1').and_return true
    view_object.should_receive(:current_page?).with('/2').and_return false
    view_object.should_receive(:current_page?).with('/3').and_return false
    SemanticNavigation::Configuration.view_object = view_object
    menu = SemanticNavigation::Menu.new({:menu_id => 'new_menu'})
    menu.first('1','/1')
    menu.second('2','/2')
    menu.third('3','/3')
    
    menu.items.count.should == 3
    menu.items[0].active.should == true
    menu.items[1].active.should == false
    menu.items[2].active.should == false
  end
  
end