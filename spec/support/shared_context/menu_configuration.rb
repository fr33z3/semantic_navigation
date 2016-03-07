RSpec.shared_context "empty_navigation" do
  before do
    SemanticNavigation::Configuration.run do
      navigate(:menu) { }
    end
  end
end

RSpec.shared_context "one_level_navigation" do
  before do
    SemanticNavigation::Configuration.run do
      navigate :menu do
        item :url1, "url1", name: "url1"
        item :url2, "url2", name: "url2"
      end
    end
  end
end

RSpec.shared_context "two_level_navigation" do
  before do
    configuration.run do
      navigate :menu do
        item :url1, "url1", name: "url1" do
          item :suburl1, "suburl1", name: "suburl1"
        end
        item :url2, "url2", name: "url2" do
          item :suburl2, "suburl2", name: "suburl2"
        end
      end
    end
  end
end
