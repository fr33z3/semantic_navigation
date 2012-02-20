require 'spec_helper'

describe SemanticNavigation::Item do
  
  it 'should create instance' do
    SemanticNavigation::Item.new({},nil).is_a?(SemanticNavigation::Item).should == true
  end
  
  it 'should set local variables through options variable' do
    options = {:item_id => 'new_item_id',
               :name => 'new_name'}
    item = SemanticNavigation::Item.new(options,nil)
    item.item_id.should == 'new_item_id'
    item.name.should == 'new_name'
    item.instance_variable_get('@item_disabled').should == true
  end
  
  it 'should set as active if `current_page?` is true' do
    view_object = mock
    view_object.should_receive(:current_page?).and_return true
    SemanticNavigation::Configuration.view_object = view_object 
    item = SemanticNavigation::Item.new({:url => '/dashboard'},nil)
    item.active.should == true
  end
  
  it 'should set as inactive if `current_page?` is false' do
    view_object = mock
    view_object.should_receive(:current_page?).and_return false
    SemanticNavigation::Configuration.view_object = view_object
    item = SemanticNavigation::Item.new({:url => '/dashboard'},nil)
    item.active.should == false
  end
  
  it 'method menu should render item with sub_menu' do
    sub_menu = mock
    sub_menu.should_receive(:menu).and_return("<sub_menu>")
    view_object = mock
    view_object.should_receive(:current_page?).and_return true
    view_object.should_receive(:link_to).with("new name","/dashboard").and_return "<link>"
    view_object.should_receive(:content_tag).with(:li,"<link><sub_menu>",{:id => "new_id", :class => ["active"]}).and_return "<li with link>"
    SemanticNavigation::Configuration.view_object = view_object 
    item = SemanticNavigation::Item.new({:item_id => 'new_id',
                                         :name => 'new name',
                                         :url => '/dashboard'},sub_menu)
    item.menu.should == '<li with link>'
  end
  
  it 'method menu should render item without submenu' do
    view_object = mock
    view_object.should_receive(:current_page?).and_return true
    view_object.should_receive(:link_to).with("new name","/dashboard").and_return "<link>"
    view_object.should_receive(:content_tag).with(:li,"<link>",{:id => "new_id", :class => ["active"]}).and_return "<li with link>"
    SemanticNavigation::Configuration.view_object = view_object 
    item = SemanticNavigation::Item.new({:item_id => 'new_id',
                                         :name => 'new name',
                                         :url => '/dashboard'},nil)
    item.menu.should == '<li with link>'
  end
end