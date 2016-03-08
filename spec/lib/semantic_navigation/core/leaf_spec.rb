require "spec_helper"

RSpec.describe SemanticNavigation::Core::Leaf do
  let(:leaf_class) { SemanticNavigation::Core::Leaf }

  describe "#name" do
    context :returns do
      it "saved name" do
        leaf = leaf_class.new({ id: :first, name: "first" }, 1)
        expect(leaf.name).to eq "first"
      end

      it "basic name even if renderer name sended" do
        leaf = leaf_class.new({ id: :first, name: "first" }, 1)
        expect(leaf.name(:renderer_name)).to eq "first"
      end

      it "the name for renderer" do
        leaf = leaf_class.new({
          id: :first,
          name: { some_renderer: "some_renderer_name"}
        }, 1)
        expect(leaf.name(:some_renderer)).to eq "some_renderer_name"
      end

      it "default name for unexpected renderer" do
        leaf = leaf_class.new({
          id: :first,
          name: {default: "default_name", some_renderer: "some_renderer_name"}
        }, 1)
        expect(leaf.name(:unexpected_renderer)).to eq "default_name"
      end

      it "nil if no name defined" do
        leaf = leaf_class.new({id: :first}, 1)
        expect(leaf.name).to be_empty
      end

      it "i18n name if @name is nil" do
        leaf = leaf_class.new({ id: :first, i18n_name: "some_navigation" }, 1)
        expect(I18n).to receive(:t).with("some_navigation.first", {default: ""}).and_return "first"
        expect(leaf.name).to eq "first"
      end

      it "i18n_name if @name is even if renderer name is sended" do
        leaf = leaf_class.new({id: :first, :i18n_name => "some_navigation"},1)
        I18n.should_receive(:t).with("some_navigation.first", {:default => ""}).and_return "first"
        leaf.name(:renderer_name).should == "first"
      end

      it "i18n_name for requested renderer" do
        leaf = leaf_class.new({id: :first, :i18n_name => "some_navigation"},1)
        I18n.should_receive(:t).with("some_navigation.first", {:default => ""}).and_return({:requested_renderer => "requested_renderer_name"})
        leaf.name(:requested_renderer).should == "requested_renderer_name"
      end

      it "default i18n_name for unexpected renderer" do
        leaf = leaf_class.new({id: :first, :i18n_name => "some_navigation"},1)
        I18n.should_receive(:t).with("some_navigation.first", {:default => ""}).and_return({:default => "default_name", :requested_renderer => "requested_renderer_name"})
        leaf.name(:unexpected_renderer).should == "default_name"
      end

      it "empty string if default i18n_name was not defined" do
        leaf = leaf_class.new({id: :first, :i18n_name => "some_navigation"},1)
        I18n.should_receive(:t).with("some_navigation.first", {:default => ""}).and_return({:requested_renderer => "requested_renderer_name"})
        leaf.name(:unexpected_renderer).should == ""
      end

      it "result of proc block if name is_a? proc" do
        leaf = leaf_class.new({:name => proc{["first", "item"].join(" ")}},1)
        leaf.name.should == "first item"
      end

    end
  end

  describe "#url" do
    it "returns passed url" do
      leaf = leaf_class.new({:url => {:controller => "controller", :action => "action"}},1)
      leaf.url.should == {:controller => "controller", :action => "action"}
    end

    it "returns first url if passed array of urls" do
      leaf = leaf_class.new({:url => [{:controller => "controller1", :action => "action"},
                                                          {:controller => "controller2", :action => "action"}]},1)
      leaf.url.should == {:controller => "controller1", :action => "action"}
    end
  end

  describe "#mark_active" do

    before :each do
      @view_object = double
      allow(SemanticNavigation::Configuration).to receive(:view_object).and_return @view_object
    end

    context :marked do

      it "as active even if controller name starts from `/`" do
        leaf = leaf_class.new({url: {controller: "/first", action: "index"}}, 1)
        @view_object.stub(:params).and_return({controller: "first", action: "index"})

        expect(leaf.mark_active).to eq true
        expect(leaf.active).to eq true
      end

      it "as active if have active url with symbol names" do
        leaf = leaf_class.new({:url => {:controller => :first, :action => :index}}, 1)
        @view_object.stub(:params).and_return({:controller => "first", :action => "index"})

        expect(leaf.mark_active).to eq true
        expect(leaf.active).to eq true
      end

      it "as active if have active url with string names" do
        leaf = leaf_class.new({:url => {:controller => "first", :action => "index"}}, 1)
        @view_object.stub(:params).and_return({:controller => "first", :action => "index"})

        expect(leaf.mark_active).to eq true
        expect(leaf.active).to eq true
      end

      it "as inactive if have inactive url with symbol names" do
        leaf = leaf_class.new({:url => {:controller => :first, :action => :index}}, 1)
        @view_object.stub(:params).and_return({controller: "second", action: "index"})
        expect(leaf.mark_active).to eq false
        expect(leaf.active).to eq false
      end

      it "as inactive if have inactive url with string names" do
        leaf = leaf_class.new({:url => {:controller => "first", :action => "index"}}, 1)
        @view_object.stub(:params).and_return({controller: "second", action: "index"})

        expect(leaf.mark_active).to eq false
        expect(leaf.active).to eq false
      end

      it "as inactive if have nil url" do
        leaf = leaf_class.new({},1)

        expect(leaf.mark_active).to eq false
        expect(leaf.active).to eq false
      end

      it "as active if at least one url in passed array is active" do
        leaf = leaf_class.new({:url => [{:controller => :leaf_controller1, :action => :action},
                                                            {:controller => :leaf_controller2, :action => :action}]},1)
        @view_object.stub(:params).and_return(:controller => "leaf_controller2", :action => "action")

        leaf.mark_active
        expect(leaf.active).to eq true
      end

    end

    it "accepts array like urls with other urls" do
      leaf = leaf_class.new({:url => [["url","with","id"],
                                                          :symbol_url_name,
                                                          {:controller => "hash", :action => "url"},
                                                          "string_url"]}, 1)
      leaf.should_receive(:current_page?).with(["url","with","id"])
      leaf.should_receive(:current_page?).with(:symbol_url_name)
      leaf.should_receive(:current_page?).with({:controller => "hash", :action => "url"})
      leaf.should_receive(:current_page?).with("string_url")
      leaf.mark_active
    end

  end
end
