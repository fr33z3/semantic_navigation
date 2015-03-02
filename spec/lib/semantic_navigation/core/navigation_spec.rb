require 'spec_helper'

describe SemanticNavigation::Core::Navigation do

  describe '#initialize' do

    it 'creates instance of navigation with level 0 and empty subitems' do
      navigation = SemanticNavigation::Core::Navigation.new({})
      navigation.level.should == 0

      expect(navigation.sub_elements).to be_empty
    end

    it 'creates instance and save sended options' do
      navigation = SemanticNavigation::Core::Navigation.new :id => :some_id,
                                                            :classes => [:one, :two]
      navigation.id.should == :some_id

      expect(navigation.classes).to eq [:one, :two]
    end

    it 'creates instance and save unintended properties' do
      navigation = SemanticNavigation::Core::Navigation.new :some_attribute => :some_value

      expect(navigation.instance_variable_get("@some_attribute")).to eq :some_value
    end

  end

  describe '#item' do
    before :each do
      @navigation = SemanticNavigation::Core::Navigation.new({})
    end

    it "receives item method and make the leaf" do
      @navigation.item :some_id, 'some_url'
      @navigation.sub_elements.size.should == 1

      expect(@navigation.sub_elements.first).to be_is_a(SemanticNavigation::Core::Leaf)
    end

    it "receives item method with block and create node" do
      @navigation.item :node_id, 'node_url' do
        item :leaf_id, 'leaf_url'
      end
      @navigation.sub_elements.size.should == 1

      expect(@navigation.sub_elements.first).to be_is_a(SemanticNavigation::Core::Node)
    end

    it "receives item method with array of urls and save them properly" do
      @navigation.item :leaf_id, ['string/url',"controller#action",:symbolic_name,['array','like','url']]
      urls = @navigation.sub_elements.first.instance_variable_get("@url")

      expect(urls).to eq ['string/url',
                         {:controller => 'controller', :action => 'action'},
                         :symbolic_name,
                         ['array','like','url']]
    end

    it "receives item with Proc url and decode it to normal url (leaf)" do
      @navigation.item :leaf_id, proc{'some' + 'func'}

      expect(@navigation.sub_elements.first.url).to eq 'somefunc'
    end

    it 'receives item with array of urls one of each is a Proc (leaf)' do
      @navigation.item :leaf_id, ['string_url',proc{'some' + 'func'}]
      urls = @navigation.sub_elements.first.send :urls

      expect(urls).to eq ['string_url', 'somefunc']
    end

    it "receives item with Proc url and decode it to normal url (node)" do
      @navigation.item :leaf_id, proc{'some' + 'func'} do
        item :first_value, '#'
        item :second_value, '#'
      end

      expect(@navigation.sub_elements.first.url).to eq 'somefunc'
    end

    it 'receives item with array of urls one of each is a Proc (node)' do
      @navigation.item :leaf_id, ['string_url',proc{'some' + 'func'}] do
        item :first_value, '#'
        item :second_value, '#'
      end
      urls = @navigation.sub_elements.first.send :urls

      expect(urls).to eq ['string_url', 'somefunc']
    end
  end

  describe '#header' do
    before :each do
      @navigation = SemanticNavigation::Core::Navigation.new({})
      @navigation.header :some_id
    end

    it "creates item with nil url" do
      expect(@navigation.sub_elements.size).to eq 1
      expect(@navigation.sub_elements.first.url).to be_nil
    end
  end

  describe "#divider" do
    before :each do
      @navigation = SemanticNavigation::Core::Navigation.new({})
    end

    it "creates divider item with nil url and name" do
      @navigation.divider
      expect(@navigation.sub_elements.size).to eq 1
      expect(@navigation.sub_elements.first.url).to be_nil
      expect(@navigation.sub_elements.first.name).to be_empty
    end

    it "receives any length method containing char `_` and create divider" do
      (1..10).each do |c|
        @navigation.send ('_'*c).to_sym
      end

      expect(@navigation.sub_elements.size).to eq 10
      expect(@navigation.sub_elements.map(&:id)).to eq [:divider]*10
    end
  end

  describe "#decode_url" do

    before :each do
      @navigation = SemanticNavigation::Core::Navigation.new({})
    end

    it "while creating the item make support for urls in format controller#action" do
      view_object = double

      @navigation.item :some_id, 'controller#action'
      @navigation.sub_elements.size.should == 1

      expect(@navigation.sub_elements.first.url).to eq({:controller => "controller", :action => "action"})
    end
  end

  describe '#render_if' do
    context :returns do
      it 'true if render_if proc is nil' do
        navigation = SemanticNavigation::Core::Navigation.new({})

        expect(navigation.render_if).to eq true
      end

      it 'true if render_if proc return true' do
        navigation = SemanticNavigation::Core::Navigation.new({:render_if => [proc{true}]})
        expect(navigation.render_if).to eq true
      end

      it 'false if render_if proc return false' do
        navigation = SemanticNavigation::Core::Navigation.new({:render_if => [proc{false}]})
        expect(navigation.render_if).to eq false
      end

    end

    context :passes do
      it 'self to passed proc' do
        navigation = SemanticNavigation::Core::Navigation.new({:id => :some_id, :render_if => [proc{|o| o.id == :some_id}]})
        expect(navigation.render_if).to eq true
        navigation = SemanticNavigation::Core::Navigation.new({:id => :another_id, :render_if => [proc{|o| o.id == :some_id}]})
        expect(navigation.render_if).to eq false
      end
    end
  end

  describe '#render' do
    it 'calls renderer class :render_navigation method' do
      renderer = double
      navigation = SemanticNavigation::Core::Navigation.new({})
      renderer.should_receive(:render_navigation).with(navigation)
      navigation.render(renderer)
    end
  end

  describe '#mark_active' do
    before :each do
      @navigation = SemanticNavigation::Core::Navigation.new({})

      @view_object = double
      SemanticNavigation::Configuration.stub(:view_object).and_return @view_object
    end

    it 'defines @active variable to false if no sub_elemetns' do
      @navigation.mark_active
      @navigation.instance_variable_get("@active").should be false
    end

    it 'defines @active variable to true if at least one sub_element is active' do
      @navigation.item :first_item, '111'
      @navigation.item :second_item, '222'
      @view_object.should_receive(:current_page?).with('111').and_return true
      @view_object.should_receive(:current_page?).with('222').and_return false

      @navigation.mark_active
    end

    it 'defines @active variable to false if all sub_elements is unactive' do
      @navigation.item :first_item, '333'
      @navigation.item :secodn_item, '444'
      @view_object.should_receive(:current_page?).with('333').and_return false
      @view_object.should_receive(:current_page?).with('444').and_return false

      @navigation.mark_active
    end

    it 'uses custom current_page? for Hash url params' do
      @navigation.item :first_item, {:controller => "controller1", :action => "action"}
      @navigation.item :second_item, {:controller => "controller2", :action => "action"}
      @view_object.stub(:params).and_return({:controller => "controller1", :action => "action", :some_other_params => "blablabla"})

      @navigation.mark_active
      expect(@navigation.sub_elements[0].active).to eq true
      expect(@navigation.sub_elements[1].active).to eq false
    end

    it 'works for route like urls as good as for Hash url params' do
      @navigation.item :first_item, "controller1#action"
      @navigation.item :second_item, "controller2#action"
      @view_object.stub(:params).and_return({:controller => "controller1", :action => "action", :some_other_params => "blablabla"})

      @navigation.mark_active
      expect(@navigation.sub_elements[0].active).to eq true
      expect(@navigation.sub_elements[1].active).to eq false
    end

  end

  describe "#scope" do
    before :each do
      @navigation = SemanticNavigation::Core::Navigation.new({})

      @view_object = double
      SemanticNavigation::Configuration.stub(:view_object).and_return @view_object
    end

    it "scopes the items" do
      @navigation.scope do
        item :first_item,  "controller1#action"
        item :second_item, "controller2#action"
      end

      @navigation.sub_elements.size.should == 2
    end

    describe ':url' do
      it 'scopes hashed url' do
        @navigation.scope url: {controller: 'common_controller'} do
          item :first_item, {action: 'first_action'}
          item :second_item, {action: 'second_item'}
        end

        @navigation.sub_elements[0..1].each do |element|
          url = element.instance_variable_get(:"@url")
          url[:controller].should == 'common_controller'
        end
      end

      it 'scopes route like urls' do
        @navigation.scope url: {some_attr: 'some_attr'} do
          item :first_item, "controller1#action"
          item :second_item, "controller2#action"
        end

        url1 = @navigation.sub_elements[0].instance_variable_get(:"@url")
        url1.should == {controller: 'controller1', action: 'action', some_attr: 'some_attr'}
        url2 = @navigation.sub_elements[1].instance_variable_get(:"@url")
        url2.should == {controller: 'controller2', action: 'action', some_attr: 'some_attr'}
      end

      it 'scopes array of urls' do
        @navigation.scope url: {some_attr: 'some_attr'} do
          item :item, ["controller#action1", "controller#action2"]
        end

        urls = @navigation.sub_elements[0].instance_variable_get(:"@url")
        urls[0].should == {controller: 'controller', action: 'action1', some_attr: 'some_attr'}
        urls[1].should == {controller: 'controller', action: 'action2', some_attr: 'some_attr'}
      end

      it "can't override defined url attributes" do
        @navigation.scope url: {some_attr: 'some_attr'} do
          item :item, {controller: 'controller', action: 'action', some_attr: 'old_attr'}
        end

        url = @navigation.sub_elements[0].instance_variable_get(:"@url")
        url[:some_attr].should == 'old_attr'
      end
    end

    describe ':render_if' do


      it "scopes the creating items options" do
        some_condition = double
        @navigation.scope :render_if => some_condition do
          item :first_item, "controller1#action"
          item :second_item, "controller2#action"
        end

        @navigation.sub_elements[0..1].each do |element|
          element.instance_variable_get(:"@render_if").should == [some_condition]
        end
      end

      it "doesnt scope unscoped items" do
        some_condition = double
        @navigation.scope render_if: some_condition do
          item :first_item, "controller1#action"
          item :second_item, "controller2#action"
        end
        @navigation.item :third_item, "controller3#action"

        last_item = @navigation.sub_elements.last
        last_item.instance_variable_get(:"@render_if").should == []
      end

      it "doesnt override defined scopes" do
        some_condition = double
        some_condition2 = double
        @navigation.scope :render_if => some_condition do
          item :first_item, "controller1#action", render_if: some_condition2
          item :second_item, "controller2#action"
        end

        first_item = @navigation.sub_elements.first
        second_item = @navigation.sub_elements.last

        first_item.instance_variable_get(:"@render_if").should == [some_condition2, some_condition]
        second_item.instance_variable_get(:"@render_if").should == [some_condition]
      end
    end

  end

  describe '#method_missing' do
    it 'gets unknown method and call super' do
      @navigation = SemanticNavigation::Core::Navigation.new({})
      lambda{@navigation.unknow_method}.should raise_exception
    end
  end

end
