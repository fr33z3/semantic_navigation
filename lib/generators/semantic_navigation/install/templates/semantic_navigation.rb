SemanticNavigation::Configuration.run do
  
  styles_for :navigation, :menu, bootstrap_default_menu
  
  navigate :navigation do
    first_item 'First Item', '/' do 
      sub_item 'Sub Item', '/sub_item' do
        third_item 's', '/s'
      end
      second_sub 'Second Sub', '/sdf'
      sub_sub '123123', nil
    end
    second_item 'Second Item','/sub_item'
  end
end

